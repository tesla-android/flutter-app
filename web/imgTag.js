var img = document.getElementById("image");
var canvas = document.getElementById("canvas");
var urlCreator = window.URL || window.webkitURL;
img.style.display = "block";
canvas.style.display = "none";

var currentImageUrl;

function drawDisplayFrame(blob) {
    if (currentImageUrl) {
        urlCreator.revokeObjectURL(currentImageUrl);
    }


    let imageUrl = urlCreator.createObjectURL(blob);
    currentImageUrl = imageUrl;

    img.src = imageUrl;
}