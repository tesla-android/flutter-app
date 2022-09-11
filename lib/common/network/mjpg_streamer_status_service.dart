import 'package:dio/dio.dart';
import 'package:flavor/flavor.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'mjpg_streamer_status_service.g.dart';

@injectable
@RestApi()
abstract class MjpgStreamerStatusService {
  @factoryMethod
  factory MjpgStreamerStatusService(
    Dio dio,
    Flavor flavor,
  ) =>
      _MjpgStreamerStatusService(
        dio,
        baseUrl: flavor.getString("mjpgStreamerBaseUrl"),
      );

  @GET("/")
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> getAction(@Query("action") String action);
}
