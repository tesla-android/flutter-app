import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/utils/logger.dart';
import 'package:tesla_android/feature/display/model/remote_display_state.dart';
import 'package:tesla_android/feature/display/repository/display_repository.dart';
import 'package:tesla_android/feature/settings/bloc/rear_display_configuration_state.dart';

@injectable
class RearDisplayConfigurationCubit extends Cubit<RearDisplayConfigurationState>
    with Logger {
  final DisplayRepository _repository;

  RemoteDisplayState? _currentConfig;

  RearDisplayConfigurationCubit(this._repository)
    : super(RearDisplayConfigurationStateInitial());

  void fetchConfiguration() async {
    if (!isClosed) emit(RearDisplayConfigurationStateLoading());
    try {
      _currentConfig = await _repository.getDisplayState();
      _emitCurrentConfig();
    } catch (exception, stacktrace) {
      logException(exception: exception, stackTrace: stacktrace);
      if (!isClosed) {
        emit(RearDisplayConfigurationStateError());
      }
    }
  }

  void setRearDisplayState(bool newSetting) async {
    var config = _currentConfig;
    final isRearDisplayEnabled = newSetting ? 1 : 0;
    if (config != null) {
      config = config.copyWith(isRearDisplayEnabled: isRearDisplayEnabled);
      if (!isClosed) {
        emit(RearDisplayConfigurationStateSettingsUpdateInProgress());
      }
      try {
        await _repository.updateDisplayConfiguration(config);
        _currentConfig = _currentConfig?.copyWith(
          isRearDisplayEnabled: isRearDisplayEnabled,
        );
        _emitCurrentConfig();
      } catch (exception, stackTrace) {
        logException(exception: exception, stackTrace: stackTrace);
        if (!isClosed) emit(RearDisplayConfigurationStateError());
      }
    } else {
      log("_currentConfig not available");
    }
  }

  void setRearDisplayPrioritization(bool newSetting) async {
    var config = _currentConfig;
    final isRearDisplayPrioritised = newSetting ? 1 : 0;
    if (config != null) {
      config = config.copyWith(
        isRearDisplayPrioritised: isRearDisplayPrioritised,
      );
      if (!isClosed) {
        emit(RearDisplayConfigurationStateSettingsUpdateInProgress());
      }
      try {
        await _repository.updateDisplayConfiguration(config);
        _currentConfig = _currentConfig?.copyWith(
          isRearDisplayPrioritised: isRearDisplayPrioritised,
        );
        _emitCurrentConfig();
      } catch (exception, stackTrace) {
        logException(exception: exception, stackTrace: stackTrace);
        if (!isClosed) emit(RearDisplayConfigurationStateError());
      }
    } else {
      log("_currentConfig not available");
    }
  }

  void setDisplayType({required bool isCurrentDisplayPrimary}) {
    _repository.setDisplayType(isCurrentDisplayPrimary);
    _emitCurrentConfig();
  }

  void _emitCurrentConfig() async {
    if (isClosed) return;
    final isCurrentDisplayPrimary = await _repository.isPrimaryDisplay();
    if (!isClosed) {
      emit(
        RearDisplayConfigurationStateSettingsFetched(
          isRearDisplayEnabled: _currentConfig!.isRearDisplayEnabled == 1,
          isRearDisplayPrioritised:
              _currentConfig!.isRearDisplayPrioritised == 1,
          isCurrentDisplayPrimary: isCurrentDisplayPrimary ?? true,
        ),
      );
    }
  }
}
