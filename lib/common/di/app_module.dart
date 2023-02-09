import 'dart:html';

import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart' hide Environment;
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class AppModule {
  @singleton
  Flavor get provideFlavor => Flavor.create(
        Environment.production,
        color: Colors.red,
        properties: {
          'touchscreenWebSocket': 'ws://' + (window.location.hostname ?? "9.9.0.1") + ':9999',
          'displayWebSocket' : 'ws://' + (window.location.hostname ?? "9.9.0.1") + ':9090/',
          'connectivityCheck' : 'http://' + (window.location.hostname ?? "9.9.0.1") + '/online/connectivity_check.txt',
          'virtualDisplayWidth': 1034,
          'virtualDisplayHeight': 788,
        },
      );
  // Flavor get provideFlavor => Flavor.create(
  //       Environment.dev,
  //       color: Colors.green,
  //       properties: {
  //         'touchscreenWebSocket': 'ws://9.9.0.1:9999',
  //         'displayWebSocket': 'ws://9.9.0.1:9090',
  //         'connectivityCheck' : 'http://9.9.0.1/online/connectivity_check.txt',
  //         'virtualDisplayWidth': 1034,
  //         'virtualDisplayHeight': 788,
  //       },
  //     );

  @singleton
  @preResolve
  Future<SharedPreferences> get sharedPreferences => SharedPreferences.getInstance();
}