import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/network/health_service.dart';
import 'package:tesla_android/feature/connectivityCheck/model/health_state.dart';

@injectable
class DeviceInfoRepository {
  final HealthService _service;

  DeviceInfoRepository(this._service);

  Future<HealthState> getDeviceInfo(){
    return _service.getHealthCheck();
  }
}