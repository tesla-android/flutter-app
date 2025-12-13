import 'package:flutter_test/flutter_test.dart';
import 'package:tesla_android/feature/settings/model/device_info.dart';
import '../../helpers/test_fixtures.dart';

void main() {
  group('DeviceInfo', () {
    test('creates instance with all fields', () {
      final info = TestFixtures.rpi4DeviceInfo;

      expect(info.cpuTemperature, 45);
      expect(info.serialNumber, "RPI4TEST001");
      expect(info.deviceModel, "rpi4");
      expect(info.isCarPlayDetected, 0);
      expect(info.isModemDetected, 1);
      expect(info.releaseType, "stable");
      expect(info.isGPSEnabled, 1);
    });

    test('fromJson deserializes correctly', () {
      final info = DeviceInfo.fromJson(TestFixtures.deviceInfoJson);

      expect(info.cpuTemperature, 45);
      expect(info.serialNumber, "TEST001");
      expect(info.deviceModel, "rpi4");
      expect(info.isModemDetected, 1);
      expect(info.isCarPlayDetected, 0);
      expect(info.releaseType, "stable");
      expect(info.isGPSEnabled, 1);
    });

    test('toJson serializes correctly', () {
      final info = TestFixtures.rpi4DeviceInfo;
      final json = info.toJson();

      expect(json['cpu_temperature'], 45);
      expect(json['serial_number'], "RPI4TEST001");
      expect(json['device_model'], "rpi4");
      expect(json['is_modem_detected'], 1);
      expect(json['is_carplay_detected'], 0);
      expect(json['release_type'], "stable");
      expect(json['is_gps_enabled'], 1);
    });

    test('equality works correctly', () {
      final info1 = TestFixtures.rpi4DeviceInfo;
      final info2 = DeviceInfo(
        cpuTemperature: 45,
        serialNumber: "RPI4TEST001",
        deviceModel: "rpi4",
        isCarPlayDetected: 0,
        isModemDetected: 1,
        releaseType: "stable",
        otaUrl: "https://example.com/ota",
        isGPSEnabled: 1,
      );

      expect(info1, equals(info2));
    });

    test('handles default values for missing JSON fields', () {
      final Map<String, dynamic> json = {
        // Minimal JSON - testing defaults
      };

      final info = DeviceInfo.fromJson(json);

      expect(info.cpuTemperature, 0); // default
      expect(info.serialNumber, "undefined"); // default
      expect(info.deviceModel, "undefined"); // default
      expect(info.isModemDetected, 0); // default
      expect(info.isCarPlayDetected, 0); // default
      expect(info.releaseType, "undefined"); // default
      expect(info.isGPSEnabled, 0); // default
    });
  });

  group('DeviceNameExtension', () {
    test('returns "Raspberry Pi 4" for rpi4 model', () {
      final info = DeviceInfo(
        cpuTemperature: 45,
        serialNumber: "TEST",
        deviceModel: "rpi4",
        isCarPlayDetected: 0,
        isModemDetected: 0,
        releaseType: "stable",
        otaUrl: "",
        isGPSEnabled: 0,
      );

      expect(info.deviceName, "Raspberry Pi 4");
    });

    test('returns "Compute Module 4" for cm4 model', () {
      final info = TestFixtures.cm4DeviceInfo;

      expect(info.deviceName, "Compute Module 4");
    });

    test('returns "UNOFFICIAL" for unknown model', () {
      final info = DeviceInfo(
        cpuTemperature: 45,
        serialNumber: "TEST",
        deviceModel: "unknown_device",
        isCarPlayDetected: 0,
        isModemDetected: 0,
        releaseType: "stable",
        otaUrl: "",
        isGPSEnabled: 0,
      );

      expect(info.deviceName, "UNOFFICIAL unknown_device");
    });
  });
}
