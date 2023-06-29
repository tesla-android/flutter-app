import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/utils/logger.dart';
import 'package:tesla_android/feature/display/model/remote_display_state.dart';
import 'package:tesla_android/feature/display/repository/display_repository.dart';
import 'package:tesla_android/feature/settings/bloc/display_configuration_state.dart';

@injectable
class DisplayConfigurationCubit extends Cubit<DisplayConfigurationState>
    with Logger {
  final DisplayRepository _repository;

  RemoteDisplayState? _currentConfig;

  DisplayConfigurationCubit(this._repository)
      : super(DisplayConfigurationStateInitial());

  void fetchConfiguration() async {
    emit(DisplayConfigurationStateLoading());
    try {
      _currentConfig = await _repository.getDisplayState();
      emit(
        DisplayConfigurationStateSettingsFetched(
          lowResModePreset: _currentConfig!.lowRes,
          renderer: _currentConfig!.renderer,
        ),
      );
    } catch (exception, stacktrace) {
      logException(
        exception: exception,
        stackTrace: stacktrace,
      );
      emit(
        DisplayConfigurationStateError(),
      );
    }
  }

  void setLowResMode(DisplayLowResModePreset newPreset) async {
    var config = _currentConfig;
    if (config != null) {
      config = config.updateLowRes(newPreset: newPreset);
      emit(DisplayConfigurationStateSettingsUpdateInProgress());
      try {
        await _repository.updateDisplayConfiguration(config);
        emit(DisplayConfigurationStateSettingsFetched(
          lowResModePreset: newPreset,
          renderer: _currentConfig!.renderer,
        ));
      } catch (exception, stackTrace) {
        logExceptionAndUploadToSentry(
            exception: exception, stackTrace: stackTrace);
        emit(DisplayConfigurationStateError());
      }
    } else {
      log("_currentConfig not available");
    }
  }

  void setRenderer(DisplayRendererType newType) async {
    var config = _currentConfig;
    if (config != null) {
      config = config.updateRenderer(newType: newType);
      emit(DisplayConfigurationStateSettingsUpdateInProgress());
      try {
        await _repository.updateDisplayConfiguration(config);
        emit(DisplayConfigurationStateSettingsFetched(
          lowResModePreset: _currentConfig!.lowRes,
          renderer: newType,
        ));
      } catch (exception, stackTrace) {
        logExceptionAndUploadToSentry(
            exception: exception, stackTrace: stackTrace);
        emit(DisplayConfigurationStateError());
      }
    } else {
      log("_currentConfig not available");
    }
  }
}
