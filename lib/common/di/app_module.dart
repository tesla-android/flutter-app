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
          'touchscreenWebSocket': 'ws://3.3.3.50:9999',
          'ustreamerBaseUrl' : 'http://3.3.3.1:8001/'
        },
      );

  @singleton
  @preResolve
  Future<SharedPreferences> get sharedPreferences => SharedPreferences.getInstance();
}
