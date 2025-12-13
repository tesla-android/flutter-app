import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tesla_android/feature/settings/bloc/audio_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/audio_configuration_state.dart';
import 'package:tesla_android/feature/settings/repository/system_configuration_repository.dart';
import '../../helpers/test_fixtures.dart';

import 'audio_configuration_cubit_test.mocks.dart';

@GenerateMocks([SystemConfigurationRepository])
void main() {
  late MockSystemConfigurationRepository mockRepository;

  setUp(() {
    mockRepository = MockSystemConfigurationRepository();
  });

  group('AudioConfigurationCubit', () {
    test('initial state is AudioConfigurationStateInitial', () {
      final cubit = AudioConfigurationCubit(mockRepository);
      expect(cubit.state, isA<AudioConfigurationStateInitial>());
      cubit.close();
    });

    blocTest<AudioConfigurationCubit, AudioConfigurationState>(
      'fetchConfiguration emits loaded state with audio enabled',
      build: () {
        final config = TestFixtures.defaultConfiguration.copyWith(
          browserAudioIsEnabled: 1,
          browserAudioVolume: 80,
        );
        when(mockRepository.getConfiguration()).thenAnswer((_) async => config);
        return AudioConfigurationCubit(mockRepository);
      },
      act: (cubit) => cubit.fetchConfiguration(),
      expect: () => [
        isA<AudioConfigurationStateLoading>(),
        isA<AudioConfigurationStateSettingsFetched>()
            .having((s) => s.isEnabled, 'isEnabled', true)
            .having((s) => s.volume, 'volume', 80),
      ],
    );

    blocTest<AudioConfigurationCubit, AudioConfigurationState>(
      'fetchConfiguration emits loaded state with audio disabled',
      build: () {
        final config = TestFixtures.defaultConfiguration.copyWith(
          browserAudioIsEnabled: 0,
          browserAudioVolume: 50,
        );
        when(mockRepository.getConfiguration()).thenAnswer((_) async => config);
        return AudioConfigurationCubit(mockRepository);
      },
      act: (cubit) => cubit.fetchConfiguration(),
      expect: () => [
        isA<AudioConfigurationStateLoading>(),
        isA<AudioConfigurationStateSettingsFetched>()
            .having((s) => s.isEnabled, 'isEnabled', false)
            .having((s) => s.volume, 'volume', 50),
      ],
    );

    blocTest<AudioConfigurationCubit, AudioConfigurationState>(
      'fetchConfiguration emits error state on failure',
      build: () {
        when(
          mockRepository.getConfiguration(),
        ).thenThrow(Exception('Network error'));
        return AudioConfigurationCubit(mockRepository);
      },
      act: (cubit) => cubit.fetchConfiguration(),
      expect: () => [
        isA<AudioConfigurationStateLoading>(),
        isA<AudioConfigurationStateError>(),
      ],
    );

    blocTest<AudioConfigurationCubit, AudioConfigurationState>(
      'setVolume updates volume and enables audio',
      build: () {
        when(
          mockRepository.setBrowserAudioState(1),
        ).thenAnswer((_) async => {});
        when(
          mockRepository.setBrowserAudioVolume(60),
        ).thenAnswer((_) async => {});
        return AudioConfigurationCubit(mockRepository);
      },
      act: (cubit) => cubit.setVolume(60),
      expect: () => [
        isA<AudioConfigurationStateSettingsUpdateInProgress>(),
        isA<AudioConfigurationStateSettingsFetched>()
            .having((s) => s.isEnabled, 'isEnabled', true)
            .having((s) => s.volume, 'volume', 60),
      ],
      verify: (_) {
        verify(mockRepository.setBrowserAudioState(1)).called(1);
        verify(mockRepository.setBrowserAudioVolume(60)).called(1);
      },
    );

    blocTest<AudioConfigurationCubit, AudioConfigurationState>(
      'setState enables audio with volume 100',
      build: () {
        when(
          mockRepository.setBrowserAudioState(1),
        ).thenAnswer((_) async => {});
        when(
          mockRepository.setBrowserAudioVolume(100),
        ).thenAnswer((_) async => {});
        return AudioConfigurationCubit(mockRepository);
      },
      act: (cubit) => cubit.setState(true),
      expect: () => [
        isA<AudioConfigurationStateSettingsUpdateInProgress>(),
        isA<AudioConfigurationStateSettingsFetched>()
            .having((s) => s.isEnabled, 'isEnabled', true)
            .having((s) => s.volume, 'volume', 100),
      ],
      verify: (_) {
        verify(mockRepository.setBrowserAudioState(1)).called(1);
        verify(mockRepository.setBrowserAudioVolume(100)).called(1);
      },
    );

    blocTest<AudioConfigurationCubit, AudioConfigurationState>(
      'setState disables audio',
      build: () {
        when(
          mockRepository.setBrowserAudioState(0),
        ).thenAnswer((_) async => {});
        when(
          mockRepository.setBrowserAudioVolume(100),
        ).thenAnswer((_) async => {});
        return AudioConfigurationCubit(mockRepository);
      },
      act: (cubit) => cubit.setState(false),
      expect: () => [
        isA<AudioConfigurationStateSettingsUpdateInProgress>(),
        isA<AudioConfigurationStateSettingsFetched>()
            .having((s) => s.isEnabled, 'isEnabled', false)
            .having((s) => s.volume, 'volume', 100),
      ],
      verify: (_) {
        verify(mockRepository.setBrowserAudioState(0)).called(1);
        verify(mockRepository.setBrowserAudioVolume(100)).called(1);
      },
    );

    blocTest<AudioConfigurationCubit, AudioConfigurationState>(
      'setVolume emits error state on failure',
      build: () {
        when(
          mockRepository.setBrowserAudioState(any),
        ).thenThrow(Exception('Update failed'));
        return AudioConfigurationCubit(mockRepository);
      },
      act: (cubit) => cubit.setVolume(75),
      expect: () => [
        isA<AudioConfigurationStateSettingsUpdateInProgress>(),
        isA<AudioConfigurationStateError>(),
      ],
    );

    blocTest<AudioConfigurationCubit, AudioConfigurationState>(
      'setState emits error state on failure',
      build: () {
        when(
          mockRepository.setBrowserAudioState(any),
        ).thenThrow(Exception('Update failed'));
        return AudioConfigurationCubit(mockRepository);
      },
      act: (cubit) => cubit.setState(true),
      expect: () => [
        isA<AudioConfigurationStateSettingsUpdateInProgress>(),
        isA<AudioConfigurationStateError>(),
      ],
    );

    blocTest<AudioConfigurationCubit, AudioConfigurationState>(
      'can update volume multiple times',
      build: () {
        when(
          mockRepository.setBrowserAudioState(any),
        ).thenAnswer((_) async => {});
        when(
          mockRepository.setBrowserAudioVolume(any),
        ).thenAnswer((_) async => {});
        return AudioConfigurationCubit(mockRepository);
      },
      act: (cubit) async {
        cubit.setVolume(30);
        await Future.delayed(const Duration(milliseconds: 100));
        cubit.setVolume(60);
        await Future.delayed(const Duration(milliseconds: 100));
        cubit.setVolume(90);
      },
      expect: () => [
        isA<AudioConfigurationStateSettingsUpdateInProgress>(),
        isA<AudioConfigurationStateSettingsFetched>().having(
          (s) => s.volume,
          'volume',
          30,
        ),
        isA<AudioConfigurationStateSettingsUpdateInProgress>(),
        isA<AudioConfigurationStateSettingsFetched>().having(
          (s) => s.volume,
          'volume',
          60,
        ),
        isA<AudioConfigurationStateSettingsUpdateInProgress>(),
        isA<AudioConfigurationStateSettingsFetched>().having(
          (s) => s.volume,
          'volume',
          90,
        ),
      ],
    );

    test('cubit can be closed properly', () async {
      when(
        mockRepository.getConfiguration(),
      ).thenAnswer((_) async => TestFixtures.defaultConfiguration);

      final cubit = AudioConfigurationCubit(mockRepository);
      await cubit.close();

      expect(cubit.isClosed, true);
    });
  });
}
