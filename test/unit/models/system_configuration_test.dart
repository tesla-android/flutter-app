import 'package:flutter_test/flutter_test.dart';
import 'package:tesla_android/feature/settings/model/system_configuration_response_body.dart';
import '../../helpers/test_fixtures.dart';

void main() {
  group('SystemConfigurationResponseBody', () {
    test('creates instance with all fields', () {
      final config = TestFixtures.defaultConfiguration;

      expect(config.bandType, 1);
      expect(config.channel, 36);
      expect(config.channelWidth, 80);
      expect(config.isEnabledFlag, 1);
      expect(config.isOfflineModeEnabledFlag, 0);
      expect(config.browserAudioIsEnabled, 1);
      expect(config.browserAudioVolume, 80);
      expect(config.isGPSEnabled, 1);
    });

    test('fromJson deserializes correctly', () {
      final config = SystemConfigurationResponseBody.fromJson(
        TestFixtures.configurationJson,
      );

      expect(config.bandType, 1);
      expect(config.channel, 36);
      expect(config.channelWidth, 80);
      expect(config.isEnabledFlag, 1);
      expect(config.isOfflineModeEnabledFlag, 0);
      expect(config.browserAudioIsEnabled, 1);
      expect(config.browserAudioVolume, 80);
      expect(config.isGPSEnabled, 1);
    });

    test('toJson serializes correctly', () {
      final config = TestFixtures.defaultConfiguration;
      final json = config.toJson();

      expect(json['persist.tesla-android.softap.band_type'], 1);
      expect(json['persist.tesla-android.softap.channel'], 36);
      expect(json['persist.tesla-android.softap.channel_width'], 80);
      expect(json['persist.tesla-android.softap.is_enabled'], 1);
      expect(json['persist.tesla-android.offline-mode.is_enabled'], 0);
      expect(json['persist.tesla-android.browser_audio.is_enabled'], 1);
      expect(json['persist.tesla-android.browser_audio.volume'], 80);
      expect(json['persist.tesla-android.gps.is_active'], 1);
    });

    test('round-trip serialization preserves values', () {
      final original = TestFixtures.defaultConfiguration;
      final json = original.toJson();
      final deserialized = SystemConfigurationResponseBody.fromJson(json);

      expect(deserialized.bandType, original.bandType);
      expect(deserialized.channel, original.channel);
      expect(deserialized.channelWidth, original.channelWidth);
      expect(deserialized.isEnabledFlag, original.isEnabledFlag);
      expect(
        deserialized.browserAudioIsEnabled,
        original.browserAudioIsEnabled,
      );
      expect(deserialized.browserAudioVolume, original.browserAudioVolume);
      expect(deserialized.isGPSEnabled, original.isGPSEnabled);
    });

    test('handles different Wi-Fi configurations', () {
      final json = {
        'persist.tesla-android.softap.band_type': 2,
        'persist.tesla-android.softap.channel': 149,
        'persist.tesla-android.softap.channel_width': 160,
        'persist.tesla-android.softap.is_enabled': 0,
        'persist.tesla-android.offline-mode.is_enabled': 1,
        'persist.tesla-android.offline-mode.telemetry.is_enabled': 0,
        'persist.tesla-android.offline-mode.tesla-firmware-downloads': 0,
        'persist.tesla-android.browser_audio.is_enabled': 0,
        'persist.tesla-android.browser_audio.volume': 50,
        'persist.tesla-android.gps.is_active': 0,
      };

      final config = SystemConfigurationResponseBody.fromJson(json);

      expect(config.bandType, 2);
      expect(config.channel, 149);
      expect(config.channelWidth, 160);
      expect(config.isEnabledFlag, 0);
      expect(config.isOfflineModeEnabledFlag, 1);
      expect(config.browserAudioIsEnabled, 0);
      expect(config.browserAudioVolume, 50);
      expect(config.isGPSEnabled, 0);
    });
  });
}
