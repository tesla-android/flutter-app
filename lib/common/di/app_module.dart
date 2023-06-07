import 'dart:html' hide Location;

import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart' hide Environment;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';

const bool _enableIpOverride = true;
const String _ipOverride = '100.64.255.1';

@module
abstract class AppModule {
  @singleton
  Flavor get provideFlavor {
    final ipAddress = _enableIpOverride
        ? _ipOverride
        : (window.location.hostname ?? "100.64.255.1");
    return Flavor.create(
      _enableIpOverride ? Environment.dev : Environment.production,
      color: _enableIpOverride ? Colors.green : Colors.red,
      properties: {
        'touchscreenWebSocket': 'ws://$ipAddress:9999',
        'displayWebSocket': 'ws://$ipAddress:9090',
        'audioWebSocket': 'ws://$ipAddress:8080',
        'configurationApiBaseUrl': 'http://$ipAddress:8081',
        'connectivityCheck': 'http://$ipAddress/online/connectivity_check.txt',
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
