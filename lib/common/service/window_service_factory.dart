import 'package:tesla_android/common/service/window_service.dart';
import 'window_service_stub.dart'
    if (dart.library.js_interop) 'web_window_service.dart';

class WindowServiceFactory {
  static WindowService create() => createWindowService();
}
