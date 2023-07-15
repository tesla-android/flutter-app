
var img = document.getElementById("image");
var canvas = document.getElementById("canvas");
img.style.display = "none";
canvas.style.display = "block";

var gl = canvas.getContext("webgl");

if (!gl) {
    alert("Failed to get WebGL context.\nYour browser or device may not support WebGL.");
    throw new Error("Failed to get WebGL context.");
}

canvas.width = window.innerWidth;
canvas.height = window.innerHeight;

window.addEventListener(
    "resize",
    function () {
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
    },
    false
);

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

var positionLocation = gl.getAttribLocation(program, "a_position");
var texcoordLocation = gl.getAttribLocation(program, "a_texCoord");
var positionBuffer = gl.createBuffer();

gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);
gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([-1.0, -1.0, 1.0, -1.0, -1.0, 1.0, -1.0, 1.0, 1.0, -1.0, 1.0, 1.0]), gl.STATIC_DRAW);

var texcoordBuffer = gl.createBuffer();
gl.bindBuffer(gl.ARRAY_BUFFER, texcoordBuffer);
gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([0.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0.0]), gl.STATIC_DRAW);

var texture = gl.createTexture();
gl.bindTexture(gl.TEXTURE_2D, texture);

// Fill the texture with a 1x1 blue pixel.
gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, 1, 1, 0, gl.RGBA, gl.UNSIGNED_BYTE, new Uint8Array([0, 0, 255, 255]));

// Enable alpha blending
gl.enable(gl.BLEND);
gl.blendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);

function drawDisplayFrame(blob) {
    var url = URL.createObjectURL(blob);
    var img = new Image();

    img.onload = function () {
        handleTextureLoaded(gl, img, texture);
    };

    img.src = url;
}

function handleTextureLoaded(gl, image, texture) {
    // Compute the new width and height to maintain aspect ratio
    var hRatio = gl.canvas.clientWidth / image.width;
    var vRatio = gl.canvas.clientHeight / image.height;
    var ratio = Math.min(hRatio, vRatio);

    var newWidth = (image.width * ratio) / gl.canvas.clientWidth;
    var newHeight = (image.height * ratio) / gl.canvas.clientHeight;

    var x1 = (1 - newWidth) / 2;
    var y1 = (1 - newHeight) / 2;

    gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);
    gl.bufferData(
        gl.ARRAY_BUFFER,
        new Float32Array([-1.0 + 2 * x1, -1.0 + 2 * y1, 1.0 - 2 * x1, -1.0 + 2 * y1, -1.0 + 2 * x1, 1.0 - 2 * y1, -1.0 + 2 * x1, 1.0 - 2 * y1, 1.0 - 2 * x1, -1.0 + 2 * y1, 1.0 - 2 * x1, 1.0 - 2 * y1]),
        gl.STATIC_DRAW
    );

    gl.bindTexture(gl.TEXTURE_2D, texture);
    gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, image);

    if (isPowerOf2(image.width) && isPowerOf2(image.height)) {
        gl.generateMipmap(gl.TEXTURE_2D);
    } else {
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
    }

    gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);
    gl.enableVertexAttribArray(positionLocation);
    gl.vertexAttribPointer(positionLocation, 2, gl.FLOAT, false, 0, 0);

    gl.bindBuffer(gl.ARRAY_BUFFER, texcoordBuffer);
    gl.enableVertexAttribArray(texcoordLocation);
    gl.vertexAttribPointer(texcoordLocation, 2, gl.FLOAT, false, 0, 0);

    gl.viewport(0, 0, gl.canvas.width, gl.canvas.height);
    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.clear(gl.COLOR_BUFFER_BIT);

    gl.useProgram(program);
    gl.drawArrays(gl.TRIANGLES, 0, 6);
}

function isPowerOf2(value) {
    return (value & (value - 1)) == 0;
}