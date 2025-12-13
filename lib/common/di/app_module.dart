import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart' hide Environment;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesla_android/common/di/flavor_factory.dart';
import 'package:tesla_android/common/service/audio_service.dart';
import 'package:tesla_android/common/service/audio_service_factory.dart';
import 'package:tesla_android/feature/touchscreen/service/message_sender.dart';
import 'package:tesla_android/common/service/window_service.dart';
import 'package:tesla_android/common/service/window_service_factory.dart';
import 'package:tesla_android/feature/touchscreen/service/message_sender_factory.dart';

@module
abstract class AppModule {
  @singleton
  Flavor get provideFlavor => FlavorFactory.create();

  @singleton
  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  @singleton
  WindowService get windowService => WindowServiceFactory.create();

  @singleton
  MessageSender get messageSender => MessageSenderFactory.create();

  @singleton
  AudioService get audioService => AudioServiceFactory.create();

  @lazySingleton
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();
}
