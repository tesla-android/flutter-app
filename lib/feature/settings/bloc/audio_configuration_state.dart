abstract class AudioConfigurationState {}

class AudioConfigurationStateInitial extends AudioConfigurationState {}

class AudioConfigurationStateLoading extends AudioConfigurationState {}

class AudioConfigurationStateSettingsFetched
    extends AudioConfigurationState {
  final bool isEnabled;
  final int volume;

  AudioConfigurationStateSettingsFetched({
    required this.isEnabled,
    required this.volume,
  });
}

class AudioConfigurationStateSettingsUpdateInProgress
    extends AudioConfigurationState {}

class AudioConfigurationStateError extends AudioConfigurationState {}
