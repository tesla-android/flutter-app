import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';

Flavor createFlavor() {
  return Flavor.create(
    Environment.dev,
    color: Colors.blue,
    properties: {
      'isSSL': false,
      'touchscreenWebSocket': 'ws://localhost:3000/sockets/touchscreen',
      'gpsWebSocket': 'ws://localhost:3000/sockets/gps',
      'audioWebSocket': 'ws://localhost:3000/sockets/audio',
      'displayWebSocket': 'ws://localhost:3000/sockets/display',
      'configurationApiBaseUrl': 'http://localhost:3000/api',
    },
  );
}
