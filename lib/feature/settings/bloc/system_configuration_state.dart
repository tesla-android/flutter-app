import 'package:tesla_android/feature/settings/model/softap_band_type.dart';
import 'package:tesla_android/feature/settings/model/system_configuration_response_body.dart';

abstract class SystemConfigurationState {}

class SystemConfigurationStateInitial extends SystemConfigurationState {}

class SystemConfigurationStateLoading extends SystemConfigurationState {}

class SystemConfigurationStateSettingsFetched extends SystemConfigurationState {
  final SystemConfigurationResponseBody currentConfiguration;

  SystemConfigurationStateSettingsFetched({
    required this.currentConfiguration,
  });
}

class SystemConfigurationStateSettingsFetchingError
    extends SystemConfigurationState {}

class SystemConfigurationStateSettingsModified
    extends SystemConfigurationState {
  final SystemConfigurationResponseBody currentConfiguration;
  final SoftApBandType newBandType;
  final bool isSoftApEnabled;
  final bool isOfflineModeEnabled;
  final bool isOfflineModeTelemetryEnabled;
  final bool isOfflineModeTeslaFirmwareDownloadsEnabled;

  SystemConfigurationStateSettingsModified({
    required this.currentConfiguration,
    required this.newBandType,
    required this.isSoftApEnabled,
    required this.isOfflineModeEnabled,
    required this.isOfflineModeTelemetryEnabled,
    required this.isOfflineModeTeslaFirmwareDownloadsEnabled,
  });

  SystemConfigurationStateSettingsModified.fromCurrentConfiguration({
    required this.currentConfiguration,
    SoftApBandType? newBandType,
    bool? isSoftApEnabled,
    bool? isOfflineModeEnabled,
    bool? isOfflineModeTelemetryEnabled,
    bool? isOfflineModeTeslaFirmwareDownloadsEnabled,
  })  : newBandType = newBandType ?? currentConfiguration.currentSoftApBandType,
        isSoftApEnabled = isSoftApEnabled ??
            (currentConfiguration.isEnabledFlag == 1 ? true : false),
        isOfflineModeEnabled = isOfflineModeEnabled ??
            (currentConfiguration.isOfflineModeEnabledFlag == 1 ? true : false),
        isOfflineModeTelemetryEnabled = isOfflineModeTelemetryEnabled ??
            (currentConfiguration.isOfflineModeTelemetryEnabledFlag == 1
                ? true
                : false),
        isOfflineModeTeslaFirmwareDownloadsEnabled =
            isOfflineModeTeslaFirmwareDownloadsEnabled ??
                (currentConfiguration
                            .isOfflineModeTeslaFirmwareDownloadsEnabledFlag ==
                        1
                    ? true
                    : false);

  SystemConfigurationStateSettingsModified copyWith({
    SystemConfigurationResponseBody? currentConfiguration,
    SoftApBandType? newBandType,
    bool? isSoftApEnabled,
    bool? isOfflineModeEnabled,
    bool? isOfflineModeTelemetryEnabled,
    bool? isOfflineModeTeslaFirmwareDownloadsEnabled,
  }) {
    return SystemConfigurationStateSettingsModified(
        currentConfiguration: currentConfiguration ?? this.currentConfiguration,
        newBandType: newBandType ?? this.newBandType,
        isSoftApEnabled: isSoftApEnabled ?? this.isSoftApEnabled,
        isOfflineModeEnabled: isOfflineModeEnabled ?? this.isOfflineModeEnabled,
        isOfflineModeTelemetryEnabled:
            isOfflineModeTelemetryEnabled ?? this.isOfflineModeTelemetryEnabled,
        isOfflineModeTeslaFirmwareDownloadsEnabled:
            isOfflineModeTeslaFirmwareDownloadsEnabled ??
                this.isOfflineModeTeslaFirmwareDownloadsEnabled);
  }
}

class SystemConfigurationStateSettingsSaved extends SystemConfigurationState {
  final SystemConfigurationResponseBody currentConfiguration;

  SystemConfigurationStateSettingsSaved({
    required this.currentConfiguration,
  });
}

class SystemConfigurationStateSettingsSavingFailedError
    extends SystemConfigurationState {}
