(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory() :
    typeof define === 'function' && define.amd ? define(factory) :
      (global = typeof globalThis !== 'undefined' ? globalThis : global || self, global.PCMPlayer = factory());
})(this, (function () {
  'use strict';

  class PCMPlayer {
    constructor(option) {
      this.init(option);
    }

    init(option) {
      const defaultOption = {
        inputCodec: 'Int16', // The number of bits used for encoding the input data, default is 16 bits
        channels: 1, // Number of channels
        sampleRate: 8000, // Sampling rate in Hz
        flushTime: 1000 // Cache time in milliseconds
      };

      this.option = Object.assign({}, defaultOption, option); // Final configuration parameters for the instance
      this.samples = new Float32Array(); // Sample storage area
      this.interval = setInterval(this.flush.bind(this), this.option.flushTime);

      this.typedArray = this.getTypedArray();
      this.initAudioContext();
    }



    getTypedArray() {
      // Select the binary data format that needs to be saved by the front end according to the target encoding bit number. See the complete TypedArray in the documentation
      // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray
      const typedArrays = {
        'Int8': Int8Array,
        'Int16': Int16Array,
        'Int32': Int32Array,
        'Float32': Float32Array
      };
      if (!typedArrays[this.option.inputCodec]) {
        throw new Error('wrong codec.please input one of these codecs:Int8,Int16,Int32,Float32')
      }
      return typedArrays[this.option.inputCodec]
    }

    initAudioContext() {
      // Initialize the audio context
      this.audioCtx = new (window.parent.AudioContext || window.parent.webkitAudioContext)();
      // GainNode that controls the volume
      // https://developer.mozilla.org/en-US/docs/Web/API/BaseAudioContext/createGain
      this.gainNode = this.audioCtx.createGain();
      this.gainNode.gain.value = 1.0;
      this.gainNode.connect(this.audioCtx.destination);
      this.startTime = this.audioCtx.currentTime;
    }

    static isTypedArray(data) {
      //Check whether the input data is of the TypedArray type or ArrayBuffer type
      return (data.byteLength && data.buffer && data.buffer.constructor == ArrayBuffer) || data.constructor == ArrayBuffer;
    }

    isSupported(data) {
      // Currently, the code supports ArrayBuffer or TypedArray
      if (!PCMPlayer.isTypedArray(data)) {
        throw new Error('Not a ArrayBuffer or TypedArray')
      }
      return true
    }

    feed(data) {
      this.isSupported(data);

      // getting the formatted buffer.
      if (data.constructor == ArrayBuffer) {
        data = new Float32Array(data);
      } else {
        data = new Float32Array(data.buffer);
      }

      //handle too many samples building up in the buffer
      //This will allow half a second of audio to be buffered at any time.
      const maxSamples = this.audioCtx.sampleRate / 2;
      const totalSamples = this.samples.length + data.length;

      if (totalSamples > maxSamples) {
        const samplesToDiscard = totalSamples - maxSamples;
        this.samples = this.samples.subarray(samplesToDiscard);
      }

      // the code is starting to copy data from a buffer. It then creates a new Float32Array to store the copied data.
      const tmp = new Float32Array(this.samples.length + data.length);

      tmp.set(this.samples, 0);
      // Copy the new data passed in, starting from the historical buffer position
      tmp.set(data, this.samples.length);
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

    volume(volume) {
      this.gainNode.gain.value = volume;
    }

    destroy() {
      if (this.interval) {
        clearInterval(this.interval);
      }
      this.samples = null;
      this.audioCtx.close();
      this.audioCtx = null;
    }

    flush() {
      if (!this.samples.length) return
      let bufferSource = this.audioCtx.createBufferSource();
      const length = this.samples.length / this.option.channels;
      const audioBuffer = this.audioCtx.createBuffer(this.option.channels, length, this.option.sampleRate);

      for (let channel = 0; channel < this.option.channels; channel++) {
        const audioData = audioBuffer.getChannelData(channel);
        let offset = channel;

        for (let i = 0; i < length; i++) {
          audioData[i] = this.samples[offset];
          offset += this.option.channels;
        }
      }

      if (this.startTime < this.audioCtx.currentTime) {
        this.startTime = this.audioCtx.currentTime;
      }
      bufferSource.buffer = audioBuffer;
      bufferSource.connect(this.gainNode);
      bufferSource.start(this.startTime);
      this.startTime += audioBuffer.duration;
      this.samples = new Float32Array();
    }

    async pause() {
      await this.audioCtx.suspend();
    }

    async continue() {
      await this.audioCtx.resume();
    }

  }

  return PCMPlayer;

}));