import 'package:tesla_android/feature/display/model/remote_display_state.dart';

abstract class DisplayConfigurationState {}

class DisplayConfigurationStateInitial extends DisplayConfigurationState {}

class DisplayConfigurationStateLoading extends DisplayConfigurationState {}

class DisplayConfigurationStateSettingsFetched
    extends DisplayConfigurationState {
  final DisplayResolutionModePreset lowResModePreset;
  final DisplayRendererType renderer;
  final bool isResponsive;
  final bool isVariableRefresh;
  final bool useVulkan;

  DisplayConfigurationStateSettingsFetched({
    required this.lowResModePreset,
    required this.renderer,
    required this.isResponsive,
    required this.isVariableRefresh,
    required this.useVulkan,
  });
}

class DisplayConfigurationStateSettingsUpdateInProgress
    extends DisplayConfigurationState {}

class DisplayConfigurationStateError extends DisplayConfigurationState {}
