abstract class GPSConfigurationState {}

class GPSConfigurationStateInitial extends GPSConfigurationState {}

class GPSConfigurationStateLoading extends GPSConfigurationState {}

class GPSConfigurationStateLoaded extends GPSConfigurationState {
  final bool isGPSEnabled;

  GPSConfigurationStateLoaded({required this.isGPSEnabled});
}

class GPSConfigurationStateUpdateInProgress extends GPSConfigurationState {
  final bool isGPSEnabled;

  GPSConfigurationStateUpdateInProgress({required this.isGPSEnabled});
}

class GPSConfigurationStateError extends GPSConfigurationState {}
