import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesla_android/common/utils/logger.dart';
import 'package:tesla_android/feature/home/cubit/ota_update_state.dart';
import 'package:tesla_android/feature/home/repository/github_release_repository.dart';

@injectable
class OTAUpdateCubit extends Cubit<OTAUpdateState> with Logger {
  static const String _lastCheckedKey = 'ota_last_checked';
  static const String _updateAvailableKey = 'ota_update_available';
  static const String _lastVersionKey = 'ota_last_version';

  final GitHubReleaseRepository _repository;
  final SharedPreferences _sharedPreferences;

  OTAUpdateCubit(
      this._repository,
      this._sharedPreferences,
      ) : super(OTAUpdateStateInitial());

  Future<void> checkForUpdates() async {
    final lastCheckedTimestamp = _sharedPreferences.getInt(_lastCheckedKey) ?? 0;
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    final packageInfo = await PackageInfo.fromPlatform();
    final storedVersion = _sharedPreferences.getString(_lastVersionKey) ?? '';

    if (currentTime - lastCheckedTimestamp < 6 * 60 * 60 * 1000 && storedVersion == packageInfo.version) {
      if (_sharedPreferences.getBool(_updateAvailableKey) == true) {
        emit(OTAUpdateStateAvailable());
      } else {
        emit(OTAUpdateStateNotAvailable());
      }
      return;
    }

    try {
      final latestVersion = await _repository.getLatestRelease();
      final areUpdatesAvailable =
      _checkIfUpdateIsAvailable(packageInfo.version, latestVersion.name);

      _sharedPreferences.setBool(_updateAvailableKey, areUpdatesAvailable);
      _sharedPreferences.setInt(_lastCheckedKey, currentTime);
      _sharedPreferences.setString(_lastVersionKey, packageInfo.version);

      if (areUpdatesAvailable) {
        emit(OTAUpdateStateAvailable());
      } else {
        emit(OTAUpdateStateNotAvailable());
      }
    } catch (exception, stacktrace) {
      logException(
        exception: exception,
        stackTrace: stacktrace,
      );
      await Future.delayed(const Duration(minutes: 5), () {
        checkForUpdates();
      });
    }
  }

  void launchUpdater() {
     _repository.openUpdater();
  }

  bool _checkIfUpdateIsAvailable(String currentVersion, String latestRelease) {
    List<String> currentVersionParts = currentVersion.split('.');
    List<String> latestVersionParts = latestRelease.split('.');

    if (currentVersionParts.length < 3 || latestVersionParts.length < 3) {
      throw const FormatException('Invalid version format');
    }

    int maxLength = max(currentVersionParts.length, latestVersionParts.length);
    for (int i = 0; i < maxLength; i++) {
      int currentValue = (i < currentVersionParts.length)
          ? int.tryParse(currentVersionParts[i]) ?? 0
          : 0;
      int latestValue = (i < latestVersionParts.length)
          ? int.tryParse(latestVersionParts[i]) ?? 0
          : 0;

      if (latestValue > currentValue) {
        return true;
      } else if (latestValue < currentValue) {
        return false;
      }
    }

    return false;
  }
}
