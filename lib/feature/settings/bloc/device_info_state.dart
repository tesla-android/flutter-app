import 'package:tesla_android/feature/connectivityCheck/model/health_state.dart';

abstract class DeviceInfoState {}

class DeviceInfoStateInitial extends DeviceInfoState {}

class DeviceInfoStateLoading extends DeviceInfoState {}

class DeviceInfoStateLoaded
    extends DeviceInfoState {
  final HealthState healthState;

  DeviceInfoStateLoaded({
    required this.healthState,
  });
}
class DeviceInfoStateError extends DeviceInfoState {}
