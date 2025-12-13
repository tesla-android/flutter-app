import 'package:tesla_android/feature/settings/bloc/system_configuration_state.dart';
import 'package:tesla_android/feature/settings/model/softap_band_type.dart';
import 'package:tesla_android/feature/settings/view_model/base_settings_view_model.dart';

/// View model for HotspotSettings widget
///
/// Extracts business logic and state handling from the widget.
class HotspotSettingsViewModel
    extends BaseSettingsViewModel<SystemConfigurationState> {
  @override
  bool isLoadingState(SystemConfigurationState state) {
    return !isFetchedState(state) && !isErrorState(state);
  }

  @override
  bool isFetchedState(SystemConfigurationState state) {
    return state is SystemConfigurationStateSettingsFetched ||
        state is SystemConfigurationStateSettingsModified;
  }

  @override
  bool isErrorState(SystemConfigurationState state) {
    return state is SystemConfigurationStateSettingsFetchingError ||
        state is SystemConfigurationStateSettingsSavingFailedError;
  }

  /// Gets the current soft AP band type from state
  SoftApBandType? getSoftApBand(SystemConfigurationState state) {
    if (state is SystemConfigurationStateSettingsFetched) {
      return state.currentConfiguration.currentSoftApBandType;
    } else if (state is SystemConfigurationStateSettingsModified) {
      return state.newBandType;
    }
    return null;
  }

  /// Gets offline mode enabled status from state
  bool? getOfflineModeEnabled(SystemConfigurationState state) {
    if (state is SystemConfigurationStateSettingsFetched) {
      return state.currentConfiguration.isOfflineModeEnabledFlag == 1;
    } else if (state is SystemConfigurationStateSettingsModified) {
      return state.isOfflineModeEnabled;
    }
    return null;
  }

  /// Gets offline mode telemetry enabled status from state
  bool? getOfflineModeTelemetryEnabled(SystemConfigurationState state) {
    if (state is SystemConfigurationStateSettingsFetched) {
      return state.currentConfiguration.isOfflineModeTelemetryEnabledFlag == 1;
    } else if (state is SystemConfigurationStateSettingsModified) {
      return state.isOfflineModeTelemetryEnabled;
    }
    return null;
  }

  /// Gets Tesla firmware downloads enabled status from state
  bool? getTeslaFirmwareDownloadsEnabled(SystemConfigurationState state) {
    if (state is SystemConfigurationStateSettingsFetched) {
      return state
              .currentConfiguration
              .isOfflineModeTeslaFirmwareDownloadsEnabledFlag ==
          1;
    } else if (state is SystemConfigurationStateSettingsModified) {
      return state.isOfflineModeTeslaFirmwareDownloadsEnabled;
    }
    return null;
  }

  /// Checks if the state represents fetchable settings
  /// @deprecated Use isFetched() or isFetchedState() instead
  bool hasSettings(SystemConfigurationState state) => isFetchedState(state);

  /// Checks if there's a fetching error
  bool isFetchError(SystemConfigurationState state) {
    return state is SystemConfigurationStateSettingsFetchingError;
  }

  /// Checks if there's a saving error
  bool isSaveError(SystemConfigurationState state) {
    return state is SystemConfigurationStateSettingsSavingFailedError;
  }
}
