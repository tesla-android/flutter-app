import 'package:dio/dio.dart' hide Headers;
import 'package:flavor/flavor.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tesla_android/feature/settings/model/device_info.dart';

part 'device_info_service.g.dart';

@injectable
@RestApi()
abstract class DeviceInfoService {
  @factoryMethod
  factory DeviceInfoService(
      Dio dio,
      Flavor flavor,
      ) =>
      _DeviceInfoService(
        dio,
        baseUrl: flavor.getString("configurationApiBaseUrl"),
      );

  @GET("/deviceInfo")
  @DioResponseType(ResponseType.json)
  Future<DeviceInfo> getDeviceInfo();

  @GET("/openUpdater")
  Future openUpdater();
}
