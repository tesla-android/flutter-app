let gl;
let positionLocation;
let texcoordLocation;
let positionBuffer;
let texcoordBuffer;
let texturePool = [];
let texturePoolSize = 5;

self.onmessage = function(event) {
    if (event.data.canvas) {
        const offscreenCanvas = event.data.canvas;
        gl = offscreenCanvas.getContext("webgl2");
        if (!gl) {
            gl = offscreenCanvas.getContext("webgl");
        }
        if (!gl) {
            throw new Error("Failed to get WebGL context.");
        }

        initializeGL(gl);

    } else if (event.data.jpegData) {
        const arrayBuffer = event.data.jpegData;
        draw(arrayBuffer);
    }
}

function initializeGL(gl) {
    var vertexSource = `
             attribute vec2 a_position;
             attribute vec2 a_texCoord;
             varying vec2 v_texCoord;
             void main() {
                 gl_Position = vec4(a_position, 0, 1);
                 v_texCoord = a_texCoord;
             }
         `;
    var fragmentSource = `
             precision mediump float;
             uniform sampler2D u_image;
             varying vec2 v_texCoord;
             void main() {
                 gl_FragColor = texture2D(u_image, v_texCoord);
             }
         `;

    var vertexShader = createShader(gl, gl.VERTEX_SHADER, vertexSource);
    var fragmentShader = createShader(gl, gl.FRAGMENT_SHADER, fragmentSource);

    var program = gl.createProgram();
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

    texturePool = [];
    texturePoolSize = 5;

    for (let i = 0; i < texturePoolSize; i++) {
        let texture = gl.createTexture();
        gl.bindTexture(gl.TEXTURE_2D, texture);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
        texturePool.push(texture);
    }
}

function createShader(gl, type, source) {
    var shader = gl.createShader(type);
    gl.shaderSource(shader, source);
    gl.compileShader(shader);
    var success = gl.getShaderParameter(shader, gl.COMPILE_STATUS);
    if (success) {
        return shader;
    }
    console.log(gl.getShaderInfoLog(shader));
    gl.deleteShader(shader);
}

function draw(arrayBuffer) {
    var imageDecoder = new ImageDecoder({ type: "image/jpeg", data: arrayBuffer });

    imageDecoder.decode().then((result) => {
        var imageBitmap = result.image;
        let texture = texturePool.pop();
        handleTextureLoaded(gl, imageBitmap, texture, imageBitmap.width, imageBitmap.height);
        texturePool.push(texture);
    });
}

function handleTextureLoaded(gl, image, texture, width, height) {
    gl.bindTexture(gl.TEXTURE_2D, texture);
    gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, image);

    if (isPowerOf2(width) && isPowerOf2(height)) {
        gl.generateMipmap(gl.TEXTURE_2D);
    } else {
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
    }

    gl.clear(gl.COLOR_BUFFER_BIT);
    gl.drawArrays(gl.TRIANGLES, 0, 6);
}

function isPowerOf2(value) {
    return (value & (value - 1)) == 0;
}