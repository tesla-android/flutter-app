import 'package:flutter_test/flutter_test.dart';
import 'package:tesla_android/feature/settings/bloc/system_configuration_state.dart';
import 'package:tesla_android/feature/settings/model/softap_band_type.dart';
import 'package:tesla_android/feature/settings/model/system_configuration_response_body.dart';
import 'package:tesla_android/feature/settings/view_model/hotspot_settings_view_model.dart';

void main() {
  group('HotspotSettingsViewModel', () {
    late HotspotSettingsViewModel viewModel;

    setUp(() {
      viewModel = HotspotSettingsViewModel();
    });

    final testConfig = SystemConfigurationResponseBody(
      bandType: 1,
      channel: 6,
      channelWidth: 2,
      isEnabledFlag: 1,
      isOfflineModeEnabledFlag: 1,
      isOfflineModeTelemetryEnabledFlag: 0,
      isOfflineModeTeslaFirmwareDownloadsEnabledFlag: 1,
      browserAudioIsEnabled: 1,
      browserAudioVolume: 100,
      isGPSEnabled: 1,
    );

    group('state checking methods', () {
      test('hasSettings returns true for SettingsFetched state', () {
        final state = SystemConfigurationStateSettingsFetched(
          currentConfiguration: testConfig,
        );
        expect(viewModel.hasSettings(state), true);
      });

      test('hasSettings returns true for SettingsModified state', () {
        final state = SystemConfigurationStateSettingsModified(
          currentConfiguration: testConfig,
          newBandType: SoftApBandType.band2_4GHz,
          isSoftApEnabled: true,
          isOfflineModeEnabled: true,
          isOfflineModeTelemetryEnabled: false,
          isOfflineModeTeslaFirmwareDownloadsEnabled: true,
        );
        expect(viewModel.hasSettings(state), true);
      });

      test('isFetchError returns true for FetchingError state', () {
        final state = SystemConfigurationStateSettingsFetchingError();
        expect(viewModel.isFetchError(state), true);
      });

      test('isSaveError returns true for SavingFailedError state', () {
        final state = SystemConfigurationStateSettingsSavingFailedError();
        expect(viewModel.isSaveError(state), true);
      });
    });

    group('value extraction from fetched state', () {
      final fetchedState = SystemConfigurationStateSettingsFetched(
        currentConfiguration: testConfig,
      );

      test('getSoftApBand extracts band from config', () {
        final band = viewModel.getSoftApBand(fetchedState);
        expect(band, isNotNull);
        expect(band, SoftApBandType.band2_4GHz);
      });

      test('getOfflineModeEnabled converts flag to bool', () {
        expect(viewModel.getOfflineModeEnabled(fetchedState), true);
      });

      test('getOfflineModeTelemetryEnabled converts flag to bool', () {
        expect(viewModel.getOfflineModeTelemetryEnabled(fetchedState), false);
      });

      test('getTeslaFirmwareDownloadsEnabled converts flag to bool', () {
        expect(viewModel.getTeslaFirmwareDownloadsEnabled(fetchedState), true);
      });
    });

    group('value extraction from modified state', () {
      final modifiedState = SystemConfigurationStateSettingsModified(
        currentConfiguration: testConfig,
        newBandType: SoftApBandType.band5GHz36,
        isSoftApEnabled: true,
        isOfflineModeEnabled: false,
        isOfflineModeTelemetryEnabled: true,
        isOfflineModeTeslaFirmwareDownloadsEnabled: false,
      );

      test('getSoftApBand extracts band from modified state', () {
        expect(
          viewModel.getSoftApBand(modifiedState),
          SoftApBandType.band5GHz36,
        );
      });

      test('getOfflineModeEnabled extracts from modified state', () {
        expect(viewModel.getOfflineModeEnabled(modifiedState), false);
      });

      test('getOfflineModeTelemetryEnabled extracts from modified state', () {
        expect(viewModel.getOfflineModeTelemetryEnabled(modifiedState), true);
      });

      test('getTeslaFirmwareDownloadsEnabled extracts from modified state', () {
        expect(
          viewModel.getTeslaFirmwareDownloadsEnabled(modifiedState),
          false,
        );
      });
    });
  });
}
