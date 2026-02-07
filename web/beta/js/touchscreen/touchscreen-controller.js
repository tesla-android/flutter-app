(function (global) {
  "use strict";

  const TAHtml = global.TAHtml;
  const constants = TAHtml.constants;

  class TouchscreenController {
    constructor(options) {
      this.touchLayer = options.touchLayer;
      this.socketUrl = options.socketUrl;
      this.getTouchscreenSize = options.getTouchscreenSize;

      this.touchScreenSocket = null;
      this.slots = this._createSlots();
      this._handlersWired = false;
      this._isRestarting = false;
    }

    initialize() {
      this._wirePointerHandlers();
      this._connectSocket();

      global.sendTouchScreenCommand = (command) => {
        this.sendTouchScreenCommand(command);
      };
    }

    restartSocket() {
      if (this._isRestarting) {
        return;
      }
      this._isRestarting = true;

      this._resetTouchscreen();
      this._resetLocalSlots();
      this._closeSocket();
      this._connectSocket();

      this._isRestarting = false;
    }

    resetTouchscreen() {
      this._resetLocalSlots();
      this._resetTouchscreen();
    }

    sendTouchScreenCommand(command) {
      const payload = String(command || "").replace(/^touchScreenCommand:/, "");
      if (!payload) {
        return;
      }
      this._sendRaw(payload);
    }

    _connectSocket() {
      if (this.touchScreenSocket) {
        return;
      }

      const socket = new ReconnectingWebSocket(this.socketUrl);

      socket.onopen = () => {
        this._resetLocalSlots();
        this._resetTouchscreen();
      };
      socket.onclose = () => {
        this._resetLocalSlots();
      };
      socket.onerror = (error) => {
        TAHtml.log("Touchscreen websocket error: " + String(error));
      };

      this.touchScreenSocket = socket;
    }

    _closeSocket() {
      if (!this.touchScreenSocket) {
        return;
      }
      try {
        this.touchScreenSocket.close();
      } catch (_error) {
        // no-op
      }
      this.touchScreenSocket = null;
    }

    _wirePointerHandlers() {
      if (this._handlersWired || !this.touchLayer) {
        return;
      }
      this._handlersWired = true;

      this.touchLayer.addEventListener(
        "pointerdown",
        (event) => {
          event.preventDefault();
          if (!this._isSocketOpen()) {
            return;
          }

          const slot = this._getFirstUnusedSlot();
          if (!slot) {
            return;
          }

          const scaledPosition = this._scalePointerPosition(event);
          slot.trackingId = event.pointerId;
          slot.position = scaledPosition;

          try {
            this.touchLayer.setPointerCapture(event.pointerId);
          } catch (_error) {
            // no-op
          }

          this._sendCommand({
            absMtSlot: slot.slotIndex,
            absMtTrackingId: slot.trackingId,
            absMtPositionX: scaledPosition.x,
            absMtPositionY: scaledPosition.y,
            synReport: true,
          });
        },
        { passive: false },
      );

      this.touchLayer.addEventListener(
        "pointermove",
        (event) => {
          event.preventDefault();
          if (!this._isSocketOpen()) {
            return;
          }

          const slot = this._getSlotByTrackingId(event.pointerId);
          if (!slot) {
            return;
          }

          const scaledPosition = this._scalePointerPosition(event);
          slot.position = scaledPosition;

          this._sendCommand({
            absMtSlot: slot.slotIndex,
            absMtPositionX: scaledPosition.x,
            absMtPositionY: scaledPosition.y,
            synReport: true,
          });
        },
        { passive: false },
      );

      const onPointerUpOrCancel = (event) => {
        event.preventDefault();

        if (!this._isSocketOpen()) {
          this._resetLocalSlots();
          return;
        }

        const slot = this._getSlotByTrackingId(event.pointerId);
        if (!slot) {
          return;
        }

        slot.trackingId = -1;

        try {
          this.touchLayer.releasePointerCapture(event.pointerId);
        } catch (_error) {
          // no-op
        }

        this._sendCommand({
          absMtSlot: slot.slotIndex,
          absMtTrackingId: -1,
          synReport: true,
        });
      };

      this.touchLayer.addEventListener("pointerup", onPointerUpOrCancel, {
        passive: false,
      });
      this.touchLayer.addEventListener("pointercancel", onPointerUpOrCancel, {
        passive: false,
      });
      this.touchLayer.addEventListener(
        "pointerleave",
        () => {
          this.resetTouchscreen();
        },
        { passive: true },
      );
    }

    _createSlots() {
      return Array.from({ length: constants.TOUCH_SLOT_COUNT }, (_, index) => ({
        slotIndex: index,
        trackingId: -1,
        position: { x: 0, y: 0 },
      }));
    }

    _getFirstUnusedSlot() {
      const shuffled = this.slots.slice();
      shuffled.sort(() => Math.random() - 0.5);

      for (let index = 0; index < shuffled.length; index += 1) {
        const candidate = shuffled[index];
        if (candidate.trackingId === -1) {
          return candidate;
        }
      }
      return null;
    }

    _getSlotByTrackingId(trackingId) {
      for (let index = 0; index < this.slots.length; index += 1) {
        const slot = this.slots[index];
        if (slot.trackingId === trackingId) {
          return slot;
        }
      }
      return null;
    }

    _scalePointerPosition(event) {
      const rect = this.touchLayer.getBoundingClientRect();
      const localX = event.clientX - rect.left;
      const localY = event.clientY - rect.top;

      const touchscreenSize = this.getTouchscreenSize();
      const scaleX = touchscreenSize.width / Math.max(1, rect.width);
      const scaleY = touchscreenSize.height / Math.max(1, rect.height);

      let x = Math.floor(localX * scaleX);
      let y = Math.floor(localY * scaleY);

      if (x < 0) x = 0;
      if (y < 0) y = 0;

      return { x, y };
    }

    _resetLocalSlots() {
      for (let index = 0; index < this.slots.length; index += 1) {
        const pointerId = this.slots[index].trackingId;
        if (pointerId !== -1 && this.touchLayer) {
          try {
            this.touchLayer.releasePointerCapture(pointerId);
          } catch (_error) {
            // no-op
          }
        }
        this.slots[index].trackingId = -1;
      }
    }

    _resetTouchscreen() {
      const commands = this.slots.map((slot) => {
        slot.trackingId = -1;
        return {
          absMtSlot: slot.slotIndex,
          absMtTrackingId: -1,
        };
      });

      this._sendCommands(commands);
    }

    _sendCommands(commands) {
      const all = commands.slice();
      all.push({ synReport: true });

      let payload = "";
      for (let index = 0; index < all.length; index += 1) {
        payload += this._buildTouchCommand(all[index]);
      }

      this._sendRaw(payload);
    }

    _sendCommand(command) {
      this._sendRaw(this._buildTouchCommand(command));
    }

    _isSocketOpen() {
      return Boolean(this.touchScreenSocket && this.touchScreenSocket.readyState === 1);
    }

    _sendRaw(payload) {
      if (!this._isSocketOpen()) {
        return;
      }
      this.touchScreenSocket.send(payload);
    }

    _buildTouchCommand(command) {
      let payload = "";

      if (command.absMtSlot !== undefined && command.absMtSlot !== null) {
        payload += "s " + String(command.absMtSlot) + "\n";
      }

      if (command.absMtTrackingId !== undefined && command.absMtTrackingId !== null) {
        payload += "T " + String(command.absMtTrackingId) + "\n";
        payload += command.absMtTrackingId === -1 ? "a 0\n" : "a 1\n";
      }

      if (command.absMtPositionX !== undefined && command.absMtPositionX !== null) {
        payload += "X " + String(command.absMtPositionX) + "\n";
      }

      if (command.absMtPositionY !== undefined && command.absMtPositionY !== null) {
        payload += "Y " + String(command.absMtPositionY) + "\n";
      }

      if (command.synReport) {
        payload += "e 0\nS 0\n";
      }

      return payload;
    }
  }

  TAHtml.TouchscreenController = TouchscreenController;
})(window);
