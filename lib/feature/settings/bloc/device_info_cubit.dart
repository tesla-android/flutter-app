import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/utils/logger.dart';
import 'package:tesla_android/feature/settings/bloc/device_info_state.dart';
import 'package:tesla_android/feature/settings/repository/device_info_repository.dart';

@injectable
class DeviceInfoCubit extends Cubit<DeviceInfoState>
    with Logger {
  final DeviceInfoRepository _repository;

  DeviceInfoCubit(this._repository)
      : super(DeviceInfoStateInitial());

  void fetchConfiguration() async {
    if (!isClosed) emit(DeviceInfoStateLoading());
    try {
      final healthState = await _repository.getDeviceInfo();
      emit(
        DeviceInfoStateLoaded(
            healthState: healthState),
      );
    } catch (exception, stacktrace) {
      logException(
        exception: exception,
        stackTrace: stacktrace,
      );
      if (!isClosed) {
        emit(
          DeviceInfoStateError(),
        );
      }
    }
  }
}
