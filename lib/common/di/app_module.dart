// ignore: avoid_web_libraries_in_flutter
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
    final isSSL = window.location.protocol.contains("https");
    final httpProtocol = isSSL ? "https://" : "http://";
    final webSocketProtocol = isSSL ? "wss://" : "ws://";
    return Flavor.create(
      _enableDomainOverride ? Environment.dev : Environment.production,
      color: _enableDomainOverride ? Colors.green : Colors.red,
      properties: {
        'isSSL' : isSSL,
        'touchscreenWebSocket': '$webSocketProtocol$domain/sockets/touchscreen',
        'gpsWebSocket': '$webSocketProtocol$domain/sockets/gps',
        'audioWebSocket': '$webSocketProtocol$domain/sockets/audio',
        'displayWebSocket': '$webSocketProtocol$domain/sockets/display',
        'configurationApiBaseUrl': '$httpProtocol$domain/api',
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
