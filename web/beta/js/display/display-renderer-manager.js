(function (global) {
  "use strict";

  const TAHtml = global.TAHtml;
  const utils = TAHtml.utils;

  class DisplayRendererManager {
    constructor(options) {
      this.displayRoot = options.displayRoot;
      this.onFrameReceived = typeof options.onFrameReceived === "function" ? options.onFrameReceived : null;
      this.onSocketOpen = typeof options.onSocketOpen === "function" ? options.onSocketOpen : null;
      this.onSocketClose = typeof options.onSocketClose === "function" ? options.onSocketClose : null;
      this.onSocketError = typeof options.onSocketError === "function" ? options.onSocketError : null;

      this.displaySocket = null;
      this.displaySocketConfig = {
        url: null,
        binaryType: null,
      };

      this.renderer = {
        id: null,
        scriptPath: null,
        loadPromise: null,
      };

      this.lastDisplaySize = {
        displayWidth: 1,
        displayHeight: 1,
        windowWidth: 1,
        windowHeight: 1,
      };
    }

    applyDisplaySize(width, height) {
      const safeWidth = Math.max(1, Math.round(width));
      const safeHeight = Math.max(1, Math.round(height));

      const viewport = utils.getViewportSize();
      const scale = Math.min(viewport.width / safeWidth, viewport.height / safeHeight);

      const cssWidth = Math.max(1, Math.floor(safeWidth * scale));
      const cssHeight = Math.max(1, Math.floor(safeHeight * scale));

      this.displayRoot.style.width = String(cssWidth) + "px";
      this.displayRoot.style.height = String(cssHeight) + "px";
      this.displayRoot.style.aspectRatio = String(safeWidth) + " / " + String(safeHeight);

      this.lastDisplaySize = {
        displayWidth: safeWidth,
        displayHeight: safeHeight,
        windowWidth: cssWidth,
        windowHeight: cssHeight,
      };

      this.updateRendererRuntimeConfig(this.lastDisplaySize);
      return this.lastDisplaySize;
    }

    async ensureDisplaySocket(options) {
      const remoteDisplayState = options.remoteDisplayState;
      const socketUrl = options.displayWebSocket;
      const rendererInfo = this._rendererInfoForId(remoteDisplayState.renderer);

      if (this.renderer.scriptPath && this.renderer.scriptPath !== rendererInfo.scriptPath) {
        global.location.reload();
        return;
      }

      await this._ensureRendererScript(rendererInfo);

      if (
        this.displaySocket &&
        this.displaySocketConfig.url === socketUrl &&
        this.displaySocketConfig.binaryType === rendererInfo.binaryType
      ) {
        this.updateRendererRuntimeConfig();
        return;
      }

      this._closeDisplaySocket();

      this.displaySocketConfig = {
        url: socketUrl,
        binaryType: rendererInfo.binaryType,
      };

      const socket = new ReconnectingWebSocket(socketUrl, null, {
        binaryType: rendererInfo.binaryType,
        reconnectInterval: 150,
        maxReconnectInterval: 1000,
        reconnectDecay: 1.2,
        timeoutInterval: 900,
      });

      socket.onopen = () => {
        TAHtml.log("Display websocket connected");
        if (typeof this.onSocketOpen === "function") {
          try {
            this.onSocketOpen();
          } catch (_error) {
            // no-op
          }
        }
        this.updateRendererRuntimeConfig();
      };
      socket.onclose = () => {
        TAHtml.log("Display websocket closed");
        if (typeof this.onSocketClose === "function") {
          try {
            this.onSocketClose();
          } catch (_error) {
            // no-op
          }
        }
      };
      socket.onerror = (error) => {
        TAHtml.log("Display websocket error: " + String(error));
        if (typeof this.onSocketError === "function") {
          try {
            this.onSocketError(error);
          } catch (_error) {
            // no-op
          }
        }
      };
      socket.onmessage = (event) => {
        if (typeof this.onFrameReceived === "function") {
          try {
            this.onFrameReceived();
          } catch (_error) {
            // no-op
          }
        }
        if (typeof global.drawDisplayFrame === "function") {
          global.drawDisplayFrame(event.data);
        }
      };

      this.displaySocket = socket;
    }

    updateRendererRuntimeConfig(config) {
      if (typeof global.updateDisplayRendererConfig !== "function") {
        return;
      }

      if (config) {
        global.updateDisplayRendererConfig(config);
        return;
      }

      const width = Math.max(1, Math.round(this.displayRoot.clientWidth || global.innerWidth || 1));
      const height = Math.max(1, Math.round(this.displayRoot.clientHeight || global.innerHeight || 1));

      global.updateDisplayRendererConfig({
        displayWidth: this.lastDisplaySize.displayWidth,
        displayHeight: this.lastDisplaySize.displayHeight,
        windowWidth: width,
        windowHeight: height,
      });
    }

    closeDisplaySocket() {
      this._closeDisplaySocket();
    }

    _closeDisplaySocket() {
      if (this.displaySocket) {
        this.displaySocket.close();
        this.displaySocket = null;
      }
    }

    _rendererInfoForId(rendererId) {
      switch (utils.toInt(rendererId, 0)) {
        case 2:
          return {
            id: 2,
            scriptPath: "./js/display/renderers/h264-broadway/h264Brodway.js",
            binaryType: "arraybuffer",
          };
        case 1:
          return {
            id: 1,
            scriptPath: "./js/display/renderers/h264-webcodecs/h264WebCodecs.js",
            binaryType: "arraybuffer",
          };
        case 0:
        default:
          return {
            id: 0,
            scriptPath: "./js/display/renderers/mjpeg/mjpeg.js",
            binaryType: "blob",
          };
      }
    }

    _ensureRendererScript(rendererInfo) {
      if (
        this.renderer.scriptPath === rendererInfo.scriptPath &&
        typeof global.drawDisplayFrame === "function"
      ) {
        return Promise.resolve();
      }

      if (this.renderer.loadPromise) {
        return this.renderer.loadPromise;
      }

      global.displayWidth = this.lastDisplaySize.displayWidth;
      global.displayHeight = this.lastDisplaySize.displayHeight;

      this.renderer.id = rendererInfo.id;
      this.renderer.scriptPath = rendererInfo.scriptPath;

      this.renderer.loadPromise = new Promise((resolve, reject) => {
        const script = document.createElement("script");
        script.src = rendererInfo.scriptPath;
        script.async = true;
        script.onload = () => {
          this.renderer.loadPromise = null;
          resolve();
        };
        script.onerror = (error) => {
          this.renderer.loadPromise = null;
          reject(error);
        };
        document.head.appendChild(script);
      });

      return this.renderer.loadPromise;
    }
  }

  TAHtml.DisplayRendererManager = DisplayRendererManager;
})(window);
