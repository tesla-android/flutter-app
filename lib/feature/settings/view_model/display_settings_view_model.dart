import 'package:tesla_android/feature/display/model/remote_display_state.dart';
import 'package:tesla_android/feature/settings/bloc/display_configuration_state.dart';
import 'package:tesla_android/feature/settings/view_model/base_settings_view_model.dart';

/// View model for DisplaySettings widget
///
/// Extracts business logic and state handling from the widget,
/// making it easier to test and maintain.
class DisplaySettingsViewModel
    extends BaseSettingsViewModel<DisplayConfigurationState> {
  @override
  bool isLoadingState(DisplayConfigurationState state) {
    return state is DisplayConfigurationStateLoading ||
        state is DisplayConfigurationStateSettingsUpdateInProgress;
  }

  @override
  bool isFetchedState(DisplayConfigurationState state) {
    return state is DisplayConfigurationStateSettingsFetched;
  }

  @override
  bool isErrorState(DisplayConfigurationState state) {
    return state is DisplayConfigurationStateError;
  }

  /// Gets the current renderer value from state
  DisplayRendererType? getRenderer(DisplayConfigurationState state) {
    if (state is DisplayConfigurationStateSettingsFetched) {
      return state.renderer;
    }
    return null;
  }

  /// Gets the current resolution preset from state
  DisplayResolutionModePreset? getResolutionPreset(
    DisplayConfigurationState state,
  ) {
    if (state is DisplayConfigurationStateSettingsFetched) {
      return state.resolutionPreset;
    }
    return null;
  }

  /// Gets the current quality preset from state
  DisplayQualityPreset? getQualityPreset(DisplayConfigurationState state) {
    if (state is DisplayConfigurationStateSettingsFetched) {
      return state.quality;
    }
    return null;
  }

  /// Gets the current refresh rate from state
  DisplayRefreshRatePreset? getRefreshRate(DisplayConfigurationState state) {
    if (state is DisplayConfigurationStateSettingsFetched) {
      return state.refreshRate;
    }
    return null;
  }

  /// Gets the responsiveness setting from state
  bool? getResponsiveness(DisplayConfigurationState state) {
    if (state is DisplayConfigurationStateSettingsFetched) {
      return state.isResponsive;
    }
    return null;
  }
}
