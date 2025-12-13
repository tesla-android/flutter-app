import 'package:tesla_android/common/service/window_service.dart';
import 'package:web/web.dart' as web;

class WebWindowService implements WindowService {
  @override
  void reload() {
    web.window.location.reload();
  }
}

WindowService createWindowService() => WebWindowService();
