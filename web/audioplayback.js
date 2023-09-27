
let audioContext = null
let audioSocket = null;
let pcmPlayerNode = null;

async function startAudioPlayback() {

    console.log('Before AudioContext start');
    audioContext = new AudioContext({ sampleRate: 48000, channels: 2, latencyHint: 'interactive' });

    await audioContext.audioWorklet.addModule('pcmplayer-processor.js');
    console.log("starting audioContext");

    pcmPlayerNode = new AudioWorkletNode(audioContext, 'pcm-player-processor');
    pcmPlayerNode.connect(audioContext.destination);

    audioContext.resume();
    console.log('after AudioContext resume');
}



function createAudioSocket(url) {
    if (!isAudioEnabled) {
        console.log("Audio: Disabled");
        return;
    } else {

    }
    audioSocket = new ReconnectingWebSocket(url, null, { binaryType: 'arraybuffer' });

    audioSocket.onopen = () => {
        log("Audio: Websocket connection established")
    };

    audioSocket.onclose = () => {
        log("Audio: Websocket connection closed")
    };

    audioSocket.onerror = error => {
        log("Audio: " + error)
    };

    audioSocket.onmessage = (event) => {
        if (pcmPlayerNode != null && event.data instanceof ArrayBuffer) {
            pcmPlayerNode.port.postMessage(event.data);
            //console.log("Audio: " + event.data.byteLength);
        }
    };
}