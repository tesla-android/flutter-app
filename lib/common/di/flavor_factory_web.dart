import 'package:flavor/flavor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web/web.dart';

Flavor createFlavor() {
  // Check for mock mode via URL parameter: ?mock=true
  // OR via Dart environment variable: --dart-define=MOCK_MODE=true
  final isMockMode = window.location.search.contains('mock=true') ||
      const bool.fromEnvironment('MOCK_MODE', defaultValue: false);

  if (isMockMode) {
    // MOCK BACKEND MODE for local testing
    const mockBackendDomain = "localhost:3000";
    const httpProtocol = "http://";
    const webSocketProtocol = "ws://";

    return Flavor.create(
      Environment.dev,
      color: Colors.orange, // Orange indicates mock mode
      properties: {
        'isSSL': false,
        'touchscreenWebSocket':
            '$webSocketProtocol$mockBackendDomain/sockets/touchscreen',
        'gpsWebSocket': '$webSocketProtocol$mockBackendDomain/sockets/gps',
        'audioWebSocket':
            '$webSocketProtocol$mockBackendDomain/sockets/audio',
        'displayWebSocket':
            '$webSocketProtocol$mockBackendDomain/sockets/display',
        'configurationApiBaseUrl': '$httpProtocol$mockBackendDomain/api',
      },
    );
  } else {
    // PRODUCTION MODE - normal Tesla Android backend
    const defaultDomain = "device.teslaandroid.com";
    final isLocalHost = window.location.hostname.contains("localhost");
    final domain = isLocalHost ? defaultDomain : window.location.hostname;
    final isSSL = window.location.protocol.contains("https") || kDebugMode;
    final httpProtocol = isSSL ? "https://" : "http://";
    final webSocketProtocol = isSSL ? "wss://" : "ws://";

    return Flavor.create(
      isLocalHost ? Environment.dev : Environment.production,
      color: isLocalHost ? Colors.green : Colors.red,
      properties: {
        'isSSL': isSSL,
        'touchscreenWebSocket': '$webSocketProtocol$domain/sockets/touchscreen',
        'gpsWebSocket': '$webSocketProtocol$domain/sockets/gps',
        'audioWebSocket': '$webSocketProtocol$domain/sockets/audio',
        'displayWebSocket': '$webSocketProtocol$domain/sockets/display',
        'configurationApiBaseUrl': '$httpProtocol$domain/api',
      },
    );
  }
}
