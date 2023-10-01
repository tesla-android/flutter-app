import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/network/device_info_service.dart';
import 'package:tesla_android/common/network/github_service.dart';
import 'package:tesla_android/feature/home/model/github_release.dart';

@injectable
class GitHubReleaseRepository {
  final GitHubService _service;
  final DeviceInfoService _deviceInfoService;

  GitHubReleaseRepository(
    this._service,
    this._deviceInfoService,
  );

  Future<GitHubRelease> getLatestRelease() {
    return _service.getLatestRelease();
  }

  Future openUpdater() {
    return _deviceInfoService.openUpdater();
  }
}
