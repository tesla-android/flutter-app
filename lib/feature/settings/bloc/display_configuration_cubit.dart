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
    if (!isClosed) emit(DisplayConfigurationStateLoading());
    try {
      _currentConfig = await _repository.getDisplayState();
      _emitCurrentConfig();
    } catch (exception, stacktrace) {
      logException(exception: exception, stackTrace: stacktrace);
      if (!isClosed) {
        emit(DisplayConfigurationStateError());
      }
    }
  }

  void setResponsiveness(bool newSetting) async {
    var config = _currentConfig;
    final isResponsive = newSetting ? 1 : 0;
    if (config != null) {
      config = config.copyWith(isResponsive: isResponsive);
      if (!isClosed) emit(DisplayConfigurationStateSettingsUpdateInProgress());
      try {
        await _repository.updateDisplayConfiguration(config);
        _currentConfig = _currentConfig?.copyWith(isResponsive: isResponsive);
        _emitCurrentConfig();
      } catch (exception, stackTrace) {
        logException(exception: exception, stackTrace: stackTrace);
        if (!isClosed) emit(DisplayConfigurationStateError());
      }
    } else {
      log("_currentConfig not available");
    }
  }

  void setResolution(DisplayResolutionModePreset newPreset) async {
    var config = _currentConfig;
    if (config != null) {
      config = config.updateResolution(newPreset: newPreset);
      if (!isClosed) emit(DisplayConfigurationStateSettingsUpdateInProgress());
      try {
        await _repository.updateDisplayConfiguration(config);
        _currentConfig = _currentConfig?.copyWith(resolutionPreset: newPreset);
        _emitCurrentConfig();
      } catch (exception, stackTrace) {
        logException(exception: exception, stackTrace: stackTrace);
        if (!isClosed) emit(DisplayConfigurationStateError());
      }
    } else {
      log("_currentConfig not available");
    }
  }

  void setRenderer(DisplayRendererType newType) async {
    var config = _currentConfig;
    if (config != null) {
      config = config.updateRenderer(newType: newType);
      if (!isClosed) emit(DisplayConfigurationStateSettingsUpdateInProgress());
      try {
        await _repository.updateDisplayConfiguration(config);
        _currentConfig = _currentConfig?.copyWith(renderer: newType);
        _emitCurrentConfig();
      } catch (exception, stackTrace) {
        logException(exception: exception, stackTrace: stackTrace);
        if (!isClosed) emit(DisplayConfigurationStateError());
      }
    } else {
      log("_currentConfig not available");
    }
  }

  void setQuality(DisplayQualityPreset newQuality) async {
    var config = _currentConfig;
    if (config != null) {
      config = config.updateQuality(newQuality: newQuality);
      if (!isClosed) emit(DisplayConfigurationStateSettingsUpdateInProgress());
      try {
        await _repository.updateDisplayConfiguration(config);
        _currentConfig = _currentConfig?.copyWith(quality: newQuality);
        _emitCurrentConfig();
      } catch (exception, stackTrace) {
        logException(exception: exception, stackTrace: stackTrace);
        if (!isClosed) emit(DisplayConfigurationStateError());
      }
    } else {
      log("_currentConfig not available");
    }
  }

  void setRefreshRate(DisplayRefreshRatePreset newRefreshRate) async {
    var config = _currentConfig;
    if (config != null) {
      config = config.updateRefreshRate(newRefreshRate: newRefreshRate);
      if (!isClosed) emit(DisplayConfigurationStateSettingsUpdateInProgress());
      try {
        await _repository.updateDisplayConfiguration(config);
        _currentConfig = _currentConfig?.copyWith(refreshRate: newRefreshRate);
        _emitCurrentConfig();
      } catch (exception, stackTrace) {
        logException(exception: exception, stackTrace: stackTrace);
        if (!isClosed) emit(DisplayConfigurationStateError());
      }
    } else {
      log("_currentConfig not available");
    }
  }

  void _emitCurrentConfig() {
    if (!isClosed) {
      emit(
        DisplayConfigurationStateSettingsFetched(
          resolutionPreset: _currentConfig!.resolutionPreset,
          renderer: _currentConfig!.renderer,
          isResponsive: _currentConfig!.isResponsive == 1,
          refreshRate: _currentConfig!.refreshRate,
          quality: _currentConfig!.quality,
        ),
      );
    }
  }
}
