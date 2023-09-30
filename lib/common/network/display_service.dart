import 'package:dio/dio.dart' hide Headers;
import 'package:flavor/flavor.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tesla_android/feature/display/model/remote_display_state.dart';

part 'display_service.g.dart';

@injectable
@RestApi()
abstract class DisplayService {
  @factoryMethod
  factory DisplayService(
      Dio dio,
      Flavor flavor,
      ) =>
      _DisplayService(
        dio,
        baseUrl: flavor.getString("configurationApiBaseUrl"),
      );

  @GET("/displayState")
  @DioResponseType(ResponseType.json)
  Future<RemoteDisplayState> getDisplayState();

  @POST("/displayState")
  @Headers({
    "Content-Type": "application/json",
  })
  Future updateDisplayConfiguration(@Body() RemoteDisplayState configuration);
}
