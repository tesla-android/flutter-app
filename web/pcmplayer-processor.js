class PCMPlayerProcessor extends AudioWorkletProcessor {
    constructor() {
        super();
        this.samples = new Float32Array();
        this.port.onmessage = this.handleMessage.bind(this);
    }

    handleMessage(event) {

        const data = event.data;


        // getting the formatted buffer.
        const formattedData = this.getFormattedValue(data);
        // truncate data if the buffer is 2x larger than the sampleRate
        const maxSamples = this.sampleRate * 2;
        const totalSamples = this.samples.length + data.length;

        if (totalSamples > maxSamples) {
            const samplesToDiscard = totalSamples - maxSamples;
            this.samples = this.samples.subarray(samplesToDiscard);
        }

        // the code is starting to copy data from a buffer. It then creates a new Float32Array to store the copied data.
        const tmp = new Float32Array(this.samples.length + formattedData.length);

        tmp.set(this.samples, 0);
        // Copy the new data passed in, starting from the historical buffer position
        tmp.set(formattedData, this.samples.length);
        // code is assigning a new buffer of data to the samples variable. The interval timer will then play the data from the samples variable.

        this.samples = tmp;

    }

    getFormattedValue(data) {
        if (data.constructor == ArrayBuffer) {
            return new Float32Array(data);
        } else {
            return new Float32Array(data.buffer);
        }
    }

    process(inputs, outputs, parameters) {
        const output = outputs[0];
        const bufferSize = output[0].length * 2;
        if (this.samples.length < bufferSize) {
            return true;
        }

        let theseSamples = this.samples.subarray(0, bufferSize);
        //split the samples into left and right channels
        let left = theseSamples.filter((_, i) => i % 2 === 0);
        let right = theseSamples.filter((_, i) => i % 2 === 1);

        output[0].set(left);
        output[1].set(right);

        this.samples = this.samples.subarray(bufferSize);

        return true;
    }

}

registerProcessor('pcm-player-processor', PCMPlayerProcessor);