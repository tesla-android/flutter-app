import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart' hide Environment;
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class AppModule {
  @singleton
  Flavor get provideFlavor => Flavor.create(
        Environment.alpha,
        color: Colors.red,
        name: 'ALPHA',
        properties: {
          'virtualTouchscreenWebSocket': 'ws://3.3.3.50:9999',
          'janusWebSocket': 'ws://3.3.3.1:8002/janus/ws',
          'janusTurnUsername': 'test',
          'janusTurnPassword': 'test123',
          'janusTurnUrl': 'turn:3.3.3.1:3478',
        },
      );

  @singleton
  @preResolve
  Future<SharedPreferences> get sharedPreferences => SharedPreferences.getInstance();
}
