abstract class RearDisplayConfigurationState {}

class RearDisplayConfigurationStateInitial
    extends RearDisplayConfigurationState {}

class RearDisplayConfigurationStateLoading
    extends RearDisplayConfigurationState {}

class RearDisplayConfigurationStateSettingsFetched
    extends RearDisplayConfigurationState {
  final bool isRearDisplayEnabled;
  final bool isRearDisplayPrioritised;
  final bool isCurrentDisplayPrimary;

  RearDisplayConfigurationStateSettingsFetched({
    required this.isRearDisplayEnabled,
    required this.isRearDisplayPrioritised,
    required this.isCurrentDisplayPrimary,
  });
}

class RearDisplayConfigurationStateSettingsUpdateInProgress
    extends RearDisplayConfigurationState {}

class RearDisplayConfigurationStateError
    extends RearDisplayConfigurationState {}
