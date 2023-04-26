import 'dart:html';

import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart' hide Environment;
import 'package:shared_preferences/shared_preferences.dart';

const bool _enableIpOverride = false;
const String _ipOverride = '192.168.0.xxx';

@module
abstract class AppModule {
  @singleton
  Flavor get provideFlavor {
    final ipAddress = _enableIpOverride ? _ipOverride : (window.location.hostname ?? "9.9.0.1");
    return Flavor.create(
      _enableIpOverride ? Environment.dev : Environment.production,
      color: _enableIpOverride ? Colors.green : Colors.red,
      properties: {
        'touchscreenWebSocket': 'ws://$ipAddress:9999',
        'displayWebSocket' : 'ws://$ipAddress:9090/',
        'audioWebSocket' : 'ws://$ipAddress:8080/',
        'connectivityCheck' : 'http://$ipAddress/online/connectivity_check.txt',
        'virtualDisplayWidth': 1088,
        'virtualDisplayHeight': 832,
      },
    );
  }

  @singleton
  @preResolve
  Future<SharedPreferences> get sharedPreferences => SharedPreferences.getInstance();
}