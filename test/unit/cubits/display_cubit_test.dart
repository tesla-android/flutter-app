import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tesla_android/feature/display/cubit/display_cubit.dart';
import 'package:tesla_android/feature/display/cubit/display_state.dart';
import 'package:tesla_android/feature/display/model/remote_display_state.dart';
import 'package:tesla_android/feature/display/repository/display_repository.dart';
import '../../helpers/test_fixtures.dart';
import 'display_cubit_test.mocks.dart';

@GenerateMocks([DisplayRepository])
void main() {
  late MockDisplayRepository mockRepository;
  setUp(() {
    mockRepository = MockDisplayRepository();
  });

  group('DisplayCubit', () {
    test('initial state is DisplayStateInitial', () {
      final cubit = DisplayCubit(mockRepository);
      expect(cubit.state, isA<DisplayStateInitial>());
      cubit.close();
    });

    blocTest<DisplayCubit, DisplayState>(
      'resizeDisplay does nothing when current size equals new size',
      build: () {
        when(
          mockRepository.getDisplayState(),
        ).thenAnswer((_) async => TestFixtures.defaultDisplayState);
        when(mockRepository.isPrimaryDisplay()).thenAnswer((_) async => true);
        when(
          mockRepository.updateDisplayConfiguration(any),
        ).thenAnswer((_) async => {});
        return DisplayCubit(mockRepository);
      },
      act: (cubit) async {
        // First set to normal state with a specific size
        await cubit.resizeDisplay(viewSize: const Size(1920, 1080));
        await Future.delayed(const Duration(milliseconds: 1100));

        // Try to resize to same size - should do nothing
        await cubit.resizeDisplay(viewSize: const Size(1920, 1080));
      },
      wait: const Duration(milliseconds: 3000),
      expect: () => [
        isA<DisplayStateResizeCoolDown>(),
        isA<DisplayStateResizeInProgress>(),
        isA<DisplayStateNormal>(),
      ],
    );

    blocTest<DisplayCubit, DisplayState>(
      'resize Display emits ResizeCoolDown then Normal when sizes match',
      build: () {
        when(
          mockRepository.getDisplayState(),
        ).thenAnswer((_) async => TestFixtures.defaultDisplayState);
        when(mockRepository.isPrimaryDisplay()).thenAnswer((_) async => true);
        when(
          mockRepository.updateDisplayConfiguration(any),
        ).thenAnswer((_) async => {});
        return DisplayCubit(mockRepository);
      },
      act: (cubit) async =>
          await cubit.resizeDisplay(viewSize: const Size(1920, 1080)),
      wait: const Duration(milliseconds: 3000),
      expect: () => [
        isA<DisplayStateResizeCoolDown>(),
        isA<DisplayStateResizeInProgress>(),
        isA<DisplayStateNormal>(),
      ],
      verify: (cubit) {
        final state = cubit.state as DisplayStateNormal;
        expect(state.viewSize, const Size(1920, 1080));
        expect(state.adjustedSize, const Size(1024, 768));
        expect(state.rendererType, DisplayRendererType.h264WebCodecs);
      },
    );

    blocTest<DisplayCubit, DisplayState>(
      'resizeDisplay calculates optimal size when different from remote',
      build: () {
        // Remote state is 1920x1080, but optimal might be different
        when(
          mockRepository.getDisplayState(),
        ).thenAnswer((_) async => TestFixtures.defaultDisplayState);
        when(mockRepository.isPrimaryDisplay()).thenAnswer((_) async => true);
        when(
          mockRepository.updateDisplayConfiguration(any),
        ).thenAnswer((_) async => {});
        return DisplayCubit(mockRepository);
      },
      act: (cubit) async =>
          await cubit.resizeDisplay(viewSize: const Size(1280, 720)),
      wait: const Duration(milliseconds: 3000),
      expect: () => [
        isA<DisplayStateResizeCoolDown>(),
        isA<DisplayStateResizeInProgress>(),
        isA<DisplayStateNormal>(),
      ],
      verify: (cubit) {
        verify(mockRepository.updateDisplayConfiguration(any)).called(1);
      },
    );

    blocTest<DisplayCubit, DisplayState>(
      'onDisplayTypeSelectionFinished sets primary display and resizes',
      build: () {
        when(
          mockRepository.getDisplayState(),
        ).thenAnswer((_) async => TestFixtures.defaultDisplayState);
        when(mockRepository.isPrimaryDisplay()).thenAnswer((_) async => true);
        when(mockRepository.setDisplayType(true)).thenAnswer((_) async => true);
        when(
          mockRepository.updateDisplayConfiguration(any),
        ).thenAnswer((_) async => {});
        return DisplayCubit(mockRepository);
      },
      act: (cubit) async =>
          await cubit.onDisplayTypeSelectionFinished(isPrimaryDisplay: true),
      wait: const Duration(milliseconds: 3000),
      expect: () => [
        isA<DisplayStateDisplayTypeSelectionFinished>(),
        isA<DisplayStateResizeCoolDown>(),
        isA<DisplayStateResizeInProgress>(),
        isA<DisplayStateNormal>(),
      ],
      verify: (cubit) {
        verify(mockRepository.setDisplayType(true)).called(1);
      },
    );

    blocTest<DisplayCubit, DisplayState>(
      'emits DisplayTypeSelectionTriggered when isPrimaryDisplay is null and rear display enabled',
      build: () {
        final rearDisplayState = TestFixtures.defaultDisplayState.copyWith(
          isRearDisplayEnabled: 1,
        );
        when(
          mockRepository.getDisplayState(),
        ).thenAnswer((_) async => rearDisplayState);
        when(
          mockRepository.isPrimaryDisplay(),
        ).thenAnswer((_) async => null); // No preference set
        return DisplayCubit(mockRepository);
      },
      act: (cubit) async =>
          await cubit.resizeDisplay(viewSize: const Size(1920, 1080)),
      wait: const Duration(milliseconds: 3000),
      expect: () => [isA<DisplayStateDisplayTypeSelectionTriggered>()],
    );

    blocTest<DisplayCubit, DisplayState>(
      'uses MJPEG renderer when isH264 is false',
      build: () {
        when(
          mockRepository.getDisplayState(),
        ).thenAnswer((_) async => TestFixtures.mjpegDisplayState);
        when(mockRepository.isPrimaryDisplay()).thenAnswer((_) async => true);
        when(
          mockRepository.updateDisplayConfiguration(any),
        ).thenAnswer((_) async => {});
        return DisplayCubit(mockRepository);
      },
      act: (cubit) async =>
          await cubit.resizeDisplay(viewSize: const Size(1280, 720)),
      wait: const Duration(milliseconds: 3000),
      expect: () => [
        isA<DisplayStateResizeCoolDown>(),
        isA<DisplayStateResizeInProgress>(),
        isA<DisplayStateNormal>(),
      ],
      verify: (cubit) {
        final state = cubit.state as DisplayStateNormal;
        expect(state.rendererType, DisplayRendererType.mjpeg);
      },
    );

    blocTest<DisplayCubit, DisplayState>(
      'onWindowSizeChanged triggers resize with new size',
      build: () {
        when(
          mockRepository.getDisplayState(),
        ).thenAnswer((_) async => TestFixtures.defaultDisplayState);
        when(mockRepository.isPrimaryDisplay()).thenAnswer((_) async => true);
        when(
          mockRepository.updateDisplayConfiguration(any),
        ).thenAnswer((_) async => {});
        return DisplayCubit(mockRepository);
      },
      act: (cubit) async =>
          await cubit.onWindowSizeChanged(const Size(800, 600)),
      wait: const Duration(milliseconds: 3000),
      expect: () => [
        isA<DisplayStateResizeCoolDown>(),
        isA<DisplayStateResizeInProgress>(),
        isA<DisplayStateNormal>(),
      ],
      verify: (cubit) {
        final state = cubit.state as DisplayStateNormal;
        expect(state.viewSize, const Size(800, 600));
      },
    );

    blocTest<DisplayCubit, DisplayState>(
      'does not resize when in DisplayStateResizeInProgress',
      build: () {
        when(
          mockRepository.getDisplayState(),
        ).thenAnswer((_) async => TestFixtures.defaultDisplayState);
        when(mockRepository.isPrimaryDisplay()).thenAnswer((_) async => true);
        when(
          mockRepository.updateDisplayConfiguration(any),
        ).thenAnswer((_) async => {});
        return DisplayCubit(mockRepository);
      },
      act: (cubit) async {
        // Start first resize
        await cubit.resizeDisplay(viewSize: const Size(1280, 720));
        await Future.delayed(const Duration(milliseconds: 1100));

        // Try second resize during InProgress state
        await cubit.resizeDisplay(viewSize: const Size(800, 600));
      },
      wait: const Duration(milliseconds: 3000),
      expect: () => [
        isA<DisplayStateResizeCoolDown>(),
        isA<DisplayStateResizeInProgress>(),
        isA<DisplayStateNormal>(),
        // Second resize might queue or be ignored
      ],
    );

    blocTest<DisplayCubit, DisplayState>(
      'handles rear display prioritization correctly',
      build: () {
        final rearPrioritizedState = TestFixtures.defaultDisplayState.copyWith(
          isRearDisplayEnabled: 1,
          isRearDisplayPrioritised: 1,
        );
        when(
          mockRepository.getDisplayState(),
        ).thenAnswer((_) async => rearPrioritizedState);
        when(
          mockRepository.isPrimaryDisplay(),
        ).thenAnswer((_) async => false); // Secondary display
        when(
          mockRepository.updateDisplayConfiguration(any),
        ).thenAnswer((_) async => {});
        return DisplayCubit(mockRepository);
      },
      act: (cubit) async =>
          await cubit.resizeDisplay(viewSize: const Size(1920, 1080)),
      wait: const Duration(milliseconds: 3000),
      expect: () => [
        isA<DisplayStateResizeCoolDown>(),
        isA<DisplayStateResizeInProgress>(),
        isA<DisplayStateNormal>(),
      ],
    );

    test('close cancels timers and subscriptions', () async {
      when(
        mockRepository.getDisplayState(),
      ).thenAnswer((_) async => TestFixtures.defaultDisplayState);
      when(mockRepository.isPrimaryDisplay()).thenAnswer((_) async => true);

      final cubit = DisplayCubit(mockRepository);
      await cubit.resizeDisplay(viewSize: const Size(1920, 1080));

      await Future.delayed(const Duration(milliseconds: 100));
      await cubit.close();

      expect(cubit.isClosed, true);
    });

    group('Edge Cases', () {
      blocTest<DisplayCubit, DisplayState>(
        'handles zero viewSize by using remote size',
        build: () {
          when(
            mockRepository.getDisplayState(),
          ).thenAnswer((_) async => TestFixtures.defaultDisplayState);
          when(mockRepository.isPrimaryDisplay()).thenAnswer((_) async => true);
          when(
            mockRepository.updateDisplayConfiguration(any),
          ).thenAnswer((_) async => {});
          return DisplayCubit(mockRepository);
        },
        act: (cubit) async => await cubit.resizeDisplay(viewSize: Size.zero),
        wait: const Duration(milliseconds: 3000),
        expect: () => [
          isA<DisplayStateResizeCoolDown>(),
          isA<DisplayStateResizeInProgress>(),
          isA<DisplayStateNormal>(),
        ],
        verify: (cubit) {
          final state = cubit.state as DisplayStateNormal;
          // Should use remote size (1920x1080 from fixture)
          expect(state.viewSize.width, 1920);
          expect(state.viewSize.height, 1080);
        },
      );

      blocTest<DisplayCubit, DisplayState>(
        'handles repository errors gracefully',
        build: () {
          when(
            mockRepository.getDisplayState(),
          ).thenThrow(Exception('Network error'));
          when(mockRepository.isPrimaryDisplay()).thenAnswer((_) async => true);
          return DisplayCubit(mockRepository);
        },
        act: (cubit) async =>
            await cubit.resizeDisplay(viewSize: const Size(1920, 1080)),
        wait: const Duration(milliseconds: 3000),
        errors: () => [isA<Exception>()],
      );
    });
  });
}
