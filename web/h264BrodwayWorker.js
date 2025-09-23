importScripts("Decoder.js", "YUVCanvas.js");

let pendingFrames = [],
    underflow = true,
    decoder,
    socket,
    height,
    width,
    windowHeight,
    windowWidth,
    yuvCanvas;

const MAX_BUFFER_SIZE = 50;

function isKeyframe(buffer) {
    for (let i = 0; i < buffer.length - 4; i++) {
        if (
            buffer[i] === 0x00 &&
            buffer[i + 1] === 0x00 &&
            buffer[i + 2] === 0x00 &&
            buffer[i + 3] === 0x01
        ) {
            const nalHeader = buffer[i + 4];
            const nalType = nalHeader & 0x1F;
            return nalType === 5;
        }
    }
    return false;
}

async function renderFrame() {
    underflow = false;
    while (pendingFrames.length > 0) {
        const frame = pendingFrames.shift();
        drawImageToCanvas(frame);
        await Promise.resolve();
    }
    underflow = true;
}

function drawImageToCanvas(image) {
    const ySize = width * height;
    const uvSize = (width >> 1) * (height >> 1);

    const y = image.subarray(0, ySize);
    const u = image.subarray(ySize, ySize + uvSize);
    const v = image.subarray(ySize + uvSize, ySize + 2 * uvSize);

    yuvCanvas.drawNextOutputPicture({
        yData: y,
        uData: u,
        vData: v
    });

    if (image.close) {
        image.close();
    }
}

function handleMessage(dat) {
    decoder.decode(dat);

    // If frame buffer is too large, drop until next keyframe
    if (pendingFrames.length > MAX_BUFFER_SIZE) {
        let foundKeyframe = false;
        while (!foundKeyframe && pendingFrames.length > 0) {
            const frame = pendingFrames.shift();
            if (isKeyframe(frame)) {
                foundKeyframe = true;
                pendingFrames.unshift(frame);
            }
        }
    }
}

self.onmessage = function (event) {
    if (event.data.canvas && event.data.displayWidth && event.data.displayHeight) {
        const offscreenCanvas = event.data.canvas;
        height = event.data.displayHeight;
        width = event.data.displayWidth;
        windowHeight = event.data.windowHeight;
        windowWidth = event.data.windowWidth;

        yuvCanvas = new YUVCanvas({
            canvas: offscreenCanvas,
            width: width,
            height: height,
            type: 'yuv420',
            reuseMemory: true,
        });

        decoder = new Decoder({ rgb: false });
        decoder.onPictureDecoded = function (data) {
            pendingFrames.push(data);
            if (underflow) {
                renderFrame();
            }
        };
    } else if (event.data.h264Data) {
        handleMessage(new Uint8Array(event.data.h264Data));
    }
};