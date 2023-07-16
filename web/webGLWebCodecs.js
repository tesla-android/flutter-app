var img = document.getElementById("image");
var canvas = document.getElementById("canvas");
img.style.display = "none";
canvas.style.display = "block";

canvas.width = window.innerWidth;
canvas.height = window.innerHeight;

const worker = new Worker('workerWebGLWebCodecs.js');
const offscreenCanvas = canvas.transferControlToOffscreen();

worker.postMessage({canvas: offscreenCanvas}, [offscreenCanvas]);

function drawDisplayFrame(arrayBuffer) {
    worker.postMessage({jpegData: arrayBuffer});
}