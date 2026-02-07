(function (global) {
  "use strict";

  const TAHtml = global.TAHtml;

  class ShellController {
    constructor(options) {
      this.apiClient = options.apiClient;
      this.displayController = options.displayController;
      this.settingsController = options.settingsController;
      this.releaseNotesController = options.releaseNotesController;

      this.homeShell = options.homeShell;
      this.panelShell = options.panelShell;
      this.panelViews = options.panelViews;
      this.appTitle = options.appTitle;
      this.navButtons = options.navButtons;
      this.connectivityBanner = options.connectivityBanner;
      this.connectivityBannerText = options.connectivityBannerText || null;

      this.currentPage = "home";
      this.connectivityState = "backendAccessible";
      this._timersStarted = false;
      this._connectivityCheckInFlight = false;
      this._requestedConnectivityTimerId = null;
      this._connectivityMessage =
        "Connection with Tesla Android services lost. The app will restart when it comes back.";

      this.pageTitles = {
        about: "About",
        releaseNotes: "Release Notes",
        donations: "Donations",
        settings: "Settings",
      };
    }

    initialize() {
      this._wireNav();
      this.setPage("home");
      this._startConnectivityObservers();
    }

    requestConnectivityCheck(_reason) {
      if (this._requestedConnectivityTimerId !== null) {
        global.clearTimeout(this._requestedConnectivityTimerId);
      }

      this._requestedConnectivityTimerId = global.setTimeout(() => {
        this._requestedConnectivityTimerId = null;
        void this._checkConnectivity();
      }, 120);
    }

    setPage(pageId) {
      this.currentPage = pageId;
      const isHome = pageId === "home";

      this.homeShell.hidden = !isHome;
      this.panelShell.hidden = isHome;
      this.displayController.setPaused(!isHome);

      this._renderNavSelection(pageId);

      if (isHome) {
        return;
      }

      this.appTitle.textContent = this.pageTitles[pageId] || "";

      this._hideAllPanelViews();
      if (pageId === "about") {
        this.panelViews.about.hidden = false;
      } else if (pageId === "releaseNotes") {
        this.panelViews.releaseNotes.hidden = false;
        this.releaseNotesController.render();
      } else if (pageId === "donations") {
        this.panelViews.donations.hidden = false;
      } else if (pageId === "settings") {
        this.panelViews.settings.hidden = false;
        void this.settingsController.setActiveSection(this.settingsController.activeSectionId);
      }
    }

    _wireNav() {
      for (let index = 0; index < this.navButtons.length; index += 1) {
        const button = this.navButtons[index];
        button.addEventListener("click", () => {
          const targetPage = button.getAttribute("data-page");
          if (targetPage) {
            this.setPage(targetPage);
          }
        });
      }
    }

    _renderNavSelection(pageId) {
      for (let index = 0; index < this.navButtons.length; index += 1) {
        const button = this.navButtons[index];
        const targetPage = button.getAttribute("data-page");
        if (targetPage === pageId) {
          button.classList.add("active");
        } else {
          button.classList.remove("active");
        }
      }
    }

    _hideAllPanelViews() {
      this.panelViews.about.hidden = true;
      this.panelViews.releaseNotes.hidden = true;
      this.panelViews.donations.hidden = true;
      this.panelViews.settings.hidden = true;
    }

    _startConnectivityObservers() {
      if (this._timersStarted) {
        return;
      }
      this._timersStarted = true;

      this.requestConnectivityCheck("startup");

      global.setInterval(() => {
        if (this.connectivityState === "backendAccessible") {
          this.requestConnectivityCheck("periodic_online");
        }
      }, 30000);

      global.setInterval(() => {
        if (this.connectivityState !== "backendAccessible") {
          this.requestConnectivityCheck("periodic_offline");
        }
      }, 5000);
    }

    async _checkConnectivity() {
      if (this._connectivityCheckInFlight) {
        return;
      }

      this._connectivityCheckInFlight = true;
      try {
        await this.apiClient.fetchHealthCheck();
        this._onConnectivitySuccess();
      } catch (_error) {
        this._onConnectivityFailure();
      } finally {
        this._connectivityCheckInFlight = false;
      }
    }

    _onConnectivityFailure() {
      this.connectivityState = "backendUnreachable";
      this.connectivityBanner.hidden = false;
      if (this.connectivityBannerText) {
        this.connectivityBannerText.textContent = this._connectivityMessage;
      } else {
        this.connectivityBanner.textContent = this._connectivityMessage;
      }
    }

    _onConnectivitySuccess() {
      if (this.connectivityState === "backendUnreachable") {
        global.location.reload();
      }
      this.connectivityState = "backendAccessible";
      this.connectivityBanner.hidden = true;
    }
  }

  TAHtml.ShellController = ShellController;
})(window);
