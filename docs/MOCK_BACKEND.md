# Mock Backend for Local Development

Enables testing Tesla Android Flutter app without hardware by simulating the backend API and WebSocket connections.

## Quick Start

### 1. Install Dependencies
```bash
pip3 install aiohttp aiohttp-cors
```

### 2. Start Mock Server
```bash
python3 tools/mock_backend/mock_backend.py
```

Server runs on `http://localhost:3000`

### 3. Run App in Mock Mode
```
http://localhost:8080?mock=true
```

The `?mock=true` URL parameter automatically configures the app to use the mock backend.

**Visual Indicators**:
- 🟠 **Orange** = Mock mode
- 🟢 **Green** = Dev mode (real backend)
- 🔴 **Red** = Production mode

---

## What's Mocked

### ✅ REST API Endpoints
| Endpoint | Methods | Description |
|----------|---------|-------------|
| `/api/health` | GET | Health checks |
| `/api/configuration` | GET/POST | System configuration |
| `/api/displayState` | GET/POST | Display settings |
| `/api/deviceInfo` | GET | Device info (temp, model) |
| `/api/softApBand` | POST | Wi-Fi band |
| `/api/softApChannel` | POST | Wi-Fi channel |
| `/api/browserAudioState` | POST | Audio enable/disable |
| `/api/browserAudioVolume` | POST | Audio volume (0-100) |
| `/api/gpsState` | POST | GPS enable/disable |

### ✅ WebSocket Endpoints
- `/sockets/display` - Display streaming
- `/sockets/touchscreen` - Touch input
- `/sockets/gps` - GPS data
- `/sockets/audio` - Audio streaming

### ✅ Debug Endpoints
- `GET /api/debug/state` - View current mock state
- `GET /api/debug/websockets` - Active connections
- `POST /api/debug/reset` - Reset to defaults

---

## Testing Workflow

### 1. Start Mock Backend
```bash
python3 tools/mock_backend/mock_backend.py
```

Expected output:
```
======================================================================
Tesla Android Mock Backend - Raw WebSocket Support
======================================================================

Server starting on http://localhost:3000

Raw WebSocket Endpoints:
  ws://localhost:3000/sockets/display
  ws://localhost:3000/sockets/touchscreen
  ws://localhost:3000/sockets/gps
  ws://localhost:3000/sockets/audio
...
```

### 2. Open App with Mock Parameter
```
http://localhost:8080?mock=true
```

### 3. Verify Connections
Check mock backend terminal for:
```
[Display WebSocket] Client connected
[Touchscreen WebSocket] Client connected
[GPS WebSocket] Client connected
[Audio WebSocket] Client connected
[GET] /api/health
[GET] /api/configuration
[GET] /api/displayState
[GET] /api/deviceInfo
```

### 4. Test Features
- Navigate to settings
- Toggle GPS, audio settings
- Change display configuration
- Check device info
- Interact with touchscreen

All changes are logged in the mock backend terminal.

---

## Mock State

The server maintains in-memory state (resets on restart):

**Display**: 1920x1080, h264, 30Hz, quality 90  
**Configuration**: Wi-Fi enabled, GPS active, audio enabled  
**Device**: CM4, ~45°C CPU temp, serial "MOCK0000001"

View current state: `GET http://localhost:3000/api/debug/state`

---

## Backend File

**Use**: `tools/mock_backend/mock_backend.py` (aiohttp-based with raw WebSocket protocol)

---

## Troubleshooting

### Connection Refused
- ✅ Mock backend running on port 3000
- ✅ URL includes `?mock=true`
- ✅ No firewall blocking port 3000

### Still Shows "Connection Lost"
1. Open Chrome DevTools → Network tab
2. Look for requests to `localhost:3000/api/health`
3. If missing, try hot **restart** (R) not hot reload (r)

### WebSocket 404 Errors
- ✅ Ensure using `tools/mock_backend/mock_backend.py`
- ✅ Check terminal shows WebSocket connections

### Settings Don't Update
1. Check mock terminal shows POST requests
2. Try toggling setting off/on
3. Hot restart app

---

## Production Mode

Remove `?mock=true` to connect to real Tesla Android backend:

```
http://localhost:8080
```

App automatically uses `device.teslaandroid.com` (green/red indicator).

---

## Implementation Details

### Dev Mode Guard
**File**: `lib/common/di/app_module.dart`

```dart
// Checks for ?mock=true in URL
final isMockMode = window.location.search.contains('mock=true');

if (isMockMode) {
  // Use localhost:3000
} else {
  // Use device.teslaandroid.com
}
```

**Safe to commit**: Defaults to production mode, no breaking changes.

### URL Parameter Benefits
- ✅ No code changes to toggle modes
- ✅ Explicit testing mode (`?mock=true`)
- ✅ Visual indicator (orange color)
- ✅ Production-safe default

---

## Use Cases

✅ **SDK/dependency testing** without hardware  
✅ **UI development** and iteration  
✅ **Settings testing** and validation  
✅ **API integration** testing  
✅ **New contributor onboarding**  

❌ **Display streaming validation** (mock doesn't send real video)  
❌ **Performance testing** (mock has no real load)  
❌ **Hardware-specific features** (modem, CarPlay detection)

Use real hardware for final validation.

---

## Summary

**Mock Backend**: Fully functional REST + WebSocket  
**Activation**: `?mock=true` URL parameter  
**No Hardware Required**: Test locally without Tesla Android device  
**Production Safe**: Defaults to real backend  

**Development**: `http://localhost:8080?mock=true`  
**Production**: `http://localhost:8080`
