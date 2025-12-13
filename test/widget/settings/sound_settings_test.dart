import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tesla_android/feature/settings/bloc/audio_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/audio_configuration_state.dart';
import 'package:tesla_android/feature/settings/widget/sound_settings.dart';

import '../../helpers/mock_cubits.mocks.dart';

void main() {
  late MockAudioConfigurationCubit mockCubit;

  setUp(() {
    mockCubit = MockAudioConfigurationCubit();
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

  group('SoundSettings Widget', () {
    testWidgets('shows loading indicator when state is Loading', (
      tester,
    ) async {
      when(mockCubit.state).thenReturn(AudioConfigurationStateLoading());
      when(
        mockCubit.stream,
      ).thenAnswer((_) => Stream.value(AudioConfigurationStateLoading()));

      await tester.pumpWidget(makeTestableWidget(const SoundSettings()));

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('shows controls when state is Fetched', (tester) async {
      final state = AudioConfigurationStateSettingsFetched(
        isEnabled: true,
        volume: 80,
      );

      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream.value(state));

      await tester.pumpWidget(makeTestableWidget(const SoundSettings()));
      await tester.pumpAndSettle();

      // Verify Switch
      expect(find.byType(Switch), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
      expect(find.text('80 %'), findsOneWidget);
    });

    testWidgets('calls setState when switch toggled', (tester) async {
      final state = AudioConfigurationStateSettingsFetched(
        isEnabled: true,
        volume: 80,
      );

      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream.value(state));

      await tester.pumpWidget(makeTestableWidget(const SoundSettings()));
      await tester.pumpAndSettle();

      final switchFinder = find.byType(Switch);
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      verify(mockCubit.setState(false)).called(1);
    });

    testWidgets('calls setVolume when slider changed', (tester) async {
      final state = AudioConfigurationStateSettingsFetched(
        isEnabled: true,
        volume: 50,
      );

      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream.value(state));

      await tester.pumpWidget(makeTestableWidget(const SoundSettings()));
      await tester.pumpAndSettle();

      final sliderFinder = find.byType(Slider);
      await tester.drag(sliderFinder, const Offset(100, 0)); // Drag right
      await tester.pumpAndSettle();

      verify(mockCubit.setVolume(any)).called(greaterThan(0));
    });
  });
}
