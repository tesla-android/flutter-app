# Tesla Android Web Frontend (HTML + JavaScript)

This directory contains the new JavaScript-based HTML frontend for Tesla Android.

It is intended to replace the remaining Flutter-side frontend logic with a modular web implementation while preserving the existing Tesla Android backend APIs, websocket transport, and UX behavior.

## Purpose

- Provide a standalone web frontend for Tesla Android display/touchscreen/control flows.
- Keep feature parity with the Flutter frontend where possible.
- Maintain compatibility with existing backend services on `device.teslaandroid.com`.

## Tech Stack

- Plain HTML/CSS/JavaScript (no framework runtime).
- Modular feature-oriented JS structure.
- WebSocket transport for display/audio/gps/touchscreen.
- Multiple display renderers:
  - Motion JPEG
  - h264 (WebCodecs)
  - h264 (legacy Broadway)

## Backend Integration

The frontend currently targets Tesla Android production endpoints:

- API base: `https://device.teslaandroid.com/api`
- WebSockets: `wss://device.teslaandroid.com/sockets/*`

These values are defined in `js/core/shared.js`.

## Running Locally

Use an HTTP server (not `file://`) so workers, modules, and websocket behavior work correctly.

Example:

```bash
php -S 0.0.0.0:8000
```

Then open:

`http://localhost:8000/index.html`
