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

function drawDisplayFrame(arrayBuffer) {
    var imageDecoder = new ImageDecoder({ type: "image/jpeg", data: arrayBuffer });
    imageDecoder.decode().then((result) => {
        var imageBitmap = result.image;
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        var width = imageBitmap.codedWidth;
        var height = imageBitmap.codedHeight;
        var hRatio = canvas.width / width;
        var vRatio = canvas.height / height;
        var ratio = Math.min(hRatio, vRatio);
        var centerShift_x = (canvas.width - width * ratio) / 2;
        var centerShift_y = (canvas.height - height * ratio) / 2;
        ctx.drawImage(imageBitmap, 0, 0, width, height, centerShift_x, centerShift_y, width * ratio, height * ratio);
    });
}
