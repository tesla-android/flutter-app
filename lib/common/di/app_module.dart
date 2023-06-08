import 'dart:html' hide Location;

import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart' hide Environment;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';

const bool _enableDomainOverride = false;
const String _domainOverride = 'device.teslaandroid.com';

@module
abstract class AppModule {
  @singleton
  Flavor get provideFlavor {
    final domain = _enableDomainOverride
        ? _domainOverride
        : (window.location.hostname ?? "device.teslaandroid.com");
    return Flavor.create(
      _enableDomainOverride ? Environment.dev : Environment.production,
      color: _enableDomainOverride ? Colors.green : Colors.red,
      properties: {
        'touchscreenWebSocket': 'wss://$domain/sockets/touchscreen',
        'gpsWebSocket': 'wss://$domain/sockets/gps',
        'audioWebSocket': 'wss://$domain/sockets/audio',
        'configurationApiBaseUrl': 'https://$domain/api',
        'connectivityCheck': 'https://$domain/online/connectivity_check.txt',
        'virtualDisplayWidth': 1088,
        'virtualDisplayHeight': 832,
      },
    );
  }

  @singleton
  @preResolve
  Future<SharedPreferences> get sharedPreferences => SharedPreferences.getInstance();

  @singleton
  Location get location => Location();

  @lazySingleton
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();
}
