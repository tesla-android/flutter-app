import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:tesla_android/feature/display/repository/display_repository.dart';
import 'package:tesla_android/feature/settings/bloc/rear_display_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/rear_display_configuration_state.dart';

import '../../helpers/test_fixtures.dart';
import 'rear_display_configuration_cubit_test.mocks.dart';

@GenerateMocks([DisplayRepository])
void main() {
  late MockDisplayRepository mockRepository;

  setUp(() {
    mockRepository = MockDisplayRepository();
  });

  group('RearDisplayConfigurationCubit', () {
    test('initial state is RearDisplayConfigurationStateInitial', () {
      final cubit = RearDisplayConfigurationCubit(mockRepository);
      expect(cubit.state, isA<RearDisplayConfigurationStateInitial>());
      cubit.close();
    });

    blocTest<RearDisplayConfigurationCubit, RearDisplayConfigurationState>(
      'fetchConfiguration emits Loading then Fetched on success',
      build: () {
        when(
          mockRepository.getDisplayState(),
        ).thenAnswer((_) async => TestFixtures.defaultDisplayState);
        when(mockRepository.isPrimaryDisplay()).thenAnswer((_) async => true);
        return RearDisplayConfigurationCubit(mockRepository);
      },
      act: (cubit) => cubit.fetchConfiguration(),
      expect: () => [
        isA<RearDisplayConfigurationStateLoading>(),
        isA<RearDisplayConfigurationStateSettingsFetched>().having(
          (s) => s.isCurrentDisplayPrimary,
          'isCurrentDisplayPrimary',
          true,
        ),
      ],
      verify: (cubit) {
        verify(mockRepository.getDisplayState()).called(1);
        verify(mockRepository.isPrimaryDisplay()).called(1);
      },
    );

    blocTest<RearDisplayConfigurationCubit, RearDisplayConfigurationState>(
      'fetchConfiguration emits Loading then Error on failure',
      build: () {
        when(
          mockRepository.getDisplayState(),
        ).thenThrow(Exception('Network error'));
        return RearDisplayConfigurationCubit(mockRepository);
      },
      act: (cubit) => cubit.fetchConfiguration(),
      expect: () => [
        isA<RearDisplayConfigurationStateLoading>(),
        isA<RearDisplayConfigurationStateError>(),
      ],
    );

    blocTest<RearDisplayConfigurationCubit, RearDisplayConfigurationState>(
      'setRearDisplayState updates state and repository',
      build: () {
        when(
          mockRepository.getDisplayState(),
        ).thenAnswer((_) async => TestFixtures.defaultDisplayState);
        when(mockRepository.isPrimaryDisplay()).thenAnswer((_) async => true);
        when(
          mockRepository.updateDisplayConfiguration(any),
        ).thenAnswer((_) async => {});
        return RearDisplayConfigurationCubit(mockRepository);
      },
      act: (cubit) async {
        cubit.fetchConfiguration();
        // Wait for fetch to complete
        await Future.delayed(Duration.zero);
        cubit.setRearDisplayState(true);
      },
      skip: 2, // Skip loading states from fetchConfiguration
      expect: () => [
        isA<RearDisplayConfigurationStateSettingsUpdateInProgress>(),
        isA<RearDisplayConfigurationStateSettingsFetched>().having(
          (s) => s.isRearDisplayEnabled,
          'isRearDisplayEnabled',
          true,
        ),
      ],
      verify: (cubit) {
        verify(mockRepository.updateDisplayConfiguration(any)).called(1);
      },
    );

    blocTest<RearDisplayConfigurationCubit, RearDisplayConfigurationState>(
      'setRearDisplayPrioritization updates state and repository',
      build: () {
        when(
          mockRepository.getDisplayState(),
        ).thenAnswer((_) async => TestFixtures.defaultDisplayState);
        when(mockRepository.isPrimaryDisplay()).thenAnswer((_) async => true);
        when(
          mockRepository.updateDisplayConfiguration(any),
        ).thenAnswer((_) async => {});
        return RearDisplayConfigurationCubit(mockRepository);
      },
      act: (cubit) async {
        cubit.fetchConfiguration();
        await Future.delayed(Duration.zero);
        cubit.setRearDisplayPrioritization(true);
      },
      skip: 2,
      expect: () => [
        isA<RearDisplayConfigurationStateSettingsUpdateInProgress>(),
        isA<RearDisplayConfigurationStateSettingsFetched>().having(
          (s) => s.isRearDisplayPrioritised,
          'isRearDisplayPrioritised',
          true,
        ),
      ],
    );

    blocTest<RearDisplayConfigurationCubit, RearDisplayConfigurationState>(
      'setDisplayType calls repository and emits updated config',
      build: () {
        when(
          mockRepository.getDisplayState(),
        ).thenAnswer((_) async => TestFixtures.defaultDisplayState);
        when(mockRepository.isPrimaryDisplay()).thenAnswer((_) async => false);
        when(mockRepository.setDisplayType(any)).thenAnswer((_) async => {});
        return RearDisplayConfigurationCubit(mockRepository);
      },
      act: (cubit) async {
        cubit.fetchConfiguration();
        await Future.delayed(Duration.zero);
        cubit.setDisplayType(isCurrentDisplayPrimary: false);
      },
      skip: 2,
      expect: () => [
        isA<RearDisplayConfigurationStateSettingsFetched>().having(
          (s) => s.isCurrentDisplayPrimary,
          'isCurrentDisplayPrimary',
          false,
        ),
      ],
      verify: (cubit) {
        verify(mockRepository.setDisplayType(false)).called(1);
      },
    );

    blocTest<RearDisplayConfigurationCubit, RearDisplayConfigurationState>(
      'setter emits Error on repository failure',
      build: () {
        when(
          mockRepository.getDisplayState(),
        ).thenAnswer((_) async => TestFixtures.defaultDisplayState);
        when(mockRepository.isPrimaryDisplay()).thenAnswer((_) async => true);
        when(
          mockRepository.updateDisplayConfiguration(any),
        ).thenThrow(Exception('Network error'));
        return RearDisplayConfigurationCubit(mockRepository);
      },
      act: (cubit) async {
        cubit.fetchConfiguration();
        await Future.delayed(Duration.zero);
        cubit.setRearDisplayState(true);
      },
      skip: 2,
      expect: () => [
        isA<RearDisplayConfigurationStateSettingsUpdateInProgress>(),
        isA<RearDisplayConfigurationStateError>(),
      ],
    );
  });
}
