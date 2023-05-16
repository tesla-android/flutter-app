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
  factory ConfigurationService(
    Dio dio,
    Flavor flavor,
  ) =>
      _ConfigurationService(
        dio,
        baseUrl: flavor.getString("configurationApiBaseUrl"),
      );

  @GET("/configuration")
  @DioResponseType(ResponseType.json)
  Future<SystemConfigurationResponseBody> getConfiguration();

  @POST("/softApBand")
  @Headers({
    "Content-Type": "text/plain",
  })
  Future setSoftApBand(@Body() int band);

  @POST("/softApChannel")
  @Headers({
    "Content-Type": "text/plain",
  })
  Future setSoftApChannel(@Body() int channel);

  @POST("/softApChannelWidth")
  @Headers({
    "Content-Type": "text/plain",
  })
  Future setSoftApChannelWidth(@Body() int channelWidth);

  @POST("/softApState")
  @Headers({
    "Content-Type": "text/plain",
  })
  Future setSoftApState(@Body() int isEnabledFlag);
}
