onmessage = function(event) {
    if (event.data.frame) {
        var arrayBuffer = event.data.frame;
        var imageDecoder = new ImageDecoder({ type: "image/jpeg", data: arrayBuffer });

        imageDecoder.decode().then((result) => {
            postMessage(result.image);
        });
    }
};
