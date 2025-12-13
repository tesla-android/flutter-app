import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:tesla_android/common/service/audio_service.dart';
import 'package:tesla_android/common/service/window_service.dart';
import 'package:tesla_android/feature/touchscreen/service/message_sender.dart';
import 'package:tesla_android/common/service/dialog_service.dart';

import 'package:tesla_android/common/network/device_info_service.dart';
import 'package:tesla_android/common/network/github_service.dart';

import 'package:tesla_android/common/navigation/ta_page_factory.dart';
import 'package:flavor/flavor.dart';

@GenerateMocks([
  AudioService,
  WindowService,
  MessageSender,
  GitHubService,
  DeviceInfoService,
  TAPageFactory,
  Flavor,
  Dio,
  DialogService,
])
void main() {}
