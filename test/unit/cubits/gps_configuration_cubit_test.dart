import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tesla_android/feature/settings/bloc/gps_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/gps_configuration_state.dart';
import 'package:tesla_android/feature/settings/repository/system_configuration_repository.dart';
import '../../helpers/test_fixtures.dart';

import 'gps_configuration_cubit_test.mocks.dart';

@GenerateMocks([SystemConfigurationRepository])
void main() {
  late MockSystemConfigurationRepository mockRepository;

  setUp(() {
    mockRepository = MockSystemConfigurationRepository();
  });

  group('GPSConfigurationCubit', () {
    test('initial state is GPSConfigurationStateInitial', () {
      final cubit = GPSConfigurationCubit(mockRepository);
      expect(cubit.state, isA<GPSConfigurationStateInitial>());
      cubit.close();
    });

    blocTest<GPSConfigurationCubit, GPSConfigurationState>(
      'fetchConfiguration emits loaded state with GPS enabled',
      build: () {
        final config = TestFixtures.defaultConfiguration.copyWith(
          isGPSEnabled: 1,
        );
        when(mockRepository.getConfiguration()).thenAnswer((_) async => config);
        return GPSConfigurationCubit(mockRepository);
      },
      act: (cubit) => cubit.fetchConfiguration(),
      expect: () => [
        isA<GPSConfigurationStateLoading>(),
        isA<GPSConfigurationStateLoaded>().having(
          (s) => s.isGPSEnabled,
          'isGPSEnabled',
          true,
        ),
      ],
    );

    blocTest<GPSConfigurationCubit, GPSConfigurationState>(
      'fetchConfiguration emits loaded state with GPS disabled',
      build: () {
        final config = TestFixtures.defaultConfiguration.copyWith(
          isGPSEnabled: 0,
        );
        when(mockRepository.getConfiguration()).thenAnswer((_) async => config);
        return GPSConfigurationCubit(mockRepository);
      },
      act: (cubit) => cubit.fetchConfiguration(),
      expect: () => [
        isA<GPSConfigurationStateLoading>(),
        isA<GPSConfigurationStateLoaded>().having(
          (s) => s.isGPSEnabled,
          'isGPSEnabled',
          false,
        ),
      ],
    );

    blocTest<GPSConfigurationCubit, GPSConfigurationState>(
      'fetchConfiguration emits error state on failure',
      build: () {
        when(
          mockRepository.getConfiguration(),
        ).thenThrow(Exception('Network error'));
        return GPSConfigurationCubit(mockRepository);
      },
      act: (cubit) => cubit.fetchConfiguration(),
      expect: () => [
        isA<GPSConfigurationStateLoading>(),
        isA<GPSConfigurationStateError>(),
      ],
    );

    blocTest<GPSConfigurationCubit, GPSConfigurationState>(
      'setState enables GPS successfully',
      build: () {
        when(mockRepository.setGPSState(1)).thenAnswer((_) async => {});
        return GPSConfigurationCubit(mockRepository);
      },
      act: (cubit) => cubit.setState(true),
      expect: () => [
        isA<GPSConfigurationStateUpdateInProgress>().having(
          (s) => s.isGPSEnabled,
          'isGPSEnabled',
          true,
        ),
        isA<GPSConfigurationStateLoaded>().having(
          (s) => s.isGPSEnabled,
          'isGPSEnabled',
          true,
        ),
      ],
      verify: (_) {
        verify(mockRepository.setGPSState(1)).called(1);
      },
    );

    blocTest<GPSConfigurationCubit, GPSConfigurationState>(
      'setState disables GPS successfully',
      build: () {
        when(mockRepository.setGPSState(0)).thenAnswer((_) async => {});
        return GPSConfigurationCubit(mockRepository);
      },
      act: (cubit) => cubit.setState(false),
      expect: () => [
        isA<GPSConfigurationStateUpdateInProgress>().having(
          (s) => s.isGPSEnabled,
          'isGPSEnabled',
          false,
        ),
        isA<GPSConfigurationStateLoaded>().having(
          (s) => s.isGPSEnabled,
          'isGPSEnabled',
          false,
        ),
      ],
      verify: (_) {
        verify(mockRepository.setGPSState(0)).called(1);
      },
    );

    blocTest<GPSConfigurationCubit, GPSConfigurationState>(
      'setState emits error state on failure',
      build: () {
        when(
          mockRepository.setGPSState(any),
        ).thenThrow(Exception('Update failed'));
        return GPSConfigurationCubit(mockRepository);
      },
      act: (cubit) => cubit.setState(true),
      expect: () => [
        isA<GPSConfigurationStateUpdateInProgress>(),
        isA<GPSConfigurationStateError>(),
      ],
    );

    blocTest<GPSConfigurationCubit, GPSConfigurationState>(
      'can toggle GPS state multiple times',
      build: () {
        when(mockRepository.setGPSState(any)).thenAnswer((_) async => {});
        return GPSConfigurationCubit(mockRepository);
      },
      act: (cubit) async {
        cubit.setState(true);
        await Future.delayed(const Duration(milliseconds: 100));
        cubit.setState(false);
        await Future.delayed(const Duration(milliseconds: 100));
        cubit.setState(true);
      },
      expect: () => [
        isA<GPSConfigurationStateUpdateInProgress>(),
        isA<GPSConfigurationStateLoaded>().having(
          (s) => s.isGPSEnabled,
          'isGPSEnabled',
          true,
        ),
        isA<GPSConfigurationStateUpdateInProgress>(),
        isA<GPSConfigurationStateLoaded>().having(
          (s) => s.isGPSEnabled,
          'isGPSEnabled',
          false,
        ),
        isA<GPSConfigurationStateUpdateInProgress>(),
        isA<GPSConfigurationStateLoaded>().having(
          (s) => s.isGPSEnabled,
          'isGPSEnabled',
          true,
        ),
      ],
    );

    test('cubit can be closed properly', () async {
      when(
        mockRepository.getConfiguration(),
      ).thenAnswer((_) async => TestFixtures.defaultConfiguration);

      final cubit = GPSConfigurationCubit(mockRepository);
      await cubit.close();

      expect(cubit.isClosed, true);
    });
  });
}
