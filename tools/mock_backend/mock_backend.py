#!/usr/bin/env python3
"""
Tesla Android Mock Backend with Raw WebSocket Support

Uses aiohttp for REST API and raw WebSocket connections (not Socket.IO).
This matches the protocol expected by reconnecting-websocket.js.

Requirements:
    pip install aiohttp aiohttp-cors websockets

Usage:
    python3 mock_backend_raw_ws.py
"""

import asyncio
import json
from datetime import datetime
from aiohttp import web
import aiohttp_cors
import random

# Mock state
mock_state = {
    "display": {
        "width": 1920, "height": 1080, "density": 200,
        "resolutionPreset": 0, "renderer": 1, "isHeadless": 0,
        "isResponsive": 1, "isH264": 1, "refreshRate": 30,
        "quality": 90, "isRearDisplayEnabled": 0, "isRearDisplayPrioritised": 0,
    },
    "configuration": {
        "persist.tesla-android.softap.band_type": 1,
        "persist.tesla-android.softap.channel": 36,
        "persist.tesla-android.softap.channel_width": 80,
        "persist.tesla-android.softap.is_enabled": 1,
        "persist.tesla-android.offline-mode.is_enabled": 0,
        "persist.tesla-android.offline-mode.telemetry.is_enabled": 1,
        "persist.tesla-android.offline-mode.tesla-firmware-downloads": 1,
        "persist.tesla-android.browser_audio.is_enabled": 1,
        "persist.tesla-android.browser_audio.volume": 80,
        "persist.tesla-android.gps.is_active": 1,
    },
    "device_info": {
        "cpu_temperature": 45, "serial_number": "MOCK0000001",
        "device_model": "cm4", "is_modem_detected": 1,
        "is_carplay_detected": 0, "release_type": "stable",
        "ota_url": "https://github.com/tesla-android/android-raspberry-pi/releases",
        "is_gps_enabled": 1,
    }
}

# WebSocket connections
websocket_connections = {
    "display": set(),
    "touchscreen": set(),
    "gps": set(),
    "audio": set()
}

# ============================================================================
# REST API Handlers
# ============================================================================

async def health_check(request):
    return web.json_response({"status": "ok", "timestamp": datetime.now().isoformat()})

async def get_configuration(request):
    print("[GET] /api/configuration")
    return web.json_response(mock_state["configuration"])

async def get_display_state(request):
    print("[GET] /api/displayState")
    return web.json_response(mock_state["display"])

async def update_display_configuration(request):
    config = await request.json()
    print(f"[POST] /api/displayState")
    for key, value in config.items():
        if key in mock_state["display"]:
            mock_state["display"][key] = value
    return web.Response(status=200)

async def get_device_info(request):
    print("[GET] /api/deviceInfo")
    mock_state["device_info"]["cpu_temperature"] = random.randint(40, 55)
    return web.json_response(mock_state["device_info"])

async def open_updater(request):
    print("[GET] /api/openUpdater")
    return web.json_response({"message": "Updater opened (mock)"})

# Configuration POST handlers
async def post_handler(request, key):
    data = await request.text()
    value = int(data)
    print(f"[POST] {request.path}: {value}")
    mock_state["configuration"][key] = value
    if "gps" in key.lower():
        mock_state["device_info"]["is_gps_enabled"] = value
    return web.Response(status=200)

# ============================================================================
# WebSocket Handlers (Raw WebSocket Protocol)
# ============================================================================

async def websocket_handler(request, socket_type):
    """Handle raw WebSocket connections"""
    ws = web.WebSocketResponse()
    await ws.prepare(request)
    
    print(f"[{socket_type.title()} WebSocket] Client connected")
    websocket_connections[socket_type].add(ws)
    
    try:
        # Send welcome message
        await ws.send_str(json.dumps({
            "type": "connected",
            "socket": socket_type,
            "timestamp": datetime.now().isoformat()
        }))
        
        # Handle incoming messages
        async for msg in ws:
            if msg.type == web.WSMsgType.TEXT:
                # Just log received data for touchscreen/gps
                if socket_type in ["touchscreen", "gps"]:
                    # Don't spam logs for every touch event
                    if socket_type == "gps":
                        print(f"[{socket_type.title()}] Received: {msg.data[:100]}")
                    pass  # Silently handle for touchscreen
                    
            elif msg.type == web.WSMsgType.ERROR:
                print(f"[{socket_type.title()} WebSocket] Error: {ws.exception()}")
                
    finally:
        websocket_connections[socket_type].discard(ws)
        print(f"[{socket_type.title()} WebSocket] Client disconnected")
    
    return ws

async def display_websocket(request):
    return await websocket_handler(request, "display")

async def touchscreen_websocket(request):
    return await websocket_handler(request, "touchscreen")

async def gps_websocket(request):
    return await websocket_handler(request, "gps")

async def audio_websocket(request):
    return await websocket_handler(request, "audio")

# ============================================================================
# Debug Handlers
# ============================================================================

async def debug_state(request):
    return web.json_response(mock_state)

async def debug_websockets(request):
    return web.json_response({
        "connections": {
            socket_type: len(sids) 
            for socket_type, sids in websocket_connections.items()
        }
    })

