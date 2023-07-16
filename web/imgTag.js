var img = document.getElementById("image");
var canvas = document.getElementById("canvas");
img.style.display = "block";
canvas.style.display = "none";

var currentImageUrl;

function drawDisplayFrame(blob) {
    if (currentImageUrl) {
        (window.URL || window.webkitURL).revokeObjectURL(currentImageUrl);
    }

    var urlCreator = window.URL || window.webkitURL;
    var imageUrl = urlCreator.createObjectURL(blob);
    currentImageUrl = imageUrl;

    img.src = imageUrl;
}