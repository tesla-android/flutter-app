import 'package:tesla_android/common/service/window_service.dart';

class WindowServiceStub implements WindowService {
  @override
  void reload() {
    // No-op on VM
  }
}

WindowService createWindowService() => WindowServiceStub();
