import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/network/device_info_service.dart';
import 'package:tesla_android/feature/settings/model/device_info.dart';

@injectable
class DeviceInfoRepository {
  final DeviceInfoService _service;

  DeviceInfoRepository(this._service);

  Future<DeviceInfo> getDeviceInfo(){
    return _service.getDeviceInfo();
  }
}