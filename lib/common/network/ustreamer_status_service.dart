import 'package:dio/dio.dart';
import 'package:flavor/flavor.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tesla_android/feature/androidViewer/display/model/ustreamer_state.dart';

part 'ustreamer_status_service.g.dart';

@injectable
@RestApi()
abstract class UstreamerStatusService {
  @factoryMethod
  factory UstreamerStatusService(
    Dio dio,
    Flavor flavor,
  ) =>
      _UstreamerStatusService(
        dio,
        baseUrl: flavor.getString("ustreamerBaseUrl"),
      );

  @GET("state")
  Future<UstreamerState> getState();
}
