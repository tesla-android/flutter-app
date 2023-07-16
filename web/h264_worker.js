let pendingFrames = [],
    underflow = true,
    sps,
    decoder,
    socket,
    height,
    width,
    ctx;

const vertexShaderSrc = `
        attribute vec2 aVertex;
        attribute vec2 aUV;
        varying vec2 vTex;
        uniform vec2 pos;
        void main(void) {
          gl_Position = vec4(aVertex + pos, 0.0, 1.0);
          vTex = aUV;
        }`,
    fragmentShaderSrc = `
        precision highp float;
        varying vec2 vTex;
        uniform sampler2D sampler0;
        void main(void){
          gl_FragColor = texture2D(sampler0, vTex);
        }`;

async function renderFrame() {
    underflow = pendingFrames.length === 0;
    if (underflow) {
        return;
    }
    const frame = pendingFrames.shift();
    ctx.texImage2D(ctx.TEXTURE_2D, 0, ctx.RGBA, ctx.RGBA, ctx.UNSIGNED_BYTE, frame);
    ctx.drawArrays(ctx.TRIANGLE_FAN, 0, 4);
    frame.close();
    renderFrame();
}


function videoMagic(dat){
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
            self.postMessage({error: true});
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
            self.postMessage({error: true});
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
        sps=appendByteArray(sps,dat)
    else
        videoMagic(dat);
}

function appendByteArray(buffer1, buffer2) {
    const tmp = new Uint8Array((buffer1.byteLength | 0) + (buffer2.byteLength | 0));
    tmp.set(buffer1, 0);
    tmp.set(buffer2, buffer1.byteLength | 0);
    return tmp;
}


function initCanvas(canvas) {
    ctx = canvas.getContext('webgl2');
    const tex = ctx.createTexture();

    const vertShaderObj = ctx.createShader(ctx.VERTEX_SHADER);
    const fragShaderObj = ctx.createShader(ctx.FRAGMENT_SHADER);

    ctx.shaderSource(vertShaderObj, vertexShaderSrc);
    ctx.shaderSource(fragShaderObj, fragmentShaderSrc);
    ctx.compileShader(vertShaderObj);
    ctx.compileShader(fragShaderObj);

    const progObj = ctx.createProgram();
    ctx.attachShader(progObj, vertShaderObj);
    ctx.attachShader(progObj, fragShaderObj);

    ctx.linkProgram(progObj);
    ctx.useProgram(progObj);

    ctx.viewport(0, 0, canvas.width, canvas.height);

    const vertexBuff = ctx.createBuffer();
    ctx.bindBuffer(ctx.ARRAY_BUFFER, vertexBuff);
    ctx.bufferData(ctx.ARRAY_BUFFER, new Float32Array([-1, 1, -1, -1, 1, -1, 1, 1]), ctx.STATIC_DRAW);

    const texBuff = ctx.createBuffer();
    ctx.bindBuffer(ctx.ARRAY_BUFFER, texBuff);
    ctx.bufferData(ctx.ARRAY_BUFFER, new Float32Array([0, 1, 0, 0, 1, 0, 1, 1]), ctx.STATIC_DRAW);

    const vloc = ctx.getAttribLocation(progObj, "aVertex");
    const tloc = ctx.getAttribLocation(progObj, "aUV");

    ctx.bindTexture(ctx.TEXTURE_2D, tex);
    ctx.texParameteri(ctx.TEXTURE_2D, ctx.TEXTURE_MIN_FILTER, ctx.NEAREST);
    ctx.texParameteri(ctx.TEXTURE_2D, ctx.TEXTURE_MAG_FILTER, ctx.NEAREST);
    ctx.texParameteri(ctx.TEXTURE_2D, ctx.TEXTURE_WRAP_S, ctx.CLAMP_TO_EDGE);
    ctx.texParameteri(ctx.TEXTURE_2D, ctx.TEXTURE_WRAP_T, ctx.CLAMP_TO_EDGE);
    ctx.pixelStorei(ctx.UNPACK_FLIP_Y_WEBGL, true);
    ctx.pixelStorei(ctx.UNPACK_PREMULTIPLY_ALPHA_WEBGL, false);
    ctx.enableVertexAttribArray(vloc);
    ctx.bindBuffer(ctx.ARRAY_BUFFER, vertexBuff);
    ctx.vertexAttribPointer(vloc, 2, ctx.FLOAT, false, 0, 0);
    ctx.enableVertexAttribArray(tloc);
    ctx.bindBuffer(ctx.ARRAY_BUFFER, texBuff);
    ctx.bindTexture(ctx.TEXTURE_2D, tex);
    ctx.vertexAttribPointer(tloc, 2, ctx.FLOAT, false, 0, 0);
}

function separateNalUnits(data){
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

function handleMessage(dat) {
    let unittype = (dat[4] & 0x1f);

    if (unittype === 1 || unittype === 5) {
        videoMagic(dat)
    } else {
      separateNalUnits(dat).forEach(headerMagic)
    }
}

self.onmessage = function(event) {
    if (event.data.canvas && event.data.displayWidth && event.data.displayHeight) {
        const offscreenCanvas = event.data.canvas;
        height = event.data.displayHeight;
        width = event.data.displayWidth;
        gl = offscreenCanvas.getContext("webgl2");
        if (!gl) {
            gl = offscreenCanvas.getContext("webgl");
        }
        if (!gl) {
            throw new Error("Failed to get WebGL context.");
        }

        initCanvas(offscreenCanvas);
        decoder = new VideoDecoder({
                output: (frame) => {
                    pendingFrames.push(frame);
                    if (underflow) {
                        renderFrame();
                    }
                },
                error: e => self.postMessage({error: e}),
            });
    } else if (event.data.h264Data) {
        handleMessage(event.data.h264Data);
    }
}