(function (global) {
  "use strict";

  const TAHtml = global.TAHtml;

  class AudioController {
    constructor(options) {
      this.audioWebsocketUrl = options.audioWebsocketUrl;
      this.state = "stopped";
      this.enabled = true;
      this.volume = 1.0;
      this._wired = false;
      this._pollId = null;
    }

    initialize() {
      this._registerGlobalBridge();
      this._wireAudioElementEvents();
    }

    applyConfiguration(config) {
      const cfg = typeof config === "string" ? this._safeJsonParse(config) : config;
      if (!cfg || typeof cfg !== "object") {
        return;
      }

      this.audioWebsocketUrl = cfg.audioWebsocketUrl || this.audioWebsocketUrl;
      global.audioWebsocketUrl = this.audioWebsocketUrl;

      this.enabled = String(cfg.isAudioEnabled) !== "false";
      this.volume = Number(cfg.audioVolume ?? 1.0);

      try {
        if (typeof global.setAudioEnabled === "function") {
          global.setAudioEnabled(this.enabled);
        }
      } catch (_error) {
        // no-op
      }

      try {
        if (typeof global.setAudioVolume === "function") {
          global.setAudioVolume(this.volume);
        }
      } catch (_error) {
        // no-op
      }
    }

    isAudioEnabled() {
      return this.enabled;
    }

    getAudioState() {
      return this.state;
    }

    startFromGesture() {
      try {
        if (typeof global.primeAudioFromGesture === "function") {
          global.primeAudioFromGesture();
        }
      } catch (_error) {
        // no-op
      }

      try {
        if (typeof global.startAudioPlayback === "function") {
          global.startAudioPlayback();
        }
      } catch (_error) {
        // no-op
      }

      this._setState("playing");
      this._wireAudioElementEvents();
    }

    stop() {
      try {
        if (typeof global.stopAudioPlayback === "function") {
          global.stopAudioPlayback();
        }
      } catch (_error) {
        // no-op
      }
      this._setState("stopped");
    }

    toggle() {
      if (!this.enabled) {
        return;
      }
      if (this.state === "playing") {
        this.stop();
      } else {
        this.startFromGesture();
      }
    }

    _registerGlobalBridge() {
      global.setupAudioConfig = (config) => {
        this.applyConfiguration(config);
      };
      global.startAudioFromGesture = () => {
        this.startFromGesture();
      };
      global.stopAudio = () => {
        this.stop();
      };
      global.getAudioState = () => this.state;
    }

    _wireAudioElementEvents() {
      if (this._wired) {
        return;
      }

      const wire = () => {
        if (this._wired) {
          return;
        }

        const el = global.__liveAudioEl || document.querySelector("audio");
        if (!el) {
          return;
        }

        const toStopped = () => this._setState("stopped");
        const toPlaying = () => this._setState("playing");

        el.addEventListener("play", toPlaying);
        el.addEventListener("playing", toPlaying);
        el.addEventListener("pause", toStopped);
        el.addEventListener("ended", toStopped);
        el.addEventListener("error", toStopped);
        el.addEventListener("emptied", toStopped);

        this._wired = true;
      };

      global.addEventListener("audio-el-created", wire);
      wire();

      if (!this._wired) {
        this._pollId = global.setInterval(() => {
          wire();
          if (this._wired && this._pollId !== null) {
            global.clearInterval(this._pollId);
            this._pollId = null;
          }
        }, 250);
      }
    }

    _setState(nextState) {
      if (this.state === nextState) {
        return;
      }
      this.state = nextState;
      try {
        global.dispatchEvent(
          new CustomEvent("audio-state", {
            detail: String(nextState),
          }),
        );
      } catch (_error) {
        // no-op
      }
    }

    _safeJsonParse(raw) {
      try {
        return JSON.parse(raw);
      } catch (_error) {
        return null;
      }
    }
  }

  TAHtml.AudioController = AudioController;
})(window);
