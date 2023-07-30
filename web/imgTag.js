var img = document.getElementById("image");
var canvas = document.getElementById("canvas");
var statsElement = document.getElementById("stats");
img.style.display = "block";
canvas.style.display = "none";

var currentImageUrl;
var queue = [];
var isProcessing = false;
var maxQueueSize = 5;

var stats = {
    skippedFrames: 0,
    bufferLength: 0
};

function updateStats() {
    stats.bufferLength = queue.length;
    statsElement.textContent = 'Skipped Frames: ' + stats.skippedFrames + ' Buffer size: ' + stats.bufferLength;
}

function processQueue() {
    if (isProcessing) return;
    if (queue.length === 0) return;

    isProcessing = true;

    var blob = queue.shift();

    if (currentImageUrl) {
        (window.URL || window.webkitURL).revokeObjectURL(currentImageUrl);
        currentImageUrl = null;
    }

    var urlCreator = window.URL || window.webkitURL;
    var imageUrl = urlCreator.createObjectURL(blob);
    currentImageUrl = imageUrl;

    img.onload = function() {
        if (imageUrl !== currentImageUrl) return;
        isProcessing = false;
        processQueue();
        updateStats();
    }

    img.src = imageUrl;
}

function drawDisplayFrame(blob) {
    if (!blob) return;

    if (queue.length >= maxQueueSize) {
        queue.shift();
        stats.skippedFrames++;
    }

    queue.push(blob);
    processQueue();
    updateStats();
}