(function (global) {
  "use strict";

  const TAHtml = global.TAHtml;

  class ApiClient {
    constructor(apiBaseUrl) {
      this.apiBaseUrl = String(apiBaseUrl || "").replace(/\/$/, "");
      this.githubApiBaseUrl = "https://api.github.com";
    }

    fetchSystemConfiguration() {
      return this._fetchJson(this.apiBaseUrl + "/configuration");
    }

    fetchDisplayState() {
      return this._fetchJson(this.apiBaseUrl + "/displayState");
    }

    postDisplayState(payload) {
      return this._postJson(this.apiBaseUrl + "/displayState", payload);
    }

    fetchDeviceInfo() {
      return this._fetchJson(this.apiBaseUrl + "/deviceInfo");
    }

    openUpdater() {
      return this._fetch(this.apiBaseUrl + "/openUpdater");
    }

    fetchHealthCheck() {
      return this._fetch(this.apiBaseUrl + "/health");
    }

    fetchLatestRelease() {
      return this._fetchJson(
        this.githubApiBaseUrl + "/repos/tesla-android/android-raspberry-pi/releases/latest",
        {
          headers: {
            "X-GitHub-Api-Version": "2022-11-28",
          },
        },
      );
    }

    setSoftApBand(value) {
      return this._postPlain(this.apiBaseUrl + "/softApBand", value);
    }

    setSoftApChannel(value) {
      return this._postPlain(this.apiBaseUrl + "/softApChannel", value);
    }

    setSoftApChannelWidth(value) {
      return this._postPlain(this.apiBaseUrl + "/softApChannelWidth", value);
    }

    setSoftApState(value) {
      return this._postPlain(this.apiBaseUrl + "/softApState", value);
    }

    setOfflineModeState(value) {
      return this._postPlain(this.apiBaseUrl + "/offlineModeState", value);
    }

    setOfflineModeTelemetryState(value) {
      return this._postPlain(this.apiBaseUrl + "/offlineModeTelemetryState", value);
    }

    setOfflineModeTeslaFirmwareDownloads(value) {
      return this._postPlain(this.apiBaseUrl + "/offlineModeTeslaFirmwareDownloads", value);
    }

    setBrowserAudioState(value) {
      return this._postPlain(this.apiBaseUrl + "/browserAudioState", value);
    }

    setBrowserAudioVolume(value) {
      return this._postPlain(this.apiBaseUrl + "/browserAudioVolume", value);
    }

    setGpsState(value) {
      return this._postPlain(this.apiBaseUrl + "/gpsState", value);
    }

    async _fetch(url, options) {
      const response = await fetch(url, {
        cache: "no-store",
        credentials: "same-origin",
        ...(options || {}),
      });
      if (!response.ok) {
        throw new Error("HTTP " + response.status + " for " + url);
      }
      return response;
    }

    async _fetchJson(url, options) {
      const response = await this._fetch(url, options);
      return response.json();
    }

    async _postJson(url, payload) {
      await this._fetch(url, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(payload),
      });
    }

    async _postPlain(url, value) {
      await this._fetch(url, {
        method: "POST",
        headers: {
          "Content-Type": "text/plain",
        },
        body: String(value),
      });
    }
  }

  TAHtml.ApiClient = ApiClient;
})(window);
