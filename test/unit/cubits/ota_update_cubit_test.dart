import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tesla_android/feature/home/cubit/ota_update_cubit.dart';
import 'package:tesla_android/feature/home/cubit/ota_update_state.dart';
import 'package:tesla_android/feature/home/model/github_release.dart';
import 'package:tesla_android/feature/home/repository/github_release_repository.dart';

import 'ota_update_cubit_test.mocks.dart';

@GenerateMocks([GitHubReleaseRepository])
void main() {
  late MockGitHubReleaseRepository mockRepository;
  late SharedPreferences sharedPreferences;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    PackageInfo.setMockInitialValues(
      appName: 'Tesla Android',
      packageName: 'com.teslaandroid',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  setUp(() async {
    mockRepository = MockGitHubReleaseRepository();
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
  });

  tearDown(() async {
    await sharedPreferences.clear();
  });

  group('OTAUpdateCubit', () {
    test('initial state is OTAUpdateStateInitial', () {
      final cubit = OTAUpdateCubit(mockRepository, sharedPreferences);
      expect(cubit.state, isA<OTAUpdateStateInitial>());
      cubit.close();
    });

    blocTest<OTAUpdateCubit, OTAUpdateState>(
      'checkForUpdates emits Available when newer version exists',
      build: () {
        when(
          mockRepository.getLatestRelease(),
        ).thenAnswer((_) async => const GitHubRelease(name: '2.0.0'));
        return OTAUpdateCubit(mockRepository, sharedPreferences);
      },
      act: (cubit) async => await cubit.checkForUpdates(),
      expect: () => [isA<OTAUpdateStateAvailable>()],
      verify: (cubit) {
        verify(mockRepository.getLatestRelease()).called(1);
        expect(sharedPreferences.getBool('ota_update_available'), true);
      },
    );

    blocTest<OTAUpdateCubit, OTAUpdateState>(
      'checkForUpdates emits NotAvailable when no newer version',
      build: () {
        when(
          mockRepository.getLatestRelease(),
        ).thenAnswer((_) async => const GitHubRelease(name: '0.1.0'));
        return OTAUpdateCubit(mockRepository, sharedPreferences);
      },
      act: (cubit) async => await cubit.checkForUpdates(),
      expect: () => [isA<OTAUpdateStateNotAvailable>()],
      verify: (cubit) {
        verify(mockRepository.getLatestRelease()).called(1);
        expect(sharedPreferences.getBool('ota_update_available'), false);
      },
    );

    blocTest<OTAUpdateCubit, OTAUpdateState>(
      'checkForUpdates uses cached result when within 6 hours',
      build: () {
        final now = DateTime.now().millisecondsSinceEpoch;
        sharedPreferences.setInt('ota_last_checked', now);
        sharedPreferences.setBool('ota_update_available', true);
        sharedPreferences.setString('ota_last_version', '1.0.0');
        return OTAUpdateCubit(mockRepository, sharedPreferences);
      },
      act: (cubit) async => await cubit.checkForUpdates(),
      expect: () => [isA<OTAUpdateStateAvailable>()],
      verify: (cubit) {
        verifyNever(mockRepository.getLatestRelease());
      },
    );

    blocTest<OTAUpdateCubit, OTAUpdateState>(
      'checkForUpdates rechecks when cache is stale (>6 hours)',
      build: () {
        final sixHoursAgo =
            DateTime.now().millisecondsSinceEpoch - (7 * 60 * 60 * 1000);
        sharedPreferences.setInt('ota_last_checked', sixHoursAgo);
        sharedPreferences.setBool('ota_update_available', false);
        when(
          mockRepository.getLatestRelease(),
        ).thenAnswer((_) async => const GitHubRelease(name: '2.0.0'));
        return OTAUpdateCubit(mockRepository, sharedPreferences);
      },
      act: (cubit) async => await cubit.checkForUpdates(),
      expect: () => [isA<OTAUpdateStateAvailable>()],
      verify: (cubit) {
        verify(mockRepository.getLatestRelease()).called(1);
      },
    );

    test('launchUpdater calls repository openUpdater', () {
      when(mockRepository.openUpdater()).thenAnswer((_) async => {});
      final cubit = OTAUpdateCubit(mockRepository, sharedPreferences);

      cubit.launchUpdater();

      verify(mockRepository.openUpdater()).called(1);
      cubit.close();
    });

    group('version comparison', () {
      blocTest<OTAUpdateCubit, OTAUpdateState>(
        'detects newer major version',
        build: () {
          when(
            mockRepository.getLatestRelease(),
          ).thenAnswer((_) async => const GitHubRelease(name: '2.0.0'));
          return OTAUpdateCubit(mockRepository, sharedPreferences);
        },
        act: (cubit) async => await cubit.checkForUpdates(),
        expect: () => [isA<OTAUpdateStateAvailable>()],
        verify: (cubit) {
          verify(mockRepository.getLatestRelease()).called(1);
          expect(sharedPreferences.getBool('ota_update_available'), true);
          expect(sharedPreferences.getString('ota_last_version'), '1.0.0');
        },
      );

      blocTest<OTAUpdateCubit, OTAUpdateState>(
        'detects newer minor version',
        build: () {
          when(
            mockRepository.getLatestRelease(),
          ).thenAnswer((_) async => const GitHubRelease(name: '1.5.0'));
          return OTAUpdateCubit(mockRepository, sharedPreferences);
        },
        act: (cubit) async => await cubit.checkForUpdates(),
        expect: () => [isA<OTAUpdateStateAvailable>()],
        verify: (cubit) {
          verify(mockRepository.getLatestRelease()).called(1);
          expect(sharedPreferences.getBool('ota_update_available'), true);
        },
      );

      blocTest<OTAUpdateCubit, OTAUpdateState>(
        'detects newer patch version',
        build: () {
          when(
            mockRepository.getLatestRelease(),
          ).thenAnswer((_) async => const GitHubRelease(name: '1.0.5'));
          return OTAUpdateCubit(mockRepository, sharedPreferences);
        },
        act: (cubit) async => await cubit.checkForUpdates(),
        expect: () => [isA<OTAUpdateStateAvailable>()],
        verify: (cubit) {
          verify(mockRepository.getLatestRelease()).called(1);
          expect(sharedPreferences.getBool('ota_update_available'), true);
        },
      );
    });

    test('close cancels properly', () async {
      final cubit = OTAUpdateCubit(mockRepository, sharedPreferences);
      await cubit.close();
      expect(cubit.isClosed, true);
    });
  });
}
