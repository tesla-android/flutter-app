import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:tesla_android/feature/display/model/remote_display_state.dart';
import 'package:tesla_android/feature/display/repository/display_repository.dart';
import 'package:tesla_android/feature/settings/bloc/display_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/display_configuration_state.dart';

import '../../helpers/test_fixtures.dart';
import 'display_configuration_cubit_test.mocks.dart';

@GenerateMocks([DisplayRepository])
void main() {
  late MockDisplayRepository mockRepository;

  setUp(() {
    mockRepository = MockDisplayRepository();
  });

  group('DisplayConfigurationCubit', () {
    test('initial state is DisplayConfigurationStateInitial', () {
      final cubit = DisplayConfigurationCubit(mockRepository);
      expect(cubit.state, isA<DisplayConfigurationStateInitial>());
      cubit.close();
    });

    blocTest<DisplayConfigurationCubit, DisplayConfigurationState>(
      'fetchConfiguration emits Loading then Fetched on success',
      build: () {
        when(
          mockRepository.getDisplayState(),
        ).thenAnswer((_) async => TestFixtures.defaultDisplayState);
        return DisplayConfigurationCubit(mockRepository);
      },
      act: (cubit) => cubit.fetchConfiguration(),
      expect: () => [
        isA<DisplayConfigurationStateLoading>(),
        isA<DisplayConfigurationStateSettingsFetched>(),
      ],
      verify: (cubit) {
        verify(mockRepository.getDisplayState()).called(1);
      },
    );

    blocTest<DisplayConfigurationCubit, DisplayConfigurationState>(
      'fetchConfiguration emits Loading then Error on failure',
      build: () {
        when(
          mockRepository.getDisplayState(),
        ).thenThrow(Exception('Network error'));
        return DisplayConfigurationCubit(mockRepository);
      },
      act: (cubit) => cubit.fetchConfiguration(),
      expect: () => [
        isA<DisplayConfigurationStateLoading>(),
        isA<DisplayConfigurationStateError>(),
      ],
    );

    blocTest<DisplayConfigurationCubit, DisplayConfigurationState>(
      'setResponsiveness updates state and repository',
      build: () {
        when(
          mockRepository.getDisplayState(),
        ).thenAnswer((_) async => TestFixtures.defaultDisplayState);
        when(
          mockRepository.updateDisplayConfiguration(any),
        ).thenAnswer((_) async => {});
        return DisplayConfigurationCubit(mockRepository);
      },
      seed: () => DisplayConfigurationStateSettingsFetched(
        resolutionPreset: TestFixtures.defaultDisplayState.resolutionPreset,
        renderer: TestFixtures.defaultDisplayState.renderer,
        isResponsive: TestFixtures.defaultDisplayState.isResponsive == 1,
        refreshRate: TestFixtures.defaultDisplayState.refreshRate,
        quality: TestFixtures.defaultDisplayState.quality,
      ),
      act: (cubit) async {
        cubit.fetchConfiguration();
        await cubit.stream.firstWhere(
          (state) => state is DisplayConfigurationStateSettingsFetched,
        );
        cubit.setResponsiveness(false);
      },
      skip: 2, // Skip loading states from fetchConfiguration
      expect: () => [
        isA<DisplayConfigurationStateSettingsUpdateInProgress>(),
        isA<DisplayConfigurationStateSettingsFetched>().having(
          (s) => s.isResponsive,
          'isResponsive',
          false,
        ),
      ],
      verify: (cubit) {
        verify(mockRepository.updateDisplayConfiguration(any)).called(1);
      },
    );

    blocTest<DisplayConfigurationCubit, DisplayConfigurationState>(
      'setResolution updates state and repository',
      build: () {
        when(
          mockRepository.getDisplayState(),
        ).thenAnswer((_) async => TestFixtures.defaultDisplayState);
        when(
          mockRepository.updateDisplayConfiguration(any),
        ).thenAnswer((_) async => {});
        return DisplayConfigurationCubit(mockRepository);
      },
      act: (cubit) async {
        cubit.fetchConfiguration();
        await cubit.stream.firstWhere(
          (state) => state is DisplayConfigurationStateSettingsFetched,
        );
        cubit.setResolution(DisplayResolutionModePreset.res720p);
      },
      skip: 2,
      expect: () => [
        isA<DisplayConfigurationStateSettingsUpdateInProgress>(),
        isA<DisplayConfigurationStateSettingsFetched>().having(
          (s) => s.resolutionPreset,
          'resolutionPreset',
          DisplayResolutionModePreset.res720p,
        ),
      ],
    );

    blocTest<DisplayConfigurationCubit, DisplayConfigurationState>(
      'setRenderer updates state and repository',
      build: () {
        when(
          mockRepository.getDisplayState(),
        ).thenAnswer((_) async => TestFixtures.defaultDisplayState);
        when(
          mockRepository.updateDisplayConfiguration(any),
        ).thenAnswer((_) async => {});
        return DisplayConfigurationCubit(mockRepository);
      },
      act: (cubit) async {
        cubit.fetchConfiguration();
        await cubit.stream.firstWhere(
          (state) => state is DisplayConfigurationStateSettingsFetched,
        );
        cubit.setRenderer(DisplayRendererType.mjpeg);
      },
      skip: 2,
      expect: () => [
        isA<DisplayConfigurationStateSettingsUpdateInProgress>(),
        isA<DisplayConfigurationStateSettingsFetched>().having(
          (s) => s.renderer,
          'renderer',
          DisplayRendererType.mjpeg,
        ),
      ],
    );

    blocTest<DisplayConfigurationCubit, DisplayConfigurationState>(
      'setQuality updates state and repository',
      build: () {
        when(
          mockRepository.getDisplayState(),
        ).thenAnswer((_) async => TestFixtures.defaultDisplayState);
        when(
          mockRepository.updateDisplayConfiguration(any),
        ).thenAnswer((_) async => {});
        return DisplayConfigurationCubit(mockRepository);
      },
      act: (cubit) async {
        cubit.fetchConfiguration();
        await cubit.stream.firstWhere(
          (state) => state is DisplayConfigurationStateSettingsFetched,
        );
        cubit.setQuality(DisplayQualityPreset.quality50);
      },
      skip: 2,
      expect: () => [
        isA<DisplayConfigurationStateSettingsUpdateInProgress>(),
        isA<DisplayConfigurationStateSettingsFetched>().having(
          (s) => s.quality,
          'quality',
          DisplayQualityPreset.quality50,
        ),
      ],
    );

    blocTest<DisplayConfigurationCubit, DisplayConfigurationState>(
      'setRefreshRate updates state and repository',
      build: () {
        when(
          mockRepository.getDisplayState(),
        ).thenAnswer((_) async => TestFixtures.defaultDisplayState);
        when(
          mockRepository.updateDisplayConfiguration(any),
        ).thenAnswer((_) async => {});
        return DisplayConfigurationCubit(mockRepository);
      },
      act: (cubit) async {
        cubit.fetchConfiguration();
        await cubit.stream.firstWhere(
          (state) => state is DisplayConfigurationStateSettingsFetched,
        );
        cubit.setRefreshRate(DisplayRefreshRatePreset.refresh60hz);
      },
      skip: 2,
      expect: () => [
        isA<DisplayConfigurationStateSettingsUpdateInProgress>(),
        isA<DisplayConfigurationStateSettingsFetched>().having(
          (s) => s.refreshRate,
          'refreshRate',
          DisplayRefreshRatePreset.refresh60hz,
        ),
      ],
    );

    blocTest<DisplayConfigurationCubit, DisplayConfigurationState>(
      'setter emits Error on repository failure',
      build: () {
        when(
          mockRepository.getDisplayState(),
        ).thenAnswer((_) async => TestFixtures.defaultDisplayState);
        when(
          mockRepository.updateDisplayConfiguration(any),
        ).thenThrow(Exception('Network error'));
        return DisplayConfigurationCubit(mockRepository);
      },
      act: (cubit) async {
        cubit.fetchConfiguration();
        await cubit.stream.firstWhere(
          (state) => state is DisplayConfigurationStateSettingsFetched,
        );
        cubit.setResponsiveness(false);
      },
      skip: 2,
      expect: () => [
        isA<DisplayConfigurationStateSettingsUpdateInProgress>(),
        isA<DisplayConfigurationStateError>(),
      ],
    );
  });
}