async def debug_reset(request):
    global mock_state
    mock_state = {
        "display": {
            "width": 1920, "height": 1080, "density": 200,
            "resolutionPreset": 0, "renderer": 1, "isHeadless": 0,
            "isResponsive": 1, "isH264": 1, "refreshRate": 30,
            "quality": 90, "isRearDisplayEnabled": 0, "isRearDisplayPrioritised": 0,
        },
        "configuration": {
            "persist.tesla-android.softap.band_type": 1,
            "persist.tesla-android.softap.channel": 36,
            "persist.tesla-android.softap.channel_width": 80,
            "persist.tesla-android.softap.is_enabled": 1,
            "persist.tesla-android.offline-mode.is_enabled": 0,
            "persist.tesla-android.offline-mode.telemetry.is_enabled": 1,
            "persist.tesla-android.offline-mode.tesla-firmware-downloads": 1,
            "persist.tesla-android.browser_audio.is_enabled": 1,
            "persist.tesla-android.browser_audio.volume": 80,
            "persist.tesla-android.gps.is_active": 1,
        },
        "device_info": {
            "cpu_temperature": 45, "serial_number": "MOCK0000001",
            "device_model": "cm4", "is_modem_detected": 1,
            "is_carplay_detected": 0, "release_type": "stable",
            "ota_url": "https://github.com/tesla-android/android-raspberry-pi/releases",
            "is_gps_enabled": 1,
        }
    }
    return web.json_response({"message": "State reset to defaults"})

# ============================================================================
# Application Setup
# ============================================================================

async def create_app():
    app = web.Application()
    
    # Configure CORS
    cors = aiohttp_cors.setup(app, defaults={
        "*": aiohttp_cors.ResourceOptions(
            allow_credentials=True,
            expose_headers="*",
            allow_headers="*",
        )
    })
    
    # REST API routes
    app.router.add_get('/api/health', health_check)
    app.router.add_get('/api/configuration', get_configuration)
    app.router.add_get('/api/displayState', get_display_state)
    app.router.add_post('/api/displayState', update_display_configuration)
    app.router.add_get('/api/deviceInfo', get_device_info)
    app.router.add_get('/api/openUpdater', open_updater)
    
    # Configuration POST routes
    app.router.add_post('/api/softApBand', 
                        lambda r: post_handler(r, "persist.tesla-android.softap.band_type"))
    app.router.add_post('/api/softApChannel',
                        lambda r: post_handler(r, "persist.tesla-android.softap.channel"))
    app.router.add_post('/api/softApChannelWidth',
                        lambda r: post_handler(r, "persist.tesla-android.softap.channel_width"))
    app.router.add_post('/api/softApState',
                        lambda r: post_handler(r, "persist.tesla-android.softap.is_enabled"))
    app.router.add_post('/api/offlineModeState',
                        lambda r: post_handler(r, "persist.tesla-android.offline-mode.is_enabled"))
    app.router.add_post('/api/offlineModeTelemetryState',
                        lambda r: post_handler(r, "persist.tesla-android.offline-mode.telemetry.is_enabled"))
    app.router.add_post('/api/offlineModeTeslaFirmwareDownloads',
                        lambda r: post_handler(r, "persist.tesla-android.offline-mode.tesla-firmware-downloads"))
    app.router.add_post('/api/browserAudioState',
                        lambda r: post_handler(r, "persist.tesla-android.browser_audio.is_enabled"))
    app.router.add_post('/api/browserAudioVolume',
                        lambda r: post_handler(r, "persist.tesla-android.browser_audio.volume"))
    app.router.add_post('/api/gpsState',
                        lambda r: post_handler(r, "persist.tesla-android.gps.is_active"))
    
    # WebSocket routes
    app.router.add_get('/sockets/display', display_websocket)
    app.router.add_get('/sockets/touchscreen', touchscreen_websocket)
    app.router.add_get('/sockets/gps', gps_websocket)
    app.router.add_get('/sockets/audio', audio_websocket)
    
    # Debug routes
    app.router.add_get('/api/debug/state', debug_state)
    app.router.add_get('/api/debug/websockets', debug_websockets)
    app.router.add_post('/api/debug/reset', debug_reset)
    
    # Configure CORS for all routes
    for route in list(app.router.routes()):
        if not isinstance(route.resource, web.StaticResource):
            cors.add(route)
    
    return app

# ============================================================================
# Main
# ============================================================================

if __name__ == '__main__':
    print("=" * 70)
    print("Tesla Android Mock Backend - Raw WebSocket Support")
    print("=" * 70)
    print("\nServer starting on http://localhost:3000")
    print("\nRaw WebSocket Endpoints:")
    print("  ws://localhost:3000/sockets/display")
    print("  ws://localhost:3000/sockets/touchscreen")
    print("  ws://localhost:3000/sockets/gps")
    print("  ws://localhost:3000/sockets/audio")
    print("\nREST API Endpoints:")
    print("  GET  /api/health")
    print("  GET  /api/configuration")
    print("  GET  /api/displayState")
    print("  POST /api/displayState")
    print("  GET  /api/deviceInfo")
    print("  GET  /api/debug/state")
    print("  GET  /api/debug/websockets")
    print("  POST /api/debug/reset")
    print("=" * 70)
    print()
    
    web.run_app(create_app(), host='0.0.0.0', port=3000)
