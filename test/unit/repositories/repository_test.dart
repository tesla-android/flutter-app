import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tesla_android/feature/home/model/github_release.dart';
import 'package:tesla_android/feature/home/repository/github_release_repository.dart';
import 'package:tesla_android/feature/releaseNotes/repository/release_notes_repository.dart';
import 'package:tesla_android/feature/settings/model/device_info.dart';
import 'package:tesla_android/feature/settings/repository/device_info_repository.dart';

import '../../helpers/mock_services.mocks.dart';

void main() {
  group('Repository Tests', () {
    group('GitHubReleaseRepository', () {
      late MockGitHubService mockService;
      late MockDeviceInfoService mockDeviceInfoService;
      late GitHubReleaseRepository repository;

      setUp(() {
        mockService = MockGitHubService();
        mockDeviceInfoService = MockDeviceInfoService();
        repository = GitHubReleaseRepository(
          mockService,
          mockDeviceInfoService,
        );
      });

      test('getLatestRelease calls service', () async {
        const release = GitHubRelease(name: 'v1.0.0');
        when(mockService.getLatestRelease()).thenAnswer((_) async => release);

        final result = await repository.getLatestRelease();

        expect(result, release);
        verify(mockService.getLatestRelease()).called(1);
      });

      test('openUpdater calls device info service', () async {
        when(mockDeviceInfoService.openUpdater()).thenAnswer((_) async {});

        await repository.openUpdater();

        verify(mockDeviceInfoService.openUpdater()).called(1);
      });
    });

    group('DeviceInfoRepository', () {
      late MockDeviceInfoService mockService;
      late DeviceInfoRepository repository;

      setUp(() {
        mockService = MockDeviceInfoService();
        repository = DeviceInfoRepository(mockService);
      });

      test('getDeviceInfo calls service', () async {
        const info = DeviceInfo(
          cpuTemperature: 50,
          serialNumber: '123',
          deviceModel: 'Pi4',
          isCarPlayDetected: 1,
          isModemDetected: 1,
          releaseType: 'stable',
          otaUrl: 'http://ota.url',
          isGPSEnabled: 1,
        );
        when(mockService.getDeviceInfo()).thenAnswer((_) async => info);

        final result = await repository.getDeviceInfo();

        expect(result, info);
        verify(mockService.getDeviceInfo()).called(1);
      });
    });

    group('ReleaseNotesRepository', () {
      late ReleaseNotesRepository repository;

      setUp(() {
        repository = ReleaseNotesRepository();
      });

      test('getReleaseNotes returns non-empty notes', () async {
        final notes = await repository.getReleaseNotes();
        expect(notes.versions, isNotEmpty);
      });
    });
  });
}
