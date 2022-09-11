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
          'touchscreenWebSocket': 'ws://9.9.0.1:9999',
          'mjpgStreamerBaseUrl' : 'http://9.9.0.1:9090/',
          'virtualDisplayWidth': 944,
          'virtualDisplayHeight': 720,
        },
      );

  @singleton
  @preResolve
  Future<SharedPreferences> get sharedPreferences => SharedPreferences.getInstance();
}
