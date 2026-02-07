(function (global) {
  "use strict";

  const TAHtml = global.TAHtml;
  const constants = TAHtml.constants;
  const FORCE_SHOW_UPDATE_BUTTON_PREVIEW = false;

  class HomeController {
    constructor(options) {
      this.apiClient = options.apiClient;
      this.audioController = options.audioController;
      this.onSettingsRequested = options.onSettingsRequested;

      this.audioButton = options.audioButton;
      this.updateButton = options.updateButton;
      this.settingsButton = options.settingsButton;

      this.isUpdateAvailable = false;
      this.latestVersion = null;
      this.forceShowUpdateButtonPreview = FORCE_SHOW_UPDATE_BUTTON_PREVIEW;
      this.audioConfig = {
        isEnabled: true,
        volume: 100,
      };

      this._audioStateListener = null;
    }

    async initialize(systemConfiguration) {
      this._wireEvents();
      if (systemConfiguration) {
        this.applySystemConfiguration(systemConfiguration);
      }
      await this.checkForUpdates();
      this._refreshAudioButton();
      this._refreshUpdateButton();
    }

    applySystemConfiguration(configuration) {
      const enabled = TAHtml.utils.toInt(
        configuration["persist.tesla-android.browser_audio.is_enabled"],
        1,
      ) === 1;
      const volumeRaw = TAHtml.utils.toInt(
        configuration["persist.tesla-android.browser_audio.volume"],
        100,
      );
      const volumeNormalized = Math.max(0, Math.min(150, volumeRaw));

      this.audioConfig = {
        isEnabled: enabled,
        volume: volumeNormalized,
      };

      this.audioController.applyConfiguration({
        audioWebsocketUrl: this.audioController.audioWebsocketUrl,
        isAudioEnabled: enabled,
        audioVolume: volumeNormalized / 100,
      });

      this._refreshAudioButton();
    }

    async checkForUpdates() {
      try {
        const latestRelease = await this.apiClient.fetchLatestRelease();
        this.latestVersion = this._extractReleaseVersion(latestRelease);
        this.isUpdateAvailable =
          this.latestVersion !== null &&
          TAHtml.utils.compareVersions(constants.APP_VERSION, this.latestVersion) === 1;
      } catch (error) {
        TAHtml.log("Unable to check updates: " + String(error));
        this.isUpdateAvailable = false;
      }

      this._refreshUpdateButton();
    }

    _wireEvents() {
      this.audioButton.addEventListener("click", () => {
        this.audioController.toggle();
        this._refreshAudioButton();
      });

      this.updateButton.addEventListener("click", async () => {
        if (!this.isUpdateAvailable && !this.forceShowUpdateButtonPreview) {
          return;
        }
        try {
          await this.apiClient.openUpdater();
        } catch (error) {
          TAHtml.log("Unable to launch updater: " + String(error));
        }
      });

      this.settingsButton.addEventListener("click", () => {
        if (typeof this.onSettingsRequested === "function") {
          this.onSettingsRequested();
        }
      });

      this._audioStateListener = (event) => {
        if (event && event.detail) {
          this._refreshAudioButton();
        }
      };
      global.addEventListener("audio-state", this._audioStateListener);
    }

    _refreshAudioButton() {
      const shouldShow = Boolean(this.audioConfig.isEnabled);
      this.audioButton.hidden = !shouldShow;
      if (!shouldShow) {
        return;
      }

      const isPlaying = this.audioController.getAudioState() === "playing";
      this._setButtonIcon(this.audioButton, isPlaying ? "volume_up" : "volume_off");
      this.audioButton.title = isPlaying ? "Disable browser audio" : "Enable browser audio";
    }

    _refreshUpdateButton() {
      const shouldShow = this.isUpdateAvailable || this.forceShowUpdateButtonPreview;
      this.updateButton.hidden = !shouldShow;
      if (!shouldShow) {
        return;
      }
      this._setButtonIcon(this.updateButton, "download");
      if (this.isUpdateAvailable) {
        this.updateButton.title =
          this.latestVersion && this.latestVersion.length > 0
            ? "Update available: " + this.latestVersion
            : "Update available";
        return;
      }
      this.updateButton.title = "Update button preview (forced)";
    }

    _setButtonIcon(button, iconName) {
      if (!button) {
        return;
      }
      button.innerHTML = "";
      const icon = document.createElement("span");
      icon.className = "material-symbols-rounded home-control-icon";
      icon.textContent = String(iconName || "");
      button.appendChild(icon);
    }

    _extractReleaseVersion(release) {
      if (!release || typeof release !== "object") {
        return null;
      }

      const candidates = [
        release.name,
        release.tag_name,
        release.tagName,
      ];

      for (let index = 0; index < candidates.length; index += 1) {
        const normalized = this._normalizeVersion(candidates[index]);
        if (normalized !== null) {
          return normalized;
        }
      }

      return null;
    }

    _normalizeVersion(value) {
      if (typeof value !== "string") {
        return null;
      }
      const trimmed = value.trim();
      if (trimmed.length === 0) {
        return null;
      }

      // Accept both "2026.3.1" and tag-like strings such as "v2026.3.1".
      const match = trimmed.match(/(\d+\.\d+\.\d+(?:\.\d+)?)/);
      if (!match) {
        return null;
      }
      return match[1];
    }
  }

  TAHtml.HomeController = HomeController;
})(window);
