let pendingFrames = [],
    underflow = true,
    sps,
    decoder,
    socket,
    height,
    width,
    windowHeight,
    windowWidth,
    ctx;

const MAX_BUFFER_SIZE = 50;
const MAX_TEXTURE_POOL_SIZE = 5;

const texturePool = [];

function getTexture(gl) {
    if(texturePool.length > 0) return texturePool.pop();
    return gl.createTexture();
}

function releaseTexture(gl, texture) {
    if (texturePool.length < MAX_TEXTURE_POOL_SIZE) {
        texturePool.push(texture);
    } else {
        gl.deleteTexture(texture);
    }
}

async function renderFrame() {
    if (pendingFrames.length === 0) {
        return;
    }
    const frame = pendingFrames.shift();
    drawImageToCanvas(gl, frame);
    sendStatsToMainThread();

    if (pendingFrames.length > 0) {
        await renderFrame();
    }
}

function drawImageToCanvas(gl, image) {
    const texture = getTexture(gl);
    gl.bindTexture(gl.TEXTURE_2D, texture);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
    gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, image);

    if (isPowerOf2(width) && isPowerOf2(height)) {
        gl.generateMipmap(gl.TEXTURE_2D);
    }

    gl.clear(gl.COLOR_BUFFER_BIT);
    gl.drawArrays(gl.TRIANGLES, 0, 6);

    gl.bindTexture(gl.TEXTURE_2D, null);
    releaseTexture(gl, texture);

    if (image.close) {
        image.close();
    }
}

function videoMagic(dat) {
    let unittype = (dat[4] & 0x1f);
    if (unittype === 1) {
        let chunk = new EncodedVideoChunk({
            type: 'delta',
            timestamp: 0,
            duration: 0,
            data: dat
        });
        if (decoder.state === 'configured') {
            decoder.decode(chunk);
        } else {
            self.postMessage({ error: true });
        }
        return;
    }

    if (unittype === 5) {
        let data = appendByteArray(sps, dat);

        let chunk = new EncodedVideoChunk({
            type: 'key',
            timestamp: 0,
            duration: 0,
            data: data
        });
        if (decoder.state === 'configured') {
            decoder.decode(chunk);
        } else {
            self.postMessage({ error: true });
        }
    }
}
function headerMagic(dat) {
    let unittype = (dat[4] & 0x1f);

    if (unittype === 7) {
        let config = {
            codec: "avc1.",
            codedHeight: height,
            codedWidth: width,
            displayAspectWidth: windowWidth,
            displayAspectHeight: windowHeight,
            hardwareAcceleration: "prefer-hardware",
            optimizeForLatency: true
        }
        for (let i = 5; i < 8; ++i) {
            var h = dat[i].toString(16);
            if (h.length < 2) {
                h = '0' + h;
            }
            config.codec += h;
        }
        sps = dat;
        decoder.configure(config);

        return;
    }
    else if (unittype === 8)
        sps = appendByteArray(sps, dat)
    else
        videoMagic(dat);
}

function appendByteArray(buffer1, buffer2) {
    const tmp = new Uint8Array((buffer1.byteLength | 0) + (buffer2.byteLength | 0));
    tmp.set(buffer1, 0);
    tmp.set(buffer2, buffer1.byteLength | 0);
    return tmp;
}

function separateNalUnits(data) {
    let i = -1;
    return new Uint8Array(data)
        .reduce((output, value, index, self) => {
            if (value === 0 && self[index + 1] === 0 && self[index + 2] === 0 && self[index + 3] === 1) {
                i++;
            }
            if (!output[i]) {
                output[i] = [];
            }
            output[i].push(value);
            return output;
        }, [])
        .map(dat => Uint8Array.from(dat));
}

let skippedFrames = 0;

function handleMessage(dat) {
    let unittype = (dat[4] & 0x1f);

    if (unittype === 1 || unittype === 5) {
        videoMagic(dat)
    } else {
        separateNalUnits(dat).forEach(headerMagic)
    }

    if (pendingFrames.length > MAX_BUFFER_SIZE) {
        let foundIframe = false;
        while (!foundIframe && pendingFrames.length > 0) {
            let frame = pendingFrames.shift();
            if (frame.type === 'key') {
                foundIframe = true;
                pendingFrames.unshift(frame);
            } else {
                skippedFrames++;
            }
            frame.close();
        }
    }
}

function sendStatsToMainThread() {
    const stats = {
        skippedFrames: skippedFrames,
        bufferLength: pendingFrames.length,
    };
    postMessage(stats);
}

function initializeGL(gl) {
    const vertexSource = `
        attribute vec2 a_position;
        attribute vec2 a_texCoord;
        varying vec2 v_texCoord;
        void main() {
            gl_Position = vec4(a_position, 0, 1);
            v_texCoord = a_texCoord;
        }
    `;
    const fragmentSource = `
        precision mediump float;
        uniform sampler2D u_image;
        varying vec2 v_texCoord;
        void main() {
            gl_FragColor = texture2D(u_image, v_texCoord);
        }
    `;

    const vertexShader = createShader(gl, gl.VERTEX_SHADER, vertexSource);
    const fragmentShader = createShader(gl, gl.FRAGMENT_SHADER, fragmentSource);

    const program = gl.createProgram();
    gl.attachShader(program, vertexShader);
    gl.attachShader(program, fragmentShader);
    gl.linkProgram(program);

    positionLocation = gl.getAttribLocation(program, "a_position");
    texcoordLocation = gl.getAttribLocation(program, "a_texCoord");

    positionBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([-1.0, -1.0, 1.0, -1.0, -1.0, 1.0, -1.0, 1.0, 1.0, -1.0, 1.0, 1.0]), gl.STATIC_DRAW);

    texcoordBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, texcoordBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([0.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0.0]), gl.STATIC_DRAW);

    gl.viewport(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
    gl.clearColor(0.0, 0.0, 0.0, 0.0);
    gl.useProgram(program);
    gl.enableVertexAttribArray(positionLocation);
    gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);
    gl.vertexAttribPointer(positionLocation, 2, gl.FLOAT, false, 0, 0);
    gl.enableVertexAttribArray(texcoordLocation);
    gl.bindBuffer(gl.ARRAY_BUFFER, texcoordBuffer);
    gl.vertexAttribPointer(texcoordLocation, 2, gl.FLOAT, false, 0, 0);
}

function createShader(gl, type, source) {
    const shader = gl.createShader(type);
    gl.shaderSource(shader, source);
    gl.compileShader(shader);
    const success = gl.getShaderParameter(shader, gl.COMPILE_STATUS);
    if (success) {
        return shader;
    }
    console.log(gl.getShaderInfoLog(shader));
    gl.deleteShader(shader);
}

self.onmessage = function (event) {
    if (event.data.canvas && event.data.displayWidth && event.data.displayHeight) {
        const offscreenCanvas = event.data.canvas;
        height = event.data.displayHeight;
        width = event.data.displayWidth;
        windowHeight = event.data.windowHeight;
        windowWidth = event.data.windowWidth;
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
                if (underflow) {
                    renderFrame();
                }
            },
            error: e => self.postMessage({ error: e }),
        });
    } else if (event.data.h264Data) {
        handleMessage(event.data.h264Data);
    }
}

function isPowerOf2(value) {
    return (value & (value - 1)) == 0;
}