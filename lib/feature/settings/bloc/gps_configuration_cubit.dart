import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/utils/logger.dart';
import 'package:tesla_android/feature/settings/bloc/gps_configuration_state.dart';
import 'package:tesla_android/feature/settings/repository/system_configuration_repository.dart';

@injectable
class GPSConfigurationCubit extends Cubit<GPSConfigurationState> with Logger {
  final SystemConfigurationRepository _configurationRepository;

  GPSConfigurationCubit(this._configurationRepository)
    : super(GPSConfigurationStateInitial());

  Future fetchConfiguration() async {
    if (!isClosed) emit(GPSConfigurationStateLoading());
    try {
      final configuration = await _configurationRepository.getConfiguration();
      emit(
        GPSConfigurationStateLoaded(
          isGPSEnabled: configuration.isGPSEnabled == 1,
        ),
      );
    } catch (exception, stacktrace) {
      logException(exception: exception, stackTrace: stacktrace);
      if (!isClosed) {
        emit(GPSConfigurationStateError());
      }
    }
  }

  void setState(bool newState) async {
    emit(GPSConfigurationStateUpdateInProgress(isGPSEnabled: newState));
    try {
      await _configurationRepository.setGPSState(newState == true ? 1 : 0);
      emit(GPSConfigurationStateLoaded(isGPSEnabled: newState));
    } catch (exception, stacktrace) {
      logException(exception: exception, stackTrace: stacktrace);
      emit(GPSConfigurationStateError());
    }
  }
}
