let pendingFrames = [];
let spsPps = null;
let decoder = null;
let gl = null;
let offscreenCanvas = null;

let width = 1280;
let height = 720;
let windowWidth = 1280;
let windowHeight = 720;

let frameTexture = null;
let renderScheduled = false;
let dropDeltaUntilKeyframe = true;
let nextTimestampUs = 0;

const FRAME_DURATION_US = 33333;
const MAX_RENDER_QUEUE_SIZE = 4;
const MAX_DECODE_QUEUE_SIZE = 8;

let positionLocation = null;
let texcoordLocation = null;
let positionBuffer = null;
let texcoordBuffer = null;

function toSafeNumber(value, fallback) {
  const parsed = Number(value);
  if (Number.isFinite(parsed)) {
    return Math.max(1, Math.round(parsed));
  }
  return Math.max(1, Math.round(fallback));
}

function buildDecoderConfig(spsData) {
  if (!spsData || spsData.length < 8) {
    return null;
  }

  let codec = "avc1.";
  for (let index = 5; index < 8; index += 1) {
    let hex = spsData[index].toString(16);
    if (hex.length < 2) {
      hex = "0" + hex;
    }
    codec += hex;
  }

  return {
    codec: codec,
    codedWidth: width,
    codedHeight: height,
    displayAspectWidth: windowWidth,
    displayAspectHeight: windowHeight,
    hardwareAcceleration: "prefer-hardware",
    optimizeForLatency: true,
  };
}

function configureDecoderFromSpsPps() {
  if (!decoder || decoder.state === "closed" || !spsPps) {
    return;
  }

  const config = buildDecoderConfig(spsPps);
  if (!config) {
    return;
  }

  try {
    decoder.configure(config);
    dropDeltaUntilKeyframe = true;
  } catch (error) {
    self.postMessage({
      error: String(error),
    });
  }
}

function applyRuntimeConfig(config) {
  const runtimeConfig = config || {};
  const nextWidth = toSafeNumber(runtimeConfig.displayWidth, width);
  const nextHeight = toSafeNumber(runtimeConfig.displayHeight, height);
  const nextWindowWidth = toSafeNumber(runtimeConfig.windowWidth, windowWidth);
  const nextWindowHeight = toSafeNumber(runtimeConfig.windowHeight, windowHeight);

  const sizeChanged =
    nextWidth !== width ||
    nextHeight !== height ||
    nextWindowWidth !== windowWidth ||
    nextWindowHeight !== windowHeight;

  width = nextWidth;
  height = nextHeight;
  windowWidth = nextWindowWidth;
  windowHeight = nextWindowHeight;

  if (offscreenCanvas) {
    offscreenCanvas.width = windowWidth;
    offscreenCanvas.height = windowHeight;
  }

  if (gl) {
    gl.viewport(0, 0, windowWidth, windowHeight);
  }

  if (sizeChanged) {
    closeAllPendingFrames();
    configureDecoderFromSpsPps();
  }
}

function closeAllPendingFrames() {
  while (pendingFrames.length > 0) {
    const frame = pendingFrames.shift();
    if (frame && frame.close) {
      frame.close();
    }
  }
}

function getDecodeQueueSize() {
  if (!decoder || typeof decoder.decodeQueueSize !== "number") {
    return 0;
  }
  return decoder.decodeQueueSize;
}

function isDecodeBacklogged() {
  return (
    pendingFrames.length > MAX_RENDER_QUEUE_SIZE ||
    getDecodeQueueSize() > MAX_DECODE_QUEUE_SIZE
  );
}

function scheduleRender() {
  if (renderScheduled) {
    return;
  }
  renderScheduled = true;
  self.setTimeout(renderLatestFrame, 0);
}

function renderLatestFrame() {
  renderScheduled = false;
  if (!gl || pendingFrames.length === 0) {
    return;
  }

  while (pendingFrames.length > 1) {
    const staleFrame = pendingFrames.shift();
    if (staleFrame && staleFrame.close) {
      staleFrame.close();
    }
  }

  const frame = pendingFrames.shift();
  drawImageToCanvas(frame);

  if (pendingFrames.length > 0) {
    scheduleRender();
  }
}

function drawImageToCanvas(image) {
  if (!image || !gl || !frameTexture) {
    if (image && image.close) {
      image.close();
    }
    return;
  }

  gl.bindTexture(gl.TEXTURE_2D, frameTexture);
  gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, image);
  gl.clear(gl.COLOR_BUFFER_BIT);
  gl.drawArrays(gl.TRIANGLES, 0, 6);
  gl.bindTexture(gl.TEXTURE_2D, null);

  if (image.close) {
    image.close();
  }
}

