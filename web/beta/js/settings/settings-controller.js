(function (global) {
  "use strict";

  const TAHtml = global.TAHtml;
  const utils = TAHtml.utils;
  const constants = TAHtml.constants;

  class SettingsController {
    constructor(options) {
      this.apiClient = options.apiClient;
      this.displayController = options.displayController;
      this.gpsController = options.gpsController;
      this.audioController = options.audioController;
      this.flavor = options.flavor;
      this.onSystemConfigurationChanged = options.onSystemConfigurationChanged;

      this.sidebar = options.sidebar;
      this.content = options.content;
      this.banner = options.banner;
      this.bannerText = options.bannerText;
      this.bannerAction = options.bannerAction;

      this.sections = [
        { id: "display", title: "Display", icon: "monitor" },
        { id: "rearDisplay", title: "Rear Display", icon: "tv" },
        { id: "network", title: "Network", icon: "wifi" },
        { id: "audio", title: "Audio", icon: "speaker" },
        { id: "gps", title: "GPS", icon: "gps_fixed" },
        { id: "device", title: "Device", icon: "developer_board" },
      ];

      this.activeSectionId = "display";
      this._renderToken = 0;
      this._activeDropdown = null;

      this.systemConfigCache = null;
      this.networkPendingConfig = null;
      this._bindBannerEvents();
      this._bindGlobalEvents();
    }

    async initialize() {
      this._renderSidebar();
      await this.setActiveSection(this.activeSectionId);
    }

    async setActiveSection(sectionId) {
      this.activeSectionId = sectionId;
      this._renderSidebar();
      await this._renderActiveSection();
      this._refreshNetworkBanner();
    }

    async _renderActiveSection() {
      const token = ++this._renderToken;
      this._setActiveDropdown(null);
      this.content.innerHTML = "";

      if (this.activeSectionId === "display") {
        await this._renderDisplaySection(token);
        return;
      }
      if (this.activeSectionId === "rearDisplay") {
        await this._renderRearDisplaySection(token);
        return;
      }
      if (this.activeSectionId === "network") {
        await this._renderNetworkSection(token);
        return;
      }
      if (this.activeSectionId === "audio") {
        await this._renderAudioSection(token);
        return;
      }
      if (this.activeSectionId === "gps") {
        await this._renderGpsSection(token);
        return;
      }
      if (this.activeSectionId === "device") {
        await this._renderDeviceSection(token);
      }
    }

    async _renderDisplaySection(token) {
      this._appendLoadingState();

      let config;
      try {
        config = this._normalizeDisplayState(await this.apiClient.fetchDisplayState());
      } catch (_error) {
        this._renderErrorState("Service error");
        return;
      }

      if (token !== this._renderToken || this.activeSectionId !== "display") {
        return;
      }

      this.content.innerHTML = "";

      this._appendTile({
        icon: "texture",
        title: "Renderer",
        trailing: this._createSelect(constants.DISPLAY_RENDERERS, config.renderer, async (value) => {
          const renderer = utils.toInt(value, config.renderer);
          await this._updateDisplayConfig((draft) => {
            draft.renderer = renderer;
            draft.isH264 = renderer !== 0 ? 1 : 0;
            draft.density = utils.densityForResolutionPreset(draft.resolutionPreset, draft.isH264 === 1);
          });
        }),
      });
      this._appendDescription(
        "Tesla Android supports both h264 and MJPEG display compression. MJPEG has less visible compression artifacts but needs much more bandwidth.\n\nNOTE: WebCodecs may not work if your car is running Tesla Firmware older than 2025.32.",
      );
      this._appendDivider();

      this._appendTile({
        icon: "display_settings",
        title: "Resolution",
        trailing: this._createSelect(constants.DISPLAY_RESOLUTION_PRESETS, config.resolutionPreset, async (value) => {
          const preset = utils.toInt(value, config.resolutionPreset);
          await this._updateDisplayConfig((draft) => {
            draft.resolutionPreset = preset;
            draft.density = utils.densityForResolutionPreset(draft.resolutionPreset, draft.isH264 === 1);
          });
        }),
      });
      this._appendDescription(
        "Choosing a low resolution improves the display performance in Drive. It reduces the browser load, meant for cars equipped with MCU2. Resolutions lower than 720p only work with the MJPEG renderer.",
      );
      this._appendDivider();

      this._appendTile({
        icon: "photo_size_select_actual_outlined",
        title: "Image quality",
        trailing: this._createSelect(constants.DISPLAY_QUALITY_PRESETS, config.quality, async (value) => {
          const quality = utils.toInt(value, config.quality);
          await this._updateDisplayConfig((draft) => {
            draft.quality = quality;
          });
        }),
      });
      this._appendDescription(
        "Reducing the image quality can significantly improve performance when a higher resolution is used.",
      );
      this._appendDivider();

      this._appendTile({
        icon: "monitor",
        title: "Refresh rate",
        trailing: this._createSelect(constants.DISPLAY_REFRESH_RATE_PRESETS, config.refreshRate, async (value) => {
          const refreshRate = utils.toInt(value, config.refreshRate);
          await this._updateDisplayConfig((draft) => {
            draft.refreshRate = refreshRate;
          });
        }),
      });
      this._appendDescription(
        "By default Tesla Android is running in 30Hz. You can increase the frame rate with this setting. This feature is experimental.",
      );
      this._appendDivider();

      this._appendTile({
        icon: "photo_size_select_large",
        title: "Dynamic aspect ratio",
        trailing: this._createSwitch(config.isResponsive === 1, async (checked) => {
          await this._updateDisplayConfig((draft) => {
            draft.isResponsive = checked ? 1 : 0;
          });
        }),
      });
      this._appendDescription(
        "Advanced setting, Tesla Android can automatically resize the virtual display when the browser window size changes. If you disable this option, the display aspect will be locked on the current value.",
      );
    }

    async _renderRearDisplaySection(token) {
      this._appendLoadingState();

      let config;
      try {
        config = this._normalizeDisplayState(await this.apiClient.fetchDisplayState());
      } catch (_error) {
        this._renderErrorState("Service error");
        return;
      }

      if (token !== this._renderToken || this.activeSectionId !== "rearDisplay") {
        return;
      }

      this.content.innerHTML = "";

      this._appendTile({
        icon: "monitor",
        title: "Rear Display Support",
        trailing: this._createSwitch(config.isRearDisplayEnabled === 1, async (checked) => {
          await this._updateDisplayConfig((draft) => {
            draft.isRearDisplayEnabled = checked ? 1 : 0;
          }, false);
          await this._renderActiveSection();
        }),
      });
      this._appendDescription(
        "Enable if your vehicle is equipped with a factory rear display.\n\nSupported models:\n\n- Model 3 (2023+ / \u201cHighland\u201d)\n- Model Y (2025+ / \u201cJuniper\u201d)\n- Model S/X (2021+)\n- Cybertruck",
      );

      if (config.isRearDisplayEnabled === 1) {
        const isPrimaryDisplay = this._readPrimaryDisplayPreference();

        this._appendDivider();
        this._appendTile({
          icon: "screenshot_monitor",
          title: "Primary Display",
          trailing: this._createSwitch(
            isPrimaryDisplay === null ? true : isPrimaryDisplay,
            async (checked) => {
              this._storePrimaryDisplayPreference(checked);
            },
          ),
        });
        this._appendDescription(
          "Enable this option if you are currently using Tesla Android on your main infotainment display.",
        );

        this._appendDivider();
        this._appendTile({
          icon: "aspect_ratio",
          title: "Rear Display Priority",
          trailing: this._createSwitch(config.isRearDisplayPrioritised === 1, async (checked) => {
            await this._updateDisplayConfig((draft) => {
              draft.isRearDisplayPrioritised = checked ? 1 : 0;
            }, false);
          }),
        });
        this._appendDescription(
          "Enable this option to synchronize the aspect ratio of your Tesla Android display with the secondary display.",
        );
      }
    }

    async _renderNetworkSection(token) {
      this._appendLoadingState();

      if (!this.systemConfigCache) {
        try {
          this.systemConfigCache = await this.apiClient.fetchSystemConfiguration();
        } catch (_error) {
          this._renderErrorState("Failed to fetch Wi-Fi configuration from your device.");
          return;
        }
      }

      if (!this.networkPendingConfig) {
        this.networkPendingConfig = this._networkPendingFromSystemConfig(this.systemConfigCache);
      }

      if (token !== this._renderToken || this.activeSectionId !== "network") {
        return;
      }

      this.content.innerHTML = "";

      this._appendTile({
        icon: "wifi_channel",
        title: "Frequency band and channel",
        trailing: this._createSelect(
          constants.SOFT_AP_BANDS.map((item) => ({ value: item.key, label: item.name })),
          this.networkPendingConfig.bandType.key,
          async (value) => {
            const selected = this._bandByKey(value);
            if (!selected) {
              return;
            }
            this.networkPendingConfig.bandType = selected;
            this._refreshNetworkBanner();
          },
        ),
      });

      this._appendDescription(
        "The utilization of the 5 GHz operation mode enhances the performance of the Tesla Android system while effectively resolving Bluetooth-related challenges. If your car does not see the Tesla Android network please change the channel, supported channels differ by region. This mode is anticipated to be designated as the default option in a future versions.\n\nConversely, when operating on the 2.4 GHz frequency, the allocation of resources between the hotspot and Bluetooth can lead to dropped frames, particularly when utilizing AD2P audio.",
      );
      this._appendDivider();

      this._appendTile({
        icon: "wifi_off",
        title: "Offline mode",
        subtitle: "Persistent Wi-Fi connection",
        trailing: this._createSwitch(this.networkPendingConfig.isOfflineModeEnabled, async (checked) => {
          this.networkPendingConfig.isOfflineModeEnabled = checked;
          this._refreshNetworkBanner();
        }),
      });
      this._appendDivider();

      this._appendDescription(
        "To ensure continuous internet access, your Tesla vehicle relies on Wi-Fi networks that have an active internet connection. However, if you encounter a situation where Wi-Fi connectivity is unavailable, there is a solution called \"offline mode\" to address this limitation. In offline mode, certain features like Tesla Mobile App access and other car-side functionalities that rely on internet connectivity will be disabled. To overcome this limitation, you can establish internet access in your Tesla Android setup by using an LTE Modem or enabling tethering.",
      );
      this._appendDivider();

      this._appendTile({
        icon: "data_thresholding_sharp",
        title: "Tesla Telemetry",
        subtitle: "Reduces data usage, uncheck to disable",
        trailing: this._createSwitch(this.networkPendingConfig.isOfflineModeTelemetryEnabled, async (checked) => {
          this.networkPendingConfig.isOfflineModeTelemetryEnabled = checked;
          this._refreshNetworkBanner();
        }),
      });
      this._appendDivider();

      this._appendTile({
        icon: "update",
        title: "Tesla Software Updates",
        subtitle: "Reduces data usage, uncheck to disable",
        trailing: this._createSwitch(this.networkPendingConfig.isOfflineModeTeslaFirmwareDownloadsEnabled, async (checked) => {
          this.networkPendingConfig.isOfflineModeTeslaFirmwareDownloadsEnabled = checked;
          this._refreshNetworkBanner();
        }),
      });
      this._appendDescription(
        "Your car will still be able to check the availability of new updates. With this option enabled they won't immediately start downloading",
      );

      this._refreshNetworkBanner();
    }

    async _renderAudioSection(token) {
      this._appendLoadingState();

      const systemConfiguration = await this._fetchSystemConfigurationSafe();
      if (!systemConfiguration) {
        this._renderErrorState("Service error");
        return;
      }

      if (token !== this._renderToken || this.activeSectionId !== "audio") {
        return;
      }

      const isEnabled =
        utils.toInt(systemConfiguration["persist.tesla-android.browser_audio.is_enabled"], 1) === 1;
      const volume = utils.toInt(
        systemConfiguration["persist.tesla-android.browser_audio.volume"],
        100,
      );

      this.content.innerHTML = "";

      this._appendTile({
        icon: "speaker",
        title: "Browser audio",
        subtitle: "Disable if you intend to use Bluetooth audio",
        trailing: this._createSwitch(isEnabled, async (checked) => {
          try {
            await this.apiClient.setBrowserAudioState(checked ? 1 : 0);
            await this.apiClient.setBrowserAudioVolume(100);
            await this._handleSystemConfigurationChanged();
            await this._renderActiveSection();
          } catch (_error) {
            this._renderErrorState("Service error");
          }
        }),
      });
      this._appendDivider();

      const sliderWrap = utils.createElement("div", "settings-volume-wrap", null);
      const sliderValue = utils.createElement("span", "settings-volume-value", String(volume) + " %");
      const slider = utils.createElement("input", "settings-volume-slider", null);
      slider.type = "range";
      slider.min = "0";
      slider.max = "150";
      slider.step = "10";
      slider.value = String(volume);
      slider.addEventListener("input", () => {
        sliderValue.textContent = String(slider.value) + " %";
      });
      slider.addEventListener("change", async () => {
        try {
          await this.apiClient.setBrowserAudioState(1);
          await this.apiClient.setBrowserAudioVolume(utils.toInt(slider.value, volume));
          await this._handleSystemConfigurationChanged();
          await this._renderActiveSection();
        } catch (_error) {
          this._renderErrorState("Service error");
        }
      });
      sliderWrap.appendChild(sliderValue);
      sliderWrap.appendChild(slider);

      this._appendTile({
        icon: "volume_down",
        title: "Volume",
        trailing: sliderWrap,
        dense: false,
      });

      this._appendDescription(
        "If you plan to use browser audio continuously in conjunction with video playback, it's essential to note that it can be bandwidth-intensive. To optimize your experience, you may want to consider pairing your car with the Tesla Android device over Bluetooth, particularly if your Tesla is equipped with MCU2.",
      );
      this._appendDescription(
        "In case you encounter a situation where the browser in your Tesla fails to produce sound, a simple reboot of the vehicle should resolve the issue. Please note that this is a known issue with the browser itself.",
      );
    }

    async _renderGpsSection(token) {
      this._appendLoadingState();

      const systemConfiguration = await this._fetchSystemConfigurationSafe();
      if (!systemConfiguration) {
        this._renderErrorState("Service error");
        return;
      }

      if (token !== this._renderToken || this.activeSectionId !== "gps") {
        return;
      }

      const isEnabled =
        utils.toInt(systemConfiguration["persist.tesla-android.gps.is_active"], 1) === 1;

      this.content.innerHTML = "";

      this._appendTile({
        icon: "gps_fixed",
        title: "GPS",
        subtitle: "Disable if you don't use Android navigation apps",
        trailing: this._createSwitch(isEnabled, async (checked) => {
          try {
            await this.apiClient.setGpsState(checked ? 1 : 0);
            await this._handleSystemConfigurationChanged();
            this.gpsController.setEnabled(checked);
            await this._renderActiveSection();
          } catch (_error) {
            this._renderErrorState("Service error");
          }
        }),
      });

      this._appendDescription(
        "NOTE: GPS via Browser can cause crashes on Tesla Software 2024.14 or newer, the integration is disabled by default until this issue is solved by Tesla. Please be assured that your location data never leaves your car. The real-time location updates sent to your Tesla Android device are solely utilized to emulate a hardware GPS module in the Android OS.",
      );
    }

    async _renderDeviceSection(token) {
      this._appendLoadingState();

      let deviceInfo;
      try {
        deviceInfo = await this.apiClient.fetchDeviceInfo();
      } catch (_error) {
        this._renderErrorState("Service error");
        return;
      }

      if (token !== this._renderToken || this.activeSectionId !== "device") {
        return;
      }

      const deviceModel = utils.mapDeviceModelName(deviceInfo.device_model);

      this.content.innerHTML = "";

      this._appendTile({
        icon: "device_thermostat",
        title: "CPU Temperature",
        trailing: this._createTrailingText(String(utils.toInt(deviceInfo.cpu_temperature, 0)) + "\u00B0C"),
      });
      this._appendDescription(
        "CPU temperature should not exceed 80\u00B0C. Make sure the device is actively cooled and proper ventilation is provided.",
      );
      this._appendDivider();

      this._appendTile({
        icon: "perm_device_info",
        title: "Model",
        trailing: this._createTrailingText(deviceModel),
        dense: false,
      });
      this._appendTile({
        icon: "developer_board_rounded",
        title: "Serial Number",
        trailing: this._createTrailingText(String(deviceInfo.serial_number || "undefined")),
        dense: false,
      });
      this._appendTile({
        icon: "broadcast_on_home_sharp",
        title: "CarPlay Module",
        trailing: this._createTrailingText(
          utils.toInt(deviceInfo.is_carplay_detected, 0) === 1 ? "Connected" : "Not connected",
        ),
        dense: false,
      });
      this._appendTile({
        icon: "cell_tower",
        title: "LTE Modem",
        trailing: this._createTrailingText(
          utils.toInt(deviceInfo.is_modem_detected, 0) === 1 ? "Detected" : "Not detected",
        ),
        dense: false,
      });
      this._appendDescription(
        "The LTE modem is considered detected when it is properly connected, and the gateway is reachable by Android. IP address 192.168.(0/8).1 is used for this check (Default for E3372 and Alcatel modems).",
      );
      this._appendTile({
        icon: "update",
        title: "Release type",
        trailing: this._createTrailingText(String(deviceInfo.release_type || "undefined").toUpperCase()),
        dense: false,
      });
      this._appendDescription(
        "No support is provided for devices that are running pre-release (beta) software. You can switch your desired release type on https://beta.teslaandroid.com",
      );
    }

    async applyNetworkConfiguration() {
      if (!this.systemConfigCache || !this.networkPendingConfig) {
        return;
      }

      try {
        await this.apiClient.setSoftApBand(this.networkPendingConfig.bandType.band);
        await this.apiClient.setSoftApChannelWidth(this.networkPendingConfig.bandType.channelWidth);
        await this.apiClient.setSoftApChannel(this.networkPendingConfig.bandType.channel);
        await this.apiClient.setSoftApState(this.networkPendingConfig.isSoftApEnabled ? 1 : 0);
        await this.apiClient.setOfflineModeState(this.networkPendingConfig.isOfflineModeEnabled ? 1 : 0);
        await this.apiClient.setOfflineModeTelemetryState(
          this.networkPendingConfig.isOfflineModeTelemetryEnabled ? 1 : 0,
        );
        await this.apiClient.setOfflineModeTeslaFirmwareDownloads(
          this.networkPendingConfig.isOfflineModeTeslaFirmwareDownloadsEnabled ? 1 : 0,
        );

        await this._handleSystemConfigurationChanged();
        this.networkPendingConfig = this._networkPendingFromSystemConfig(this.systemConfigCache);
        this._refreshNetworkBanner();
      } catch (_error) {
        this._renderErrorState("Failed to save your new Wi-Fi configuration");
      }
    }

    _bindBannerEvents() {
      this.bannerAction.addEventListener("click", async () => {
        await this.applyNetworkConfiguration();
      });
    }

    _bindGlobalEvents() {
      if (!global.document || typeof global.document.addEventListener !== "function") {
        return;
      }

      global.document.addEventListener("pointerdown", (event) => {
        this._handleDocumentPointerDown(event);
      });
      global.document.addEventListener("keydown", (event) => {
        this._handleDocumentKeyDown(event);
      });
    }

    _handleDocumentPointerDown(event) {
      if (!this._activeDropdown) {
        return;
      }
      if (this._activeDropdown.contains(event.target)) {
        return;
      }
      this._setActiveDropdown(null);
    }

    _handleDocumentKeyDown(event) {
      if (!this._activeDropdown) {
        return;
      }
      if (event.key === "Escape") {
        this._setActiveDropdown(null);
      }
    }

    _setActiveDropdown(dropdown) {
      if (this._activeDropdown && this._activeDropdown !== dropdown) {
        this._activeDropdown.classList.remove("open");
        const previousTrigger = this._activeDropdown.querySelector(".settings-dropdown-trigger");
        if (previousTrigger) {
          previousTrigger.setAttribute("aria-expanded", "false");
        }
      }

      if (!dropdown) {
        this._activeDropdown = null;
        return;
      }

      if (this._activeDropdown === dropdown) {
        return;
      }

      dropdown.classList.add("open");
      const trigger = dropdown.querySelector(".settings-dropdown-trigger");
      if (trigger) {
        trigger.setAttribute("aria-expanded", "true");
      }
      this._activeDropdown = dropdown;
    }

    _renderSidebar() {
      this.sidebar.innerHTML = "";

      for (let index = 0; index < this.sections.length; index += 1) {
        const section = this.sections[index];
        const button = utils.createElement("button", "settings-menu-item", null);
        button.type = "button";
        if (section.id === this.activeSectionId) {
          button.classList.add("active");
        }

        const icon = utils.createElement(
          "span",
          "material-symbols-rounded settings-menu-icon",
          this._iconName(section.icon),
        );
        const label = utils.createElement("span", "settings-menu-label", section.title);

        button.appendChild(icon);
        button.appendChild(label);
        button.addEventListener("click", async () => {
          await this.setActiveSection(section.id);
        });
        this.sidebar.appendChild(button);
      }
    }

    async _updateDisplayConfig(mutator, showRebootBanner) {
      const shouldShowRebootBanner = showRebootBanner !== false;

      try {
        const config = this._normalizeDisplayState(await this.apiClient.fetchDisplayState());
        const draft = { ...config };
        mutator(draft);
        await this.apiClient.postDisplayState(draft);
        if (shouldShowRebootBanner) {
          global.alert(
            "Display configuration has been updated. Please restart the device in case of any issues.",
          );
        }
        this.displayController.triggerResizeFromViewport();
      } catch (_error) {
        this._renderErrorState("Service error");
      }
    }

    _normalizeDisplayState(raw) {
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

    _networkPendingFromSystemConfig(config) {
      return {
        bandType: utils.mapSoftApBandFromConfig(config),
        isSoftApEnabled:
          utils.toInt(config["persist.tesla-android.softap.is_enabled"], 1) === 1,
        isOfflineModeEnabled:
          utils.toInt(config["persist.tesla-android.offline-mode.is_enabled"], 0) === 1,
        isOfflineModeTelemetryEnabled:
          utils.toInt(config["persist.tesla-android.offline-mode.telemetry.is_enabled"], 0) === 1,
        isOfflineModeTeslaFirmwareDownloadsEnabled:
          utils.toInt(
            config["persist.tesla-android.offline-mode.tesla-firmware-downloads"],
            0,
          ) === 1,
      };
    }

    _bandByKey(key) {
      for (let index = 0; index < constants.SOFT_AP_BANDS.length; index += 1) {
        if (constants.SOFT_AP_BANDS[index].key === key) {
          return constants.SOFT_AP_BANDS[index];
        }
      }
      return null;
    }

    _isNetworkPendingChanged() {
      if (!this.systemConfigCache || !this.networkPendingConfig) {
        return false;
      }
      const original = this._networkPendingFromSystemConfig(this.systemConfigCache);
      const pending = this.networkPendingConfig;

      return (
        original.bandType.key !== pending.bandType.key ||
        original.isSoftApEnabled !== pending.isSoftApEnabled ||
        original.isOfflineModeEnabled !== pending.isOfflineModeEnabled ||
        original.isOfflineModeTelemetryEnabled !== pending.isOfflineModeTelemetryEnabled ||
        original.isOfflineModeTeslaFirmwareDownloadsEnabled !==
          pending.isOfflineModeTeslaFirmwareDownloadsEnabled
      );
    }

    _refreshNetworkBanner() {
      const visible = this.activeSectionId === "network" && this._isNetworkPendingChanged();
      this.banner.hidden = !visible;
      this.bannerText.textContent =
        "System configuration has been updated. Apply it during the next system startup?";
    }

    async _handleSystemConfigurationChanged() {
      this.systemConfigCache = await this.apiClient.fetchSystemConfiguration();
      this.networkPendingConfig = null;
      if (typeof this.onSystemConfigurationChanged === "function") {
        this.onSystemConfigurationChanged(this.systemConfigCache);
      }
    }

    async _fetchSystemConfigurationSafe() {
      try {
        this.systemConfigCache = await this.apiClient.fetchSystemConfiguration();
        return this.systemConfigCache;
      } catch (_error) {
        return null;
      }
    }

    _appendTile(options) {
      const dense = options.dense !== false;
      const tile = utils.createElement(
        "div",
        dense ? "settings-tile settings-tile-dense" : "settings-tile settings-tile-wide",
        null,
      );

      const leading = utils.createElement("div", "settings-tile-leading", null);
      const leadingIcon = utils.createElement(
        "span",
        "material-symbols-rounded settings-tile-icon",
        this._iconName(options.icon || ""),
      );
      leading.appendChild(leadingIcon);
      const content = utils.createElement("div", "settings-tile-content", null);
      const title = utils.createElement("div", "settings-tile-title", options.title || "");
      content.appendChild(title);
      if (options.subtitle) {
        content.appendChild(utils.createElement("div", "settings-tile-subtitle", options.subtitle));
      }

      const trailing = utils.createElement("div", "settings-tile-trailing", null);
      if (options.trailing) {
        trailing.appendChild(options.trailing);
      }

      tile.appendChild(leading);
      tile.appendChild(content);
      tile.appendChild(trailing);
      this.content.appendChild(tile);
    }

    _appendDescription(text) {
      const description = utils.createElement("p", "settings-description", text);
      this.content.appendChild(description);
    }

    _appendDivider() {
      this.content.appendChild(utils.createElement("hr", "settings-divider", null));
    }

    _appendLoadingState() {
      this.content.innerHTML = "";
      this.content.appendChild(utils.createElement("div", "settings-loading", "Loading..."));
    }

    _renderErrorState(message) {
      this.content.innerHTML = "";
      this.content.appendChild(utils.createElement("div", "settings-error", message));
    }

    _createSelect(options, value, onChange) {
      const selectedOption = this._findOptionByValue(options, value);

      const root = utils.createElement("div", "settings-dropdown", null);
      const trigger = utils.createElement("button", "settings-dropdown-trigger", null);
      trigger.type = "button";
      trigger.setAttribute("aria-haspopup", "listbox");
      trigger.setAttribute("aria-expanded", "false");

      const valueLabel = utils.createElement(
        "span",
        "settings-dropdown-value",
        selectedOption ? selectedOption.label : "",
      );
      const arrow = utils.createElement(
        "span",
        "material-symbols-rounded settings-dropdown-arrow",
        this._iconName("arrow_drop_down"),
      );
      trigger.appendChild(valueLabel);
      trigger.appendChild(arrow);

      const menu = utils.createElement("div", "settings-dropdown-menu", null);
      menu.setAttribute("role", "listbox");

      for (let index = 0; index < options.length; index += 1) {
        const option = options[index];
        const item = utils.createElement(
          "button",
          "settings-dropdown-option",
          String(option.label),
        );
        item.type = "button";
        item.dataset.value = String(option.value);
        if (String(option.value) === String(value)) {
          item.classList.add("active");
        }

        item.addEventListener("click", async () => {
          if (trigger.disabled) {
            return;
          }
          this._setActiveDropdown(null);
          root.classList.add("is-busy");
          trigger.disabled = true;
          try {
            await onChange(item.dataset.value || "");
            if (this.activeSectionId) {
              await this._renderActiveSection();
            }
          } finally {
            trigger.disabled = false;
            root.classList.remove("is-busy");
          }
        });

        menu.appendChild(item);
      }

      trigger.addEventListener("click", () => {
        if (this._activeDropdown === root) {
          this._setActiveDropdown(null);
          return;
        }
        this._setActiveDropdown(root);
      });

      root.appendChild(trigger);
      root.appendChild(menu);
      return root;
    }

    _createSwitch(value, onChange) {
      const label = utils.createElement("label", "settings-switch", null);
      const input = document.createElement("input");
      input.type = "checkbox";
      input.checked = Boolean(value);
      const slider = utils.createElement("span", "settings-switch-slider", null);

      input.addEventListener("change", async () => {
        input.disabled = true;
        try {
          await onChange(Boolean(input.checked));
        } finally {
          input.disabled = false;
        }
      });

      label.appendChild(input);
      label.appendChild(slider);
      return label;
    }

    _createTrailingText(text) {
      return utils.createElement("span", "settings-trailing-text", text);
    }

    _findOptionByValue(options, value) {
      for (let index = 0; index < options.length; index += 1) {
        if (String(options[index].value) === String(value)) {
          return options[index];
        }
      }
      return options.length > 0 ? options[0] : null;
    }

    _iconName(iconName) {
      const source = String(iconName || "");
      switch (source) {
        case "monitor":
          return "desktop_windows";
        case "speaker":
          return "volume_up";
        case "developer_board":
          return "memory";
        case "display_settings":
          return "settings_overscan";
        case "photo_size_select_actual_outlined":
          return "photo_size_select_actual";
        case "photo_size_select_large":
          return "aspect_ratio";
        case "screenshot_monitor":
          return "desktop_windows";
        case "wifi_channel":
          return "wifi";
        case "data_thresholding_sharp":
          return "data_usage";
        case "device_thermostat":
          return "thermostat";
        case "developer_board_rounded":
          return "developer_board";
        case "broadcast_on_home_sharp":
          return "phonelink";
        case "cell_tower":
          return "network_cell";
        default:
          return source;
      }
    }
  }

  TAHtml.SettingsController = SettingsController;
})(window);
