import 'package:flutter_test/flutter_test.dart';
import 'package:tesla_android/feature/settings/bloc/system_configuration_state.dart';
import 'package:tesla_android/feature/settings/model/softap_band_type.dart';
import 'package:tesla_android/feature/settings/model/system_configuration_response_body.dart';

void main() {
  group('SystemConfigurationState', () {
    final mockConfig = SystemConfigurationResponseBody(
      isEnabledFlag: 1,
      bandType: 1,
      channel: 6,
      channelWidth: 2,
      isOfflineModeEnabledFlag: 0,
      isOfflineModeTelemetryEnabledFlag: 0,
      isOfflineModeTeslaFirmwareDownloadsEnabledFlag: 0,
      browserAudioIsEnabled: 1,
      browserAudioVolume: 100,
      isGPSEnabled: 1,
    );

    test('SystemConfigurationStateInitial instantiation', () {
      expect(
        SystemConfigurationStateInitial(),
        isA<SystemConfigurationState>(),
      );
    });

    test('SystemConfigurationStateLoading instantiation', () {
      expect(
        SystemConfigurationStateLoading(),
        isA<SystemConfigurationState>(),
      );
    });

    test('SystemConfigurationStateSettingsFetched instantiation', () {
      final state = SystemConfigurationStateSettingsFetched(
        currentConfiguration: mockConfig,
      );
      expect(state.currentConfiguration, mockConfig);
    });

    test('SystemConfigurationStateSettingsFetchingError instantiation', () {
      expect(
        SystemConfigurationStateSettingsFetchingError(),
        isA<SystemConfigurationState>(),
      );
    });

    test(
      'SystemConfigurationStateSettingsModified instantiation and copyWith',
      () {
        final state = SystemConfigurationStateSettingsModified(
          currentConfiguration: mockConfig,
          newBandType: SoftApBandType.band2_4GHz,
          isSoftApEnabled: true,
          isOfflineModeEnabled: false,
          isOfflineModeTelemetryEnabled: false,
          isOfflineModeTeslaFirmwareDownloadsEnabled: false,
        );

        expect(state.newBandType, SoftApBandType.band2_4GHz);
        expect(state.isSoftApEnabled, true);

        final copy = state.copyWith(
          isSoftApEnabled: false,
          newBandType: SoftApBandType.band5GHz36,
        );

        expect(copy.isSoftApEnabled, false);
        expect(copy.newBandType, SoftApBandType.band5GHz36);
        expect(copy.isOfflineModeEnabled, false); // Should persist
      },
    );

    test(
      'SystemConfigurationStateSettingsModified.fromCurrentConfiguration',
      () {
        final state =
            SystemConfigurationStateSettingsModified.fromCurrentConfiguration(
              currentConfiguration: mockConfig,
            );

        // mockConfig has isEnabledFlag: 1 -> isSoftApEnabled: true
        expect(state.isSoftApEnabled, true);
      },
    );

    test('SystemConfigurationStateSettingsSaved instantiation', () {
      final state = SystemConfigurationStateSettingsSaved(
        currentConfiguration: mockConfig,
      );
      expect(state.currentConfiguration, mockConfig);
    });

    test('SystemConfigurationStateSettingsSavingFailedError instantiation', () {
      expect(
        SystemConfigurationStateSettingsSavingFailedError(),
        isA<SystemConfigurationState>(),
      );
    });
  });
}
