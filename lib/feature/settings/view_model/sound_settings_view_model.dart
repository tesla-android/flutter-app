import 'package:tesla_android/feature/settings/bloc/audio_configuration_state.dart';
import 'package:tesla_android/feature/settings/view_model/base_settings_view_model.dart';

/// View model for SoundSettings widget
///
/// Extracts business logic and state handling from the widget.
class SoundSettingsViewModel
    extends BaseSettingsViewModel<AudioConfigurationState> {
  @override
  bool isLoadingState(AudioConfigurationState state) {
    return state is AudioConfigurationStateLoading ||
        state is AudioConfigurationStateSettingsUpdateInProgress;
  }

  @override
  bool isFetchedState(AudioConfigurationState state) {
    return state is AudioConfigurationStateSettingsFetched;
  }

  @override
  bool isErrorState(AudioConfigurationState state) {
    return state is AudioConfigurationStateError;
  }

  /// Gets audio enabled status from state
  bool? getAudioEnabled(AudioConfigurationState state) {
    if (state is AudioConfigurationStateSettingsFetched) {
      return state.isEnabled;
    }
    return null;
  }

  /// Gets volume from state
  int? getVolume(AudioConfigurationState state) {
    if (state is AudioConfigurationStateSettingsFetched) {
      return state.volume;
    }
    return null;
  }
}
