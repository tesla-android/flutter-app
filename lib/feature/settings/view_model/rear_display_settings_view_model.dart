import 'package:tesla_android/feature/settings/bloc/rear_display_configuration_state.dart';
import 'package:tesla_android/feature/settings/view_model/base_settings_view_model.dart';

/// View model for RearDisplaySettings widget
///
/// Extracts business logic and state handling from the widget.
class RearDisplaySettingsViewModel
    extends BaseSettingsViewModel<RearDisplayConfigurationState> {
  @override
  bool isLoadingState(RearDisplayConfigurationState state) {
    return state is RearDisplayConfigurationStateLoading ||
        state is RearDisplayConfigurationStateSettingsUpdateInProgress;
  }

  @override
  bool isFetchedState(RearDisplayConfigurationState state) {
    return state is RearDisplayConfigurationStateSettingsFetched;
  }

  @override
  bool isErrorState(RearDisplayConfigurationState state) {
    return state is RearDisplayConfigurationStateError;
  }

  /// Gets rear display enabled status from state
  bool? getRearDisplayEnabled(RearDisplayConfigurationState state) {
    if (state is RearDisplayConfigurationStateSettingsFetched) {
      return state.isRearDisplayEnabled;
    }
    return null;
  }

  /// Gets rear display priority status from state
  bool? getRearDisplayPrioritised(RearDisplayConfigurationState state) {
    if (state is RearDisplayConfigurationStateSettingsFetched) {
      return state.isRearDisplayPrioritised;
    }
    return null;
  }

  /// Gets current display primary status from state
  bool? getCurrentDisplayPrimary(RearDisplayConfigurationState state) {
    if (state is RearDisplayConfigurationStateSettingsFetched) {
      return state.isCurrentDisplayPrimary;
    }
    return null;
  }
}
