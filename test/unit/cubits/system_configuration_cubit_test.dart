import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:tesla_android/feature/settings/bloc/system_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/system_configuration_state.dart';
import 'package:tesla_android/feature/settings/model/softap_band_type.dart';
import 'package:tesla_android/feature/settings/repository/system_configuration_repository.dart';

import '../../helpers/test_fixtures.dart';
import 'system_configuration_cubit_test.mocks.dart';

@GenerateMocks([SystemConfigurationRepository])
void main() {
  late MockSystemConfigurationRepository mockRepository;

  setUp(() {
    mockRepository = MockSystemConfigurationRepository();
  });

  group('SystemConfigurationCubit', () {
    test('initial state is SystemConfigurationStateInitial', () {
      final cubit = SystemConfigurationCubit(mockRepository);
      expect(cubit.state, isA<SystemConfigurationStateInitial>());
      cubit.close();
    });

    blocTest<SystemConfigurationCubit, SystemConfigurationState>(
      'fetchConfiguration emits Loading then SettingsFetched on success',
      build: () {
        when(
          mockRepository.getConfiguration(),
        ).thenAnswer((_) async => TestFixtures.systemConfiguration);
        return SystemConfigurationCubit(mockRepository);
      },
      act: (cubit) async => await cubit.fetchConfiguration(),
      expect: () => [
        isA<SystemConfigurationStateLoading>(),
        isA<SystemConfigurationStateSettingsFetched>(),
      ],
      verify: (cubit) {
        verify(mockRepository.getConfiguration()).called(1);
      },
    );

    blocTest<SystemConfigurationCubit, SystemConfigurationState>(
      'fetchConfiguration emits Error on failure',
      build: () {
        when(
          mockRepository.getConfiguration(),
        ).thenThrow(Exception('Network error'));
        return SystemConfigurationCubit(mockRepository);
      },
      act: (cubit) async => await cubit.fetchConfiguration(),
      expect: () => [
        isA<SystemConfigurationStateLoading>(),
        isA<SystemConfigurationStateSettingsFetchingError>(),
      ],
    );

    group('Configuration update methods', () {
      // Parametrized test cases for configuration updates
      final testCases = [
        (
          name: 'updateSoftApBand',
          action: (SystemConfigurationCubit cubit) =>
              cubit.updateSoftApBand(SoftApBandType.band5GHz36),
          verify: (SystemConfigurationStateSettingsModified state) {
            expect(state.newBandType, SoftApBandType.band5GHz36);
          },
        ),
        (
          name: 'updateSoftApState',
          action: (SystemConfigurationCubit cubit) =>
              cubit.updateSoftApState(false),
          verify: (SystemConfigurationStateSettingsModified state) {
            expect(state.isSoftApEnabled, false);
          },
        ),
        (
          name: 'updateOfflineModeState',
          action: (SystemConfigurationCubit cubit) =>
              cubit.updateOfflineModeState(true),
          verify: (SystemConfigurationStateSettingsModified state) {
            expect(state.isOfflineModeEnabled, true);
          },
        ),
        (
          name: 'updateOfflineModeTelemetryState',
          action: (SystemConfigurationCubit cubit) =>
              cubit.updateOfflineModeTelemetryState(false),
          verify: (SystemConfigurationStateSettingsModified state) {
            expect(state.isOfflineModeTelemetryEnabled, false);
          },
        ),
        (
          name: 'updateOfflineModeTeslaFirmwareDownloadsState',
          action: (SystemConfigurationCubit cubit) =>
              cubit.updateOfflineModeTeslaFirmwareDownloadsState(true),
          verify: (SystemConfigurationStateSettingsModified state) {
            expect(state.isOfflineModeTeslaFirmwareDownloadsEnabled, true);
          },
        ),
      ];

      for (final testCase in testCases) {
        blocTest<SystemConfigurationCubit, SystemConfigurationState>(
          '${testCase.name} updates state correctly',
          build: () => SystemConfigurationCubit(mockRepository),
          seed: () => SystemConfigurationStateSettingsFetched(
            currentConfiguration: TestFixtures.systemConfiguration,
          ),
          act: testCase.action,
          expect: () => [isA<SystemConfigurationStateSettingsModified>()],
          verify: (cubit) {
            final state =
                cubit.state as SystemConfigurationStateSettingsModified;
            testCase.verify(state);
          },
        );
      }
    });

    blocTest<SystemConfigurationCubit, SystemConfigurationState>(
      'applySystemConfiguration calls repository methods',
      build: () {
        when(mockRepository.setSoftApBand(any)).thenAnswer((_) async => {});
        when(
          mockRepository.setSoftApChannelWidth(any),
        ).thenAnswer((_) async => {});
        when(mockRepository.setSoftApChannel(any)).thenAnswer((_) async => {});
        when(mockRepository.setSoftApState(any)).thenAnswer((_) async => {});
        when(
          mockRepository.setOfflineModeState(any),
        ).thenAnswer((_) async => {});
        when(
          mockRepository.setOfflineModeTelemetryState(any),
        ).thenAnswer((_) async => {});
        when(
          mockRepository.setOfflineModeTeslaFirmwareDownloads(any),
        ).thenAnswer((_) async => {});
        return SystemConfigurationCubit(mockRepository);
      },
      seed: () =>
          SystemConfigurationStateSettingsModified.fromCurrentConfiguration(
            currentConfiguration: TestFixtures.systemConfiguration,
            newBandType: SoftApBandType.band5GHz36,
            isSoftApEnabled: true,
            isOfflineModeEnabled: false,
          ),
      act: (cubit) => cubit.applySystemConfiguration(),
      verify: (cubit) {
        verify(mockRepository.setSoftApBand(any)).called(1);
        verify(mockRepository.setSoftApChannelWidth(any)).called(1);
        verify(mockRepository.setSoftApChannel(any)).called(1);
        verify(mockRepository.setSoftApState(any)).called(1);
        verify(mockRepository.setOfflineModeState(any)).called(1);
      },
    );

    blocTest<SystemConfigurationCubit, SystemConfigurationState>(
      'applySystemConfiguration emits Error on failure',
      build: () {
        when(
          mockRepository.setSoftApBand(any),
        ).thenThrow(Exception('Network error'));
        return SystemConfigurationCubit(mockRepository);
      },
      seed: () =>
          SystemConfigurationStateSettingsModified.fromCurrentConfiguration(
            currentConfiguration: TestFixtures.systemConfiguration,
            newBandType: SoftApBandType.band5GHz36,
          ),
      act: (cubit) => cubit.applySystemConfiguration(),
      expect: () => [isA<SystemConfigurationStateSettingsSavingFailedError>()],
    );

    test('close cancels properly', () async {
      final cubit = SystemConfigurationCubit(mockRepository);
      await cubit.close();
      expect(cubit.isClosed, true);
    });
  });
}
