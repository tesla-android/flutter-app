import 'dart:html';

import 'package:aptabase_flutter/aptabase_flutter.dart';
import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart' hide Environment;
import 'package:shared_preferences/shared_preferences.dart';

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
        'displayWebSocket': 'wss://$domain/sockets/display',
        'configurationApiBaseUrl': 'https://$domain/api',
      },
    );
  }

  @singleton
  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  @lazySingleton
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();

  @singleton
  Future<Aptabase> provideAptabase() async {
    await Aptabase.init(
        "A-SH-9186809739",
        const InitOptions(
          host: "https://aptabase.teslaandroid.com",
        ));
    return Aptabase.instance;
  }
}
