
let audioContext = null
let audioSocket = null;
let pcmPlayerNode = null;
let gainNode = null;

let isAudioEnabled;
let audioVolume;


async function startAudioPlayback() {

    console.log('Before AudioContext start');
    audioContext = new AudioContext({ sampleRate: 48000, channels: 2, latencyHint: 'interactive' });

    await audioContext.audioWorklet.addModule('pcmplayer-processor.js');
    console.log("starting audioContext");

    pcmPlayerNode = new AudioWorkletNode(audioContext, 'pcm-player-processor', { outputChannelCount: [2] });

    if (audioVolume != null && audioVolume !== 1) {
        let gainValue = audioVolume;
        console.log("Gain value: " + gainValue);
        gainNode = new GainNode(audioContext, { gain: gainValue });
        pcmPlayerNode.connect(gainNode);
        gainNode.connect(audioContext.destination);
    } else {
        pcmPlayerNode.connect(audioContext.destination);
    }

    if (!audioSocket) createAudioSocket(audioWebsocketUrl);

    audioContext.resume();
    console.log('after AudioContext resume');
}

function setAudioVolume(volume) {
    console.log("Audio: Volume set to " + volume);
    audioVolume = volume * 1.0;
}

function setAudioEnabled(enabled) {
    //check if isAudioEnabled is a boolean
    if (typeof enabled !== "boolean") {
        if (enabled === "false") {
            isAudioEnabled = false;
        } else {
            isAudioEnabled = true;
        }
    } else {
        isAudioEnabled = enabled;
    }
}


function createAudioSocket(url) {
    if (!isAudioEnabled) {
        console.log("Audio: Disabled");

    } else {
        console.log("Audio: Enabled");

        audioSocket = new ReconnectingWebSocket(url, null, { binaryType: 'arraybuffer', reconnectInterval: 0 });

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
            pcmPlayerNode.port.postMessage(event.data);
        };
    }
}
