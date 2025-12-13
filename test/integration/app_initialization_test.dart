import 'package:flutter_test/flutter_test.dart';
import 'package:tesla_android/feature/display/model/remote_display_state.dart';
import 'package:tesla_android/feature/settings/model/device_info.dart';

void main() {
  group('Basic Smoke Tests', () {
    test('RemoteDisplayState can be created and serialized', () {
      final state = RemoteDisplayState(
        width: 1920,
        height: 1080,
        density: 200,
        resolutionPreset: DisplayResolutionModePreset.res832p,
        renderer: DisplayRendererType.h264WebCodecs,
        isResponsive: 1,
        isH264: 1,
        refreshRate: DisplayRefreshRatePreset.refresh30hz,
        quality: DisplayQualityPreset.quality90,
        isRearDisplayEnabled: 0,
        isRearDisplayPrioritised: 0,
        isHeadless: 0,
      );

      final json = state.toJson();
      final deserialized = RemoteDisplayState.fromJson(json);

      expect(deserialized, equals(state));
    });

    test('DeviceInfo can be created and serialized', () {
      final info = DeviceInfo(
        cpuTemperature: 45,
        serialNumber: "TEST001",
        deviceModel: "rpi4",
        isCarPlayDetected: 0,
        isModemDetected: 1,
        releaseType: "stable",
        otaUrl: "https://example.com",
        isGPSEnabled: 1,
      );

      final json = info.toJson();
      final deserialized = DeviceInfo.fromJson(json);

      expect(deserialized, equals(info));
    });

    // Note: Full app initialization test with DI requires web environment
    // which is not available in VM test environment.
    // These would be better tested as:
    // 1. E2E tests with actual browser
    // 2. Widget tests with proper test environment setup
    // 3. Manual testing with mock backend
  });
}
