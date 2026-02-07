(function (global) {
  "use strict";

  const TAHtml = global.TAHtml;

  document.addEventListener("DOMContentLoaded", () => {
    void bootstrap();
  });

  async function bootstrap() {
    const flavor = TAHtml.createFlavor();
    const apiClient = new TAHtml.ApiClient(flavor.apiBaseUrl);

    const elements = {
      displayRoot: document.getElementById("display-root"),
      displayLoading: document.getElementById("display-loading"),
      touchLayer: document.getElementById("touch-layer"),
      displayTypeDialog: document.getElementById("display-type-dialog"),
      displayTypeMainButton: document.getElementById("main-display-button"),
      displayTypeRearButton: document.getElementById("rear-display-button"),

      homeShell: document.getElementById("home-shell"),
      panelShell: document.getElementById("panel-shell"),
      appTitle: document.getElementById("app-title"),
      navButtons: Array.from(document.querySelectorAll(".bottom-nav-button")),
      connectivityBanner: document.getElementById("connectivity-banner"),
      connectivityBannerText: document.getElementById("connectivity-banner-text"),

      homeAudioButton: document.getElementById("home-audio-button"),
      homeUpdateButton: document.getElementById("home-update-button"),
      homeSettingsButton: document.getElementById("home-settings-button"),

      releaseVersions: document.getElementById("release-versions"),
      releaseDetails: document.getElementById("release-details"),

      settingsSidebar: document.getElementById("settings-sidebar"),
      settingsContent: document.getElementById("settings-content"),
      settingsBanner: document.getElementById("settings-banner"),
      settingsBannerText: document.getElementById("settings-banner-text"),
      settingsBannerAction: document.getElementById("settings-banner-action"),

      pageAbout: document.getElementById("page-about"),
      pageReleaseNotes: document.getElementById("page-release-notes"),
      pageDonations: document.getElementById("page-donations"),
      pageSettings: document.getElementById("page-settings"),

      appVersion: document.querySelectorAll("[data-app-version]"),
    };

    for (let index = 0; index < elements.appVersion.length; index += 1) {
      elements.appVersion[index].textContent = TAHtml.constants.APP_VERSION;
    }

    const audioController = new TAHtml.AudioController({
      audioWebsocketUrl: flavor.audioWebSocket,
    });
    audioController.initialize();

    let shellController = null;

    let hasDisplayEnteredNormalOnce = false;
    let resizeLoadingTimerId = null;
    let latestResizeMode = "initial";
    let lastDisplayFrameTimestamp = 0;
    const LOADING_VISIBILITY_DELAY_MS = 150;

    const setDisplayLoadingVisible = (visible) => {
      const shouldShow = Boolean(visible);
      if (elements.displayLoading) {
        elements.displayLoading.hidden = !shouldShow;
      }
      if (elements.displayRoot) {
        if (shouldShow) {
          elements.displayRoot.classList.add("is-loading");
        } else {
          elements.displayRoot.classList.remove("is-loading");
        }
      }
      if (elements.touchLayer) {
        elements.touchLayer.style.pointerEvents = shouldShow ? "none" : "auto";
      }
    };

    const rendererManager = new TAHtml.DisplayRendererManager({
      displayRoot: elements.displayRoot,
      onSocketOpen: () => {
        if (shellController) {
          shellController.requestConnectivityCheck("display_socket_open");
        }
      },
      onSocketClose: () => {
        if (shellController) {
          shellController.requestConnectivityCheck("display_socket_close");
        }
      },
      onSocketError: () => {
        if (shellController) {
          shellController.requestConnectivityCheck("display_socket_error");
        }
      },
      onFrameReceived: () => {
        lastDisplayFrameTimestamp = Date.now();
        if (resizeLoadingTimerId !== null) {
          global.clearTimeout(resizeLoadingTimerId);
          resizeLoadingTimerId = null;
        }
        setDisplayLoadingVisible(false);
      },
    });

    const displayController = new TAHtml.DisplayController({
      apiClient,
      rendererManager,
      flavor,
      dialog: elements.displayTypeDialog,
      dialogMainButton: elements.displayTypeMainButton,
      dialogRearButton: elements.displayTypeRearButton,
      onResizeModeChange: (mode) => {
        latestResizeMode = mode;

        if (mode === "normal") {
          hasDisplayEnteredNormalOnce = true;
        }

        const isLoadingMode = mode === "resize_cooldown" || mode === "resize_in_progress";

        if (!hasDisplayEnteredNormalOnce) {
          setDisplayLoadingVisible(false);
          return;
        }

        if (!isLoadingMode) {
          if (resizeLoadingTimerId !== null) {
            global.clearTimeout(resizeLoadingTimerId);
            resizeLoadingTimerId = null;
          }
          setDisplayLoadingVisible(false);
          return;
        }

        if (resizeLoadingTimerId === null) {
          resizeLoadingTimerId = global.setTimeout(() => {
            resizeLoadingTimerId = null;
            const stillLoading =
              latestResizeMode === "resize_cooldown" || latestResizeMode === "resize_in_progress";
            const staleFrame =
              lastDisplayFrameTimestamp === 0 ||
              Date.now() - lastDisplayFrameTimestamp > LOADING_VISIBILITY_DELAY_MS;
            if (hasDisplayEnteredNormalOnce && stillLoading && staleFrame) {
              setDisplayLoadingVisible(true);
            }
          }, LOADING_VISIBILITY_DELAY_MS);
        }
      },
    });

    let systemConfiguration = null;
    try {
      systemConfiguration = await apiClient.fetchSystemConfiguration();
    } catch (error) {
      TAHtml.log("Unable to fetch system configuration during bootstrap: " + String(error));
    }

    if (systemConfiguration) {
      audioController.applyConfiguration({
        audioWebsocketUrl: flavor.audioWebSocket,
        isAudioEnabled:
          TAHtml.utils.toInt(
            systemConfiguration["persist.tesla-android.browser_audio.is_enabled"],
            1,
          ) === 1,
        audioVolume:
          TAHtml.utils.toInt(
            systemConfiguration["persist.tesla-android.browser_audio.volume"],
            100,
          ) / 100,
      });
    }

    try {
      await displayController.initialize();
    } catch (error) {
      TAHtml.log("Unable to initialize display controller: " + String(error));
      return;
    }

    const gpsController = new TAHtml.GpsController({
      socketUrl: flavor.gpsWebSocket,
      isEnabled:
        systemConfiguration
          ? TAHtml.utils.toInt(systemConfiguration["persist.tesla-android.gps.is_active"], 1) === 1
          : true,
    });
    gpsController.initialize();

    const touchscreenController = new TAHtml.TouchscreenController({
      touchLayer: elements.touchLayer,
      socketUrl: flavor.touchscreenWebSocket,
      getTouchscreenSize: () => displayController.getTouchscreenSize(),
    });
    touchscreenController.initialize();
    displayController.setResizeSessionRefreshHandler(() => {
      touchscreenController.restartSocket();
    });

    const releaseNotesController = new TAHtml.ReleaseNotesController({
      versionsContainer: elements.releaseVersions,
      detailsContainer: elements.releaseDetails,
    });

    const homeController = new TAHtml.HomeController({
      apiClient,
      audioController,
      audioButton: elements.homeAudioButton,
      updateButton: elements.homeUpdateButton,
      settingsButton: elements.homeSettingsButton,
      onSettingsRequested: () => {
        if (shellController) {
          shellController.setPage("about");
        }
      },
    });

    const settingsController = new TAHtml.SettingsController({
      apiClient,
      displayController,
      gpsController,
      audioController,
      flavor,
      sidebar: elements.settingsSidebar,
      content: elements.settingsContent,
      banner: elements.settingsBanner,
      bannerText: elements.settingsBannerText,
      bannerAction: elements.settingsBannerAction,
      onSystemConfigurationChanged: (configuration) => {
        homeController.applySystemConfiguration(configuration);
        gpsController.setEnabled(
          TAHtml.utils.toInt(configuration["persist.tesla-android.gps.is_active"], 1) === 1,
        );
      },
    });
    await settingsController.initialize();

    shellController = new TAHtml.ShellController({
      apiClient,
      displayController,
      settingsController,
      releaseNotesController,
      homeShell: elements.homeShell,
      panelShell: elements.panelShell,
      panelViews: {
        about: elements.pageAbout,
        releaseNotes: elements.pageReleaseNotes,
        donations: elements.pageDonations,
        settings: elements.pageSettings,
      },
      appTitle: elements.appTitle,
      navButtons: elements.navButtons,
      connectivityBanner: elements.connectivityBanner,
      connectivityBannerText: elements.connectivityBannerText,
    });

    shellController.initialize();

    await homeController.initialize(systemConfiguration || {});
  }
})(window);
