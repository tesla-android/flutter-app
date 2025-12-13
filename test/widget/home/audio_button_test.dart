import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:tesla_android/common/service/audio_service.dart';
import 'package:tesla_android/feature/home/widget/audio_button.dart';
import 'package:tesla_android/feature/settings/bloc/audio_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/audio_configuration_state.dart';

import '../../helpers/mock_cubits.mocks.dart';

void main() {
  late MockAudioConfigurationCubit mockCubit;
  late MockAudioService mockAudioService;

  setUp(() {
    mockCubit = MockAudioConfigurationCubit();
    mockAudioService = MockAudioService();

    GetIt.I.registerSingleton<AudioService>(mockAudioService);
    when(mockCubit.fetchConfiguration()).thenAnswer((_) async {});
  });

  tearDown(() {
    GetIt.I.reset();
  });

  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<AudioConfigurationCubit>.value(
          value: mockCubit,
          child: child,
        ),
      ),
    );
  }

  group('AudioButton Widget', () {
    testWidgets('shows nothing when audio is disabled', (tester) async {
      final state = AudioConfigurationStateSettingsFetched(
        isEnabled: false,
        volume: 50,
      );
      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream.value(state));
      when(mockAudioService.getAudioState()).thenReturn('stopped');
      when(mockAudioService.addAudioStateListener(any)).thenReturn(() {});

      await tester.pumpWidget(makeTestableWidget(const AudioButton()));
      await tester.pumpAndSettle();

      expect(find.byType(IconButton), findsNothing);
    });

    testWidgets('shows icon when audio is enabled', (tester) async {
      final state = AudioConfigurationStateSettingsFetched(
        isEnabled: true,
        volume: 50,
      );
      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream.value(state));
      when(mockAudioService.getAudioState()).thenReturn('stopped');
      when(mockAudioService.addAudioStateListener(any)).thenReturn(() {});

      await tester.pumpWidget(makeTestableWidget(const AudioButton()));
      await tester.pumpAndSettle();

      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byIcon(Icons.volume_off), findsOneWidget);
    });

    testWidgets('toggles audio state on press', (tester) async {
      final state = AudioConfigurationStateSettingsFetched(
        isEnabled: true,
        volume: 50,
      );
      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream.value(state));
      when(mockAudioService.getAudioState()).thenReturn('stopped');
      when(mockAudioService.addAudioStateListener(any)).thenReturn(() {});

      await tester.pumpWidget(makeTestableWidget(const AudioButton()));
      await tester.pumpAndSettle();

      // Tap to start
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      verify(mockAudioService.startAudioFromGesture()).called(1);
      expect(find.byIcon(Icons.volume_up), findsOneWidget);

      // Tap to stop
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      verify(mockAudioService.stopAudio()).called(1);
      expect(find.byIcon(Icons.volume_off), findsOneWidget);
    });
  });
}
