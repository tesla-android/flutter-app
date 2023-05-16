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

  SystemConfigurationStateSettingsModified({
    required this.currentConfiguration,
    required this.newBandType,
    required this.isSoftApEnabled,
  });

  SystemConfigurationStateSettingsModified copyWith({
    SystemConfigurationResponseBody? currentConfiguration,
    SoftApBandType? newBandType,
    bool? isSoftApEnabled,
  }) {
    return SystemConfigurationStateSettingsModified(
      currentConfiguration: currentConfiguration ?? this.currentConfiguration,
      newBandType: newBandType ?? this.newBandType,
      isSoftApEnabled: isSoftApEnabled ?? this.isSoftApEnabled,
    );
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
