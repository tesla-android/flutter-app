// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:aptabase_flutter/aptabase_flutter.dart';
import 'package:flavor/flavor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart' hide Environment;
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class AppModule {
  @singleton
  Flavor get provideFlavor {
    const defaultDomain = "device.teslaandroid.com";
    final isLocalHost = window.location.hostname?.contains("localhost") ?? true;
    final domain = isLocalHost ? defaultDomain : (window.location.hostname ?? defaultDomain);
    final isSSL = window.location.protocol.contains("https") || kDebugMode;
    final httpProtocol = isSSL ? "https://" : "http://";
    final webSocketProtocol = isSSL ? "wss://" : "ws://";
    return Flavor.create(
      isLocalHost ? Environment.dev : Environment.production,
      color: isLocalHost ? Colors.green : Colors.red,
      properties: {
        'isSSL': isSSL,
        'touchscreenWebSocket': '$webSocketProtocol$domain/sockets/touchscreen',
        'gpsWebSocket': '$webSocketProtocol$domain/sockets/gps',
        'audioWebSocket': '$webSocketProtocol$domain/sockets/audio',
        //'displayWebSocket': '$webSocketProtocol$domain/sockets/display',
        'displayWebSocket': '$httpProtocol$domain/stream',
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
        "A-SH-6015564984",
        const InitOptions(
          host: "https://aptabase.teslaandroid.com",
        ));
    return Aptabase.instance;
  }
}
