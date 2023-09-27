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
        const bufferSize = output[0].length;



        output[0].set(this.samples.subarray(0, bufferSize));
        this.samples = this.samples.subarray(bufferSize);

        return true;
    }

}

registerProcessor('pcm-player-processor', PCMPlayerProcessor);