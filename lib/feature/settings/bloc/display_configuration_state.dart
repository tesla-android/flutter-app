import 'package:tesla_android/feature/display/model/remote_display_state.dart';

abstract class DisplayConfigurationState {}

class DisplayConfigurationStateInitial extends DisplayConfigurationState {}

class DisplayConfigurationStateLoading extends DisplayConfigurationState {}

class DisplayConfigurationStateSettingsFetched
    extends DisplayConfigurationState {
  final DisplayResolutionModePreset lowResModePreset;
  final DisplayRendererType renderer;
  final bool isResponsive;
  final DisplayQualityPreset quality;
  final DisplayRefreshRatePreset refreshRate;

  DisplayConfigurationStateSettingsFetched({
    required this.lowResModePreset,
    required this.renderer,
    required this.isResponsive,
    required this.refreshRate,
    required this.quality,
  });
}

class DisplayConfigurationStateSettingsUpdateInProgress
    extends DisplayConfigurationState {}

class DisplayConfigurationStateError extends DisplayConfigurationState {}
