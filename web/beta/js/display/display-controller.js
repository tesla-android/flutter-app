(function (global) {
  "use strict";

  const TAHtml = global.TAHtml;
  const utils = TAHtml.utils;
  const constants = TAHtml.constants;

  class DisplayController {
    constructor(options) {
      this.apiClient = options.apiClient;
      this.rendererManager = options.rendererManager;
      this.flavor = options.flavor;
      this.onResizeSessionRefresh = options.onResizeSessionRefresh || null;
      this.onResizeModeChange =
        typeof options.onResizeModeChange === "function" ? options.onResizeModeChange : null;

      this.dialog = options.dialog;
      this.dialogMainButton = options.dialogMainButton;
      this.dialogRearButton = options.dialogRearButton;

      this.remoteDisplayState = null;

      this.display = {
        viewSize: { width: 1, height: 1 },
        adjustedSize: { width: 1, height: 1 },
      };

      this.resize = {
        mode: "initial",
        token: 0,
        timerId: null,
        pendingViewSize: null,
        cooldownState: null,
      };

      this._dialogWired = false;
      this._viewportWatcherStarted = false;
      this.isPaused = false;

      this._notifyResizeMode(this.resize.mode);
    }

    async initialize() {
      this._wireDialogEvents();

      const remoteDisplayState = this._normalizeRemoteDisplayState(
        await this.apiClient.fetchDisplayState(),
      );
      this.remoteDisplayState = remoteDisplayState;

      this._setNormalState({
        viewSize: utils.getViewportSize(),
        adjustedSize: {
          width: remoteDisplayState.width,
          height: remoteDisplayState.height,
        },
        remoteDisplayState,
      });

      await this.rendererManager.ensureDisplaySocket({
        displayWebSocket: this.flavor.displayWebSocket,
        remoteDisplayState,
      });

      this._setupViewportWatcher();
      this.triggerResizeFromViewport();
    }

    getTouchscreenSize() {
      return {
        width: this.display.adjustedSize.width,
        height: this.display.adjustedSize.height,
      };
    }

    setResizeSessionRefreshHandler(handler) {
      this.onResizeSessionRefresh = typeof handler === "function" ? handler : null;
    }

    setResizeModeChangeHandler(handler) {
      this.onResizeModeChange = typeof handler === "function" ? handler : null;
      this._notifyResizeMode(this.resize.mode);
    }

    triggerResizeFromViewport() {
      this.triggerResize(utils.getViewportSize());
    }

    triggerResize(viewSize) {
      if (this.isPaused) {
        return;
      }
      const normalizedViewSize = utils.normalizeSize(viewSize, {
        fallback: { width: 1, height: 1 },
      });
      void this._startResize(normalizedViewSize);
    }

    async _startResize(viewSize) {
      if (this.isPaused) {
        return;
      }
      if (!this.flavor) {
        return;
      }

      if (this.resize.mode === "resize_cooldown") {
        const scheduled = this.resize.cooldownState;
        if (scheduled && utils.sameSize(scheduled.viewSize, viewSize)) {
          return;
        }
        this._clearResizeTimer();
      }

      const token = ++this.resize.token;
      this.resize.pendingViewSize = viewSize;

      let remoteDisplayState;
      try {
        remoteDisplayState = this._normalizeRemoteDisplayState(
          await this.apiClient.fetchDisplayState(),
        );
      } catch (error) {
        TAHtml.log("Unable to fetch display state for resize: " + String(error));
        return;
      }

      if (token !== this.resize.token) {
        return;
      }

      this.remoteDisplayState = remoteDisplayState;

      const isRearDisplayEnabled = remoteDisplayState.isRearDisplayEnabled === 1;
      const isRearDisplayPrioritised = remoteDisplayState.isRearDisplayPrioritised === 1;
      const isPrimaryDisplay = isRearDisplayEnabled
        ? this._readPrimaryDisplayPreference()
        : true;

      if (isPrimaryDisplay === null && isRearDisplayEnabled) {
        this._setResizeMode("display_type_selection");
        this._showDisplayTypeSelectionDialog();
        return;
      }

      this._hideDisplayTypeSelectionDialog();

      let desiredSize;

      if (isPrimaryDisplay === true || (isPrimaryDisplay === false && isRearDisplayPrioritised)) {
        const sizeForCalculation = remoteDisplayState.isResponsive === 1
          ? viewSize
          : constants.DEFAULT_NON_RESPONSIVE_SIZE;

        desiredSize = this._calculateOptimalSize(sizeForCalculation, {
          resolutionPreset: remoteDisplayState.resolutionPreset,
          isH264: remoteDisplayState.isH264 === 1,
          isHeadless: (remoteDisplayState.isHeadless ?? 1) === 1,
        });
      } else {
        desiredSize = {
          width: remoteDisplayState.width,
          height: remoteDisplayState.height,
        };

        this._setNormalState({
          viewSize,
          adjustedSize: desiredSize,
          remoteDisplayState,
        });
        return;
      }

      this._setResizeMode("resize_cooldown");
      this.resize.cooldownState = {
        token,
        viewSize,
        adjustedSize: desiredSize,
        resolutionPreset: remoteDisplayState.resolutionPreset,
        renderer: remoteDisplayState.renderer,
        isResponsive: remoteDisplayState.isResponsive === 1,
        quality: remoteDisplayState.quality,
        refreshRate: remoteDisplayState.refreshRate,
        isRearDisplayEnabled,
        isRearDisplayPrioritised,
      };

      this.resize.timerId = global.setTimeout(() => {
        void this._sendResizeRequest(token);
      }, constants.RESIZE_COOLDOWN_MS);
    }

    async _sendResizeRequest(token) {
      const cooldown = this.resize.cooldownState;
      if (!cooldown || this.resize.mode !== "resize_cooldown" || cooldown.token !== token) {
        return;
      }

      this._setResizeMode("resize_in_progress");
      this.resize.timerId = null;

      const isH264 = cooldown.renderer !== 0;
      const density = this._densityForResolutionPreset(cooldown.resolutionPreset, isH264);

      const payload = {
        width: cooldown.adjustedSize.width,
        height: cooldown.adjustedSize.height,
        density,
        resolutionPreset: cooldown.resolutionPreset,
        renderer: cooldown.renderer,
        isResponsive: cooldown.isResponsive ? 1 : 0,
        isH264: isH264 ? 1 : 0,
        quality: cooldown.quality,
        refreshRate: cooldown.refreshRate,
        isRearDisplayEnabled: cooldown.isRearDisplayEnabled ? 1 : 0,
        isRearDisplayPrioritised: cooldown.isRearDisplayPrioritised ? 1 : 0,
      };

      try {
        await this.apiClient.postDisplayState(payload);
      } catch (error) {
        TAHtml.log("Resize request failed: " + String(error));
        this._setResizeMode("normal");
        this.resize.cooldownState = null;
        return;
      }

      if (token !== this.resize.token) {
        return;
      }

      this.remoteDisplayState = {
        ...this.remoteDisplayState,
        ...payload,
      };

      await utils.delay(constants.RESIZE_COOLDOWN_MS);

      if (token !== this.resize.token) {
        return;
      }

      if (!this.isPaused) {
        this.rendererManager.closeDisplaySocket();
        if (typeof this.onResizeSessionRefresh === "function") {
          try {
            this.onResizeSessionRefresh({
              width: cooldown.adjustedSize.width,
              height: cooldown.adjustedSize.height,
            });
          } catch (_error) {
            // no-op
          }
        }
      }

      this._setNormalState({
        viewSize: cooldown.viewSize,
        adjustedSize: cooldown.adjustedSize,
        remoteDisplayState: this.remoteDisplayState,
      });
    }

    _setNormalState(options) {
      const remoteDisplayState = options.remoteDisplayState || this.remoteDisplayState;
      if (!remoteDisplayState) {
        return;
      }

      this._clearResizeTimer();
      this._setResizeMode("normal");
      this.resize.cooldownState = null;

      this.display.viewSize = utils.normalizeSize(options.viewSize, {
        fallback: utils.getViewportSize(),
      });

      this.display.adjustedSize = utils.normalizeSize(options.adjustedSize, {
        fallback: {
          width: remoteDisplayState.width,
          height: remoteDisplayState.height,
        },
      });

      global.displayWidth = this.display.adjustedSize.width;
      global.displayHeight = this.display.adjustedSize.height;

      this.rendererManager.applyDisplaySize(
        this.display.adjustedSize.width,
        this.display.adjustedSize.height,
      );

      if (!this.isPaused) {
        void this.rendererManager.ensureDisplaySocket({
          displayWebSocket: this.flavor.displayWebSocket,
          remoteDisplayState,
        });
      }
    }

    setPaused(paused) {
      const nextPaused = Boolean(paused);
      if (nextPaused === this.isPaused) {
        return;
      }

      this.isPaused = nextPaused;

      if (nextPaused) {
        this._hideDisplayTypeSelectionDialog();
        this._clearResizeTimer();
        this.rendererManager.closeDisplaySocket();
      } else {
        if (this.remoteDisplayState) {
          void this.rendererManager.ensureDisplaySocket({
            displayWebSocket: this.flavor.displayWebSocket,
            remoteDisplayState: this.remoteDisplayState,
          });
        }
        this.triggerResizeFromViewport();
      }
    }

    _setupViewportWatcher() {
      if (this._viewportWatcherStarted) {
        return;
      }
      this._viewportWatcherStarted = true;

      let lastViewport = utils.getViewportSize();

      const onPotentialResize = () => {
        if (this.isPaused) {
          return;
        }

        const current = utils.getViewportSize();
        if (!utils.sameSize(current, lastViewport)) {
          lastViewport = current;

          if (this.display.adjustedSize.width > 0 && this.display.adjustedSize.height > 0) {
            this.rendererManager.applyDisplaySize(
              this.display.adjustedSize.width,
              this.display.adjustedSize.height,
            );
          }

          this.triggerResize(current);
        }
      };

      const rafCheck = () => {
        onPotentialResize();
        global.requestAnimationFrame(rafCheck);
      };

      global.addEventListener("resize", onPotentialResize, { passive: true });
      global.addEventListener("orientationchange", onPotentialResize, { passive: true });

      if (global.visualViewport) {
        global.visualViewport.addEventListener("resize", onPotentialResize, {
          passive: true,
        });
        global.visualViewport.addEventListener("scroll", onPotentialResize, {
          passive: true,
        });
      }

      global.requestAnimationFrame(rafCheck);
    }

    _wireDialogEvents() {
      if (this._dialogWired) {
        return;
      }
      this._dialogWired = true;

      if (this.dialogMainButton) {
        this.dialogMainButton.addEventListener("click", () => {
          this._onDisplayTypeSelectionFinished(true);
        });
      }

      if (this.dialogRearButton) {
        this.dialogRearButton.addEventListener("click", () => {
          this._onDisplayTypeSelectionFinished(false);
        });
      }
    }

    _onDisplayTypeSelectionFinished(isPrimaryDisplay) {
      this._storePrimaryDisplayPreference(isPrimaryDisplay);
      this._hideDisplayTypeSelectionDialog();

      const pendingViewSize = this.resize.pendingViewSize || utils.getViewportSize();
      this.triggerResize(pendingViewSize);
    }

    _showDisplayTypeSelectionDialog() {
      if (this.dialog) {
        this.dialog.hidden = false;
      }
    }

    _hideDisplayTypeSelectionDialog() {
      if (this.dialog) {
        this.dialog.hidden = true;
      }
    }

    _readPrimaryDisplayPreference() {
      for (let index = 0; index < constants.DISPLAY_PREF_KEYS.length; index += 1) {
        const key = constants.DISPLAY_PREF_KEYS[index];
        const raw = global.localStorage.getItem(key);
        if (raw === null) {
          continue;
        }

        const parsed = utils.parseBoolean(raw);
        if (parsed !== null) {
          return parsed;
        }

        try {
          const parsedJson = JSON.parse(raw);
          const parsedFromJson = utils.parseBoolean(parsedJson);
          if (parsedFromJson !== null) {
            return parsedFromJson;
          }
        } catch (_error) {
          // no-op
        }
      }

      return null;
    }

    _storePrimaryDisplayPreference(value) {
      const encoded = value ? "true" : "false";
      for (let index = 0; index < constants.DISPLAY_PREF_KEYS.length; index += 1) {
        global.localStorage.setItem(constants.DISPLAY_PREF_KEYS[index], encoded);
      }
    }

    _normalizeRemoteDisplayState(raw) {
      return {
        width: Math.max(1, utils.toInt(raw.width, 1024)),
        height: Math.max(1, utils.toInt(raw.height, 768)),
        density: utils.toInt(raw.density, 200),
        resolutionPreset: utils.toInt(raw.resolutionPreset, 0),
        renderer: utils.toInt(raw.renderer, 0),
        isHeadless:
          raw.isHeadless === undefined || raw.isHeadless === null
            ? 1
            : utils.toInt(raw.isHeadless, 1),
        isResponsive: utils.toInt(raw.isResponsive, 1),
        isH264: utils.toInt(raw.isH264, 0),
        refreshRate: utils.toInt(raw.refreshRate, 30),
        quality: utils.toInt(raw.quality, 90),
        isRearDisplayEnabled: utils.toInt(raw.isRearDisplayEnabled, 0),
        isRearDisplayPrioritised: utils.toInt(raw.isRearDisplayPrioritised, 0),
      };
    }

    _calculateOptimalSize(viewSize, options) {
      const isHeadless = Boolean(options.isHeadless);
      if (!isHeadless) {
        return { width: 1024, height: 768 };
      }

      const resolutionPreset = utils.toInt(options.resolutionPreset, 0);
      const isH264 = Boolean(options.isH264);

      let adjustedResolutionPreset;
      if (isH264) {
        adjustedResolutionPreset = resolutionPreset === 0 ? 0 : 1;
      } else {
        adjustedResolutionPreset = resolutionPreset;
      }

      const maxWidth = 1920;
      const maxHeight = 1088;
      const minSide = 320;

      const safeView = utils.normalizeSize(viewSize, {
        fallback: { width: 1024, height: 768 },
      });
      const aspectRatio = safeView.width / safeView.height;

      let width = utils.clamp(safeView.width, minSide, maxWidth);
      let height = width / aspectRatio;

      if (height > maxHeight) {
        height = maxHeight;
        width = height * aspectRatio;
      }

      const maxShortest = this._maxHeightForResolutionPreset(adjustedResolutionPreset);
      const shortest = Math.min(width, height);
      if (shortest > maxShortest) {
        const scale = maxShortest / shortest;
        width *= scale;
        height *= scale;
      }

      width = utils.alignUp(width, 64);
      height = utils.alignUp(height, 32);

      if (height <= 480) {
        height = 512;
        width = utils.alignUp(height * aspectRatio, 64);
      }

      if (width < minSide) {
        width = utils.alignUp(minSide, 64);
      }
      if (height < minSide) {
        height = utils.alignUp(minSide, 32);
      }

      width = Math.min(width, maxWidth);
      height = Math.min(height, maxHeight);

      return {
        width: Math.round(width),
        height: Math.round(height),
      };
    }

    _maxHeightForResolutionPreset(preset) {
      switch (utils.toInt(preset, 0)) {
        case 0:
          return 832;
        case 1:
          return 720;
        case 2:
          return 640;
        case 3:
          return 544;
        case 4:
          return 480;
        default:
          return 832;
      }
    }

    _densityForResolutionPreset(preset, isH264) {
      const normalizedPreset = utils.toInt(preset, 0);

      if (isH264) {
        switch (normalizedPreset) {
          case 0:
            return 200;
          case 1:
            return 175;
          default:
            return 175;
        }
      }

      switch (normalizedPreset) {
        case 0:
          return 200;
        case 1:
          return 175;
        case 2:
          return 155;
        case 3:
          return 130;
        case 4:
          return 115;
        default:
          return 200;
      }
    }

    _clearResizeTimer() {
      if (this.resize.timerId !== null) {
        global.clearTimeout(this.resize.timerId);
        this.resize.timerId = null;
      }
    }

    _setResizeMode(mode) {
      if (this.resize.mode === mode) {
        return;
      }
      this.resize.mode = mode;
      this._notifyResizeMode(mode);
    }

    _notifyResizeMode(mode) {
      if (typeof this.onResizeModeChange === "function") {
        try {
          this.onResizeModeChange(String(mode || "initial"));
        } catch (_error) {
          // no-op
        }
      }
    }
  }

  TAHtml.DisplayController = DisplayController;
})(window);
