(function (global) {
  "use strict";

  const TAHtml = global.TAHtml;
  const utils = TAHtml.utils;

  class ReleaseNotesController {
    constructor(options) {
      this.versionsContainer = options.versionsContainer;
      this.detailsContainer = options.detailsContainer;

      this.releaseNotes = TAHtml.releaseNotesData;
      this.selectedVersion = this.releaseNotes.versions[0];
      this.selectedItem = this.selectedVersion.changelogItems[0];
    }

    render() {
      this._renderVersions();
      this._renderDetails();
    }

    _renderVersions() {
      this.versionsContainer.innerHTML = "";

      const versions = this.releaseNotes.versions;
      for (let versionIndex = 0; versionIndex < versions.length; versionIndex += 1) {
        const version = versions[versionIndex];

        const versionTitle = utils.createElement(
          "div",
          "release-version-title",
          version.versionName,
        );
        this.versionsContainer.appendChild(versionTitle);

        for (let itemIndex = 0; itemIndex < version.changelogItems.length; itemIndex += 1) {
          const item = version.changelogItems[itemIndex];
          const card = utils.createElement("button", "release-card", null);
          card.type = "button";
          if (item === this.selectedItem) {
            card.classList.add("active");
          }

          const cardTitle = utils.createElement("div", "release-card-title", item.title);
          const cardSubtitle = utils.createElement(
            "div",
            "release-card-subtitle",
            item.shortDescription,
          );

          card.appendChild(cardTitle);
          card.appendChild(cardSubtitle);

          card.addEventListener("click", () => {
            this.selectedVersion = version;
            this.selectedItem = item;
            this.render();
          });

          this.versionsContainer.appendChild(card);
        }
      }
    }

    _renderDetails() {
      this.detailsContainer.innerHTML = "";
      const detailsText = utils.createElement(
        "div",
        "release-details-text",
        this.selectedItem.descriptionMarkdown,
      );
      this.detailsContainer.appendChild(detailsText);
    }
  }

  TAHtml.ReleaseNotesController = ReleaseNotesController;
})(window);
