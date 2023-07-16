var img = document.getElementById("image");
var canvas = document.getElementById("canvas");
img.style.display = "none";
canvas.style.display = "block";

canvas.width = window.innerWidth;
canvas.height = window.innerHeight;

const worker = new Worker('h264_worker.js');
const offscreenCanvas = canvas.transferControlToOffscreen();

worker.postMessage({canvas: offscreenCanvas, displayWidth: displayWidth, displayHeight: displayHeight}, [offscreenCanvas]);

function drawDisplayFrame(arrayBuffer) {
    worker.postMessage({h264Data: arrayBuffer});
}