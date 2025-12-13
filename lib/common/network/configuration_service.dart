import 'package:dio/dio.dart' hide Headers;
import 'package:flavor/flavor.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tesla_android/feature/settings/model/system_configuration_response_body.dart';

part 'configuration_service.g.dart';

@injectable
@RestApi()
abstract class ConfigurationService {
  @factoryMethod
  factory ConfigurationService(Dio dio, Flavor flavor) => _ConfigurationService(
    dio,
    baseUrl: flavor.getString("configurationApiBaseUrl"),
  );

  @GET("/configuration")
  @DioResponseType(ResponseType.json)
  Future<SystemConfigurationResponseBody> getConfiguration();

  @POST("/softApBand")
  @Headers({"Content-Type": "text/plain"})
  Future setSoftApBand(@Body() int band);

  @POST("/softApChannel")
  @Headers({"Content-Type": "text/plain"})
  Future setSoftApChannel(@Body() int channel);

  @POST("/softApChannelWidth")
  @Headers({"Content-Type": "text/plain"})
  Future setSoftApChannelWidth(@Body() int channelWidth);

  @POST("/softApState")
  @Headers({"Content-Type": "text/plain"})
  Future setSoftApState(@Body() int isEnabledFlag);

  @POST("/offlineModeState")
  @Headers({"Content-Type": "text/plain"})
  Future setOfflineModeState(@Body() int isEnabledFlag);

  @POST("/offlineModeTelemetryState")
  @Headers({"Content-Type": "text/plain"})
  Future setOfflineModeTelemetryState(@Body() int isEnabledFlag);

  @POST("/offlineModeTeslaFirmwareDownloads")
  @Headers({"Content-Type": "text/plain"})
  Future setOfflineModeTeslaFirmwareDownloads(@Body() int isEnabledFlag);

  @POST("/browserAudioState")
  @Headers({"Content-Type": "text/plain"})
  Future setBrowserAudioState(@Body() int isEnabledFlag);

  @POST("/browserAudioVolume")
  @Headers({"Content-Type": "text/plain"})
  Future setBrowserAudioVolume(@Body() int volume);

  @POST("/gpsState")
  @Headers({"Content-Type": "text/plain"})
  Future setGPSState(@Body() int state);
}
