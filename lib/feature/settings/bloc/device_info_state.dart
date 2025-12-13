import 'package:tesla_android/feature/settings/model/device_info.dart';

abstract class DeviceInfoState {}

class DeviceInfoStateInitial extends DeviceInfoState {}

class DeviceInfoStateLoading extends DeviceInfoState {}

class DeviceInfoStateLoaded extends DeviceInfoState {
  final DeviceInfo deviceInfo;

  DeviceInfoStateLoaded({required this.deviceInfo});
}

class DeviceInfoStateError extends DeviceInfoState {}
