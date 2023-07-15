var img = document.getElementById("image");
var canvas = document.getElementById("canvas");
img.style.display = "none";
canvas.style.display = "block";

var ctx = canvas.getContext("2d");
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

function drawDisplayFrame(blob) {
    var urlCreator = window.URL || window.webkitURL;
    var imageUrl = urlCreator.createObjectURL(blob);
    var image = new Image();
    image.onload = function () {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        var hRatio = canvas.width / image.width;
        var vRatio = canvas.height / image.height;
        var ratio = Math.min(hRatio, vRatio);
        var centerShift_x = (canvas.width - image.width * ratio) / 2;
        var centerShift_y = (canvas.height - image.height * ratio) / 2;
        ctx.drawImage(image, 0, 0, image.width, image.height, centerShift_x, centerShift_y, image.width * ratio, image.height * ratio);
        urlCreator.revokeObjectURL(imageUrl);
    };
    image.src = imageUrl;
}