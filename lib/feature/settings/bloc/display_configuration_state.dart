import 'package:tesla_android/feature/display/model/remote_display_state.dart';

abstract class DisplayConfigurationState {}

class DisplayConfigurationStateInitial extends DisplayConfigurationState {}

class DisplayConfigurationStateLoading extends DisplayConfigurationState {}

class DisplayConfigurationStateSettingsFetched
    extends DisplayConfigurationState {
  final DisplayLowResModePreset lowResModePreset;
  final DisplayRendererType renderer;

  DisplayConfigurationStateSettingsFetched({
    required this.lowResModePreset,
    required this.renderer,
  });
}

class DisplayConfigurationStateSettingsUpdateInProgress
    extends DisplayConfigurationState {}

class DisplayConfigurationStateError extends DisplayConfigurationState {}
