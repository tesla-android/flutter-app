import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/utils/logger.dart';
import 'package:tesla_android/feature/settings/bloc/audio_configuration_state.dart';
import 'package:tesla_android/feature/settings/repository/system_configuration_repository.dart';

@injectable
class AudioConfigurationCubit extends Cubit<AudioConfigurationState>
    with Logger {
  final SystemConfigurationRepository _repository;

  AudioConfigurationCubit(this._repository)
      : super(AudioConfigurationStateInitial());

  void fetchConfiguration() async {
    if (!isClosed) emit(AudioConfigurationStateLoading());
    try {
      final configuration = await _repository.getConfiguration();
      emit(
        AudioConfigurationStateSettingsFetched(
            isEnabled: configuration.browserAudioIsEnabled == 1,
            volume: configuration.browserAudioVolume),
      );
    } catch (exception, stacktrace) {
      logException(
        exception: exception,
        stackTrace: stacktrace,
      );
      if (!isClosed) {
        emit(
          AudioConfigurationStateError(),
        );
      }
    }
  }

  void setVolume(int newVolume) async {
    if (!isClosed) emit(AudioConfigurationStateSettingsUpdateInProgress());
    try {
      await _repository.setBrowserAudioState(1);
      await _repository.setBrowserAudioVolume(newVolume);
      if (!isClosed) {
        emit(
          AudioConfigurationStateSettingsFetched(
              isEnabled: true, volume: newVolume),
        );
        dispatchAnalyticsEvent(
          eventName: "audio_configuration_volume",
          props: {
            "volume": newVolume,
          },
        );
      }
    } catch (exception, stackTrace) {
      logExceptionAndUploadToSentry(
          exception: exception, stackTrace: stackTrace);
      if (!isClosed) emit(AudioConfigurationStateError());
    }
  }

  void setState(bool isEnabled) async {
    if (!isClosed) emit(AudioConfigurationStateSettingsUpdateInProgress());
    try {
      await _repository.setBrowserAudioState(isEnabled ? 1 : 0);
      await _repository.setBrowserAudioVolume(100);
      if (!isClosed) {
        dispatchAnalyticsEvent(
          eventName: "audio_configuration_state",
          props: {
            "isEnabled": isEnabled,
          },
        );
        emit(
          AudioConfigurationStateSettingsFetched(
              isEnabled: isEnabled, volume: 100),
        );
      }
    } catch (exception, stackTrace) {
      logExceptionAndUploadToSentry(
          exception: exception, stackTrace: stackTrace);
      if (!isClosed) emit(AudioConfigurationStateError());
    }
  }
}