function splitNalUnits(data) {
  const bytes = data instanceof Uint8Array ? data : new Uint8Array(data);
  if (bytes.length < 5) {
    return [];
  }

  const units = [];
  let currentStart = -1;
  let index = 0;

  while (index <= bytes.length - 4) {
    let codeLength = 0;
    if (
      bytes[index] === 0x00 &&
      bytes[index + 1] === 0x00 &&
      bytes[index + 2] === 0x00 &&
      bytes[index + 3] === 0x01
    ) {
      codeLength = 4;
    } else if (
      bytes[index] === 0x00 &&
      bytes[index + 1] === 0x00 &&
      bytes[index + 2] === 0x01
    ) {
      codeLength = 3;
    }

    if (codeLength > 0) {
      if (currentStart >= 0 && index > currentStart) {
        units.push(bytes.subarray(currentStart, index));
      }
      currentStart = index;
      index += codeLength;
      continue;
    }

    index += 1;
  }

  if (currentStart >= 0 && currentStart < bytes.length) {
    units.push(bytes.subarray(currentStart));
  }

  if (units.length === 0) {
    units.push(bytes);
  }

  return units;
}

function getNalType(nal) {
  if (!nal || nal.length < 5) {
    return -1;
  }

  let offset = 0;
  if (
    nal.length >= 4 &&
    nal[0] === 0x00 &&
    nal[1] === 0x00 &&
    nal[2] === 0x00 &&
    nal[3] === 0x01
  ) {
    offset = 4;
  } else if (nal.length >= 3 && nal[0] === 0x00 && nal[1] === 0x00 && nal[2] === 0x01) {
    offset = 3;
  }

  if (offset >= nal.length) {
    return -1;
  }

  return nal[offset] & 0x1f;
}

function appendByteArray(left, right) {
  const merged = new Uint8Array((left.byteLength | 0) + (right.byteLength | 0));
  merged.set(left, 0);
  merged.set(right, left.byteLength | 0);
  return merged;
}

function decodeEncodedNal(nal, isKey) {
  if (!decoder || decoder.state !== "configured") {
    return;
  }

  if (dropDeltaUntilKeyframe && !isKey) {
    return;
  }

  if (isDecodeBacklogged() && !isKey) {
    dropDeltaUntilKeyframe = true;
    return;
  }

  let data = nal;
  if (isKey && spsPps) {
    data = appendByteArray(spsPps, nal);
  }

  const chunk = new EncodedVideoChunk({
    type: isKey ? "key" : "delta",
    timestamp: nextTimestampUs,
    duration: FRAME_DURATION_US,
    data: data,
  });
  nextTimestampUs += FRAME_DURATION_US;

  try {
    decoder.decode(chunk);
    if (isKey) {
      dropDeltaUntilKeyframe = false;
    }
  } catch (error) {
    if (!isKey) {
      dropDeltaUntilKeyframe = true;
    }
    self.postMessage({
      error: String(error),
    });
  }
}

function handleNal(nal) {
  const nalType = getNalType(nal);
  if (nalType === 7) {
    spsPps = nal;
    configureDecoderFromSpsPps();
    return;
  }

  if (nalType === 8) {
    spsPps = spsPps ? appendByteArray(spsPps, nal) : nal;
    return;
  }

  if (nalType === 5) {
    decodeEncodedNal(nal, true);
    return;
  }

  if (nalType === 1) {
    decodeEncodedNal(nal, false);
  }
}

function handleEncodedData(data) {
  const units = splitNalUnits(data);
  for (let index = 0; index < units.length; index += 1) {
    handleNal(units[index]);
  }
}

