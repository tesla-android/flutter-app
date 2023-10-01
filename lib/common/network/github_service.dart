import 'package:dio/dio.dart' hide Headers;
import 'package:flavor/flavor.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tesla_android/feature/home/model/github_release.dart';

part 'github_service.g.dart';

@injectable
@RestApi()
abstract class GitHubService {
  @factoryMethod
  factory GitHubService(
    Dio dio,
    Flavor flavor,
  ) =>
      _GitHubService(
        dio,
        baseUrl: "https://api.github.com",
      );

  @GET("/repos/tesla-android/android-raspberry-pi/releases/latest")
  @Headers({
    "X-GitHub-Api-Version": "2022-11-28",
  })  Future<GitHubRelease> getLatestRelease();
}
