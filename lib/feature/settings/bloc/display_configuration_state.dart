abstract class DisplayConfigurationState {}

class DisplayConfigurationStateInitial extends DisplayConfigurationState {}

class DisplayConfigurationStateLoading extends DisplayConfigurationState {}

class DisplayConfigurationStateSettingsFetched
    extends DisplayConfigurationState {
  final bool isLowResActive;

  DisplayConfigurationStateSettingsFetched({
    required this.isLowResActive,
  });
}

class DisplayConfigurationStateSettingsUpdateInProgress
    extends DisplayConfigurationState {}

class DisplayConfigurationStateError extends DisplayConfigurationState {}