function initializeGL(glContext) {
  const vertexSource =
    "attribute vec2 a_position;\n" +
    "attribute vec2 a_texCoord;\n" +
    "varying vec2 v_texCoord;\n" +
    "void main() {\n" +
    "  gl_Position = vec4(a_position, 0, 1);\n" +
    "  v_texCoord = a_texCoord;\n" +
    "}";
  const fragmentSource =
    "precision mediump float;\n" +
    "uniform sampler2D u_image;\n" +
    "varying vec2 v_texCoord;\n" +
    "void main() {\n" +
    "  gl_FragColor = texture2D(u_image, v_texCoord);\n" +
    "}";

  const vertexShader = createShader(glContext, glContext.VERTEX_SHADER, vertexSource);
  const fragmentShader = createShader(glContext, glContext.FRAGMENT_SHADER, fragmentSource);

  const program = glContext.createProgram();
  glContext.attachShader(program, vertexShader);
  glContext.attachShader(program, fragmentShader);
  glContext.linkProgram(program);

  positionLocation = glContext.getAttribLocation(program, "a_position");
  texcoordLocation = glContext.getAttribLocation(program, "a_texCoord");

  positionBuffer = glContext.createBuffer();
  glContext.bindBuffer(glContext.ARRAY_BUFFER, positionBuffer);
  glContext.bufferData(
    glContext.ARRAY_BUFFER,
    new Float32Array([-1, -1, 1, -1, -1, 1, -1, 1, 1, -1, 1, 1]),
    glContext.STATIC_DRAW,
  );

  texcoordBuffer = glContext.createBuffer();
  glContext.bindBuffer(glContext.ARRAY_BUFFER, texcoordBuffer);
  glContext.bufferData(
    glContext.ARRAY_BUFFER,
    new Float32Array([0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0]),
    glContext.STATIC_DRAW,
  );

  glContext.viewport(0, 0, windowWidth, windowHeight);
  glContext.clearColor(0, 0, 0, 0);
  glContext.useProgram(program);
  glContext.enableVertexAttribArray(positionLocation);
  glContext.bindBuffer(glContext.ARRAY_BUFFER, positionBuffer);
  glContext.vertexAttribPointer(positionLocation, 2, glContext.FLOAT, false, 0, 0);
  glContext.enableVertexAttribArray(texcoordLocation);
  glContext.bindBuffer(glContext.ARRAY_BUFFER, texcoordBuffer);
  glContext.vertexAttribPointer(texcoordLocation, 2, glContext.FLOAT, false, 0, 0);

  frameTexture = glContext.createTexture();
  glContext.bindTexture(glContext.TEXTURE_2D, frameTexture);
  glContext.texParameteri(glContext.TEXTURE_2D, glContext.TEXTURE_MIN_FILTER, glContext.LINEAR);
  glContext.texParameteri(glContext.TEXTURE_2D, glContext.TEXTURE_MAG_FILTER, glContext.LINEAR);
  glContext.texParameteri(glContext.TEXTURE_2D, glContext.TEXTURE_WRAP_S, glContext.CLAMP_TO_EDGE);
  glContext.texParameteri(glContext.TEXTURE_2D, glContext.TEXTURE_WRAP_T, glContext.CLAMP_TO_EDGE);
  glContext.bindTexture(glContext.TEXTURE_2D, null);
}

function createShader(glContext, type, source) {
  const shader = glContext.createShader(type);
  glContext.shaderSource(shader, source);
  glContext.compileShader(shader);
  const success = glContext.getShaderParameter(shader, glContext.COMPILE_STATUS);
  if (success) {
    return shader;
  }
  const info = glContext.getShaderInfoLog(shader);
  glContext.deleteShader(shader);
  throw new Error("Shader compile error: " + String(info || "unknown"));
}

self.onmessage = function (event) {
  if (
    event.data.canvas &&
    event.data.displayWidth !== undefined &&
    event.data.displayHeight !== undefined
  ) {
    offscreenCanvas = event.data.canvas;
    applyRuntimeConfig({
      displayWidth: event.data.displayWidth,
      displayHeight: event.data.displayHeight,
      windowWidth: event.data.windowWidth,
      windowHeight: event.data.windowHeight,
    });

    gl = offscreenCanvas.getContext("webgl2");
    if (!gl) {
      gl = offscreenCanvas.getContext("webgl");
    }
    if (!gl) {
      throw new Error("Failed to get WebGL context.");
    }

    initializeGL(gl);
    decoder = new VideoDecoder({
      output: (frame) => {
        pendingFrames.push(frame);
        if (pendingFrames.length > MAX_RENDER_QUEUE_SIZE + 1) {
          while (pendingFrames.length > 1) {
            const staleFrame = pendingFrames.shift();
            if (staleFrame && staleFrame.close) {
              staleFrame.close();
            }
          }
        }
        scheduleRender();
      },
      error: (error) => {
        self.postMessage({
          error: String(error),
        });
      },
    });
  } else if (event.data.config) {
    applyRuntimeConfig(event.data.config);
  } else if (event.data.h264Data) {
    handleEncodedData(event.data.h264Data);
  }
};
