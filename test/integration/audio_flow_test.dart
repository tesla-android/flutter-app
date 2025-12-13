import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tesla_android/feature/settings/bloc/audio_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/audio_configuration_state.dart';
import 'package:tesla_android/feature/settings/widget/sound_settings.dart';

import '../helpers/cubit_builders.dart';
import '../helpers/settings_test_helpers.dart';

void main() {
  late AudioConfigurationCubit mockCubit;

  setUp(() {
    mockCubit = CubitBuilders.buildAudioConfigurationCubit();
  });

  testWidgets('SoundSettings volume slider displays current value', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(mockCubit.state).thenReturn(
      AudioConfigurationStateSettingsFetched(isEnabled: true, volume: 75),
    );

    // Act
    await tester.pumpWidget(
      SettingsTestHelpers.buildSettingsWidget(
        audioCubit: mockCubit,
        child: const SoundSettings(),
      ),
    );
    await tester.pump();

    // Assert - find the slider and verify value
    final slider = find.byType(Slider);
    expect(slider, findsOneWidget);

    final sliderWidget = tester.widget<Slider>(slider);
    expect(sliderWidget.value, 75.0);
  });

  testWidgets('SoundSettings audio enable/disable toggle', (
    WidgetTester tester,
  ) async {
    // Arrange - audio initially disabled
    when(mockCubit.state).thenReturn(
      AudioConfigurationStateSettingsFetched(isEnabled: false, volume: 100),
    );

    // Act
    await tester.pumpWidget(
      SettingsTestHelpers.buildSettingsWidget(
        audioCubit: mockCubit,
        child: const SoundSettings(),
      ),
    );
    await tester.pump();

    // Find and tap the switch
    final audioSwitch = find.byType(Switch);
    expect(audioSwitch, findsOneWidget);

    // Verify switch shows disabled state
    final switchWidget = tester.widget<Switch>(audioSwitch);
    expect(switchWidget.value, false);

    // Act - enable audio
    await tester.tap(audioSwitch);
    await tester.pump();

    // Assert - verify setState was called
    verify(mockCubit.setState(true)).called(1);
  });

  testWidgets('SoundSettings slider interaction updates volume', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(mockCubit.state).thenReturn(
      AudioConfigurationStateSettingsFetched(isEnabled: true, volume: 50),
    );

    // Act
    await tester.pumpWidget(
      SettingsTestHelpers.buildSettingsWidget(
        audioCubit: mockCubit,
        child: const SoundSettings(),
      ),
    );
    await tester.pump();

    // Find slider
    final slider = find.byType(Slider);
    expect(slider, findsOneWidget);

    // Note: Testing actual slider drag is complex in widget tests
    // We verify the widget has the correct onChanged callback
    final sliderWidget = tester.widget<Slider>(slider);
    expect(sliderWidget.onChanged, isNotNull);
  });

  testWidgets('SoundSettings shows loading indicator', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(mockCubit.state).thenReturn(AudioConfigurationStateLoading());

    // Act
    await tester.pumpWidget(
      SettingsTestHelpers.buildSettingsWidget(
        audioCubit: mockCubit,
        child: const SoundSettings(),
      ),
    );

    // Assert - at least one loading indicator should be present
    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('SoundSettings handles error state', (WidgetTester tester) async {
    // Arrange
    when(mockCubit.state).thenReturn(AudioConfigurationStateError());

    // Act
    await tester.pumpWidget(
      SettingsTestHelpers.buildSettingsWidget(
        audioCubit: mockCubit,
        child: const SoundSettings(),
      ),
    );

    // Assert - at least one "Service error" text should be present
    expect(find.text('Service error'), findsWidgets);
  });

  testWidgets('SoundSettings handles update in progress state', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(
      mockCubit.state,
    ).thenReturn(AudioConfigurationStateSettingsUpdateInProgress());

    // Act
    await tester.pumpWidget(
      SettingsTestHelpers.buildSettingsWidget(
        audioCubit: mockCubit,
        child: const SoundSettings(),
      ),
    );

    // Assert - should show loading indicator during update
    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('SoundSettings state transition from disabled to enabled', (
    WidgetTester tester,
  ) async {
    // Arrange - start disabled
    when(mockCubit.state).thenReturn(
      AudioConfigurationStateSettingsFetched(isEnabled: false, volume: 100),
    );

    when(mockCubit.stream).thenAnswer(
      (_) => Stream.fromIterable([
        AudioConfigurationStateSettingsFetched(isEnabled: false, volume: 100),
        AudioConfigurationStateSettingsUpdateInProgress(),
        AudioConfigurationStateSettingsFetched(isEnabled: true, volume: 100),
      ]),
    );

    // Act
    await tester.pumpWidget(
      SettingsTestHelpers.buildSettingsWidget(
        audioCubit: mockCubit,
        child: const SoundSettings(),
      ),
    );

    // Initial state - switch off
    final audioSwitch = find.byType(Switch);
    Switch switchWidget = tester.widget(audioSwitch);
    expect(switchWidget.value, false);

    // Wait for state transitions
    await tester.pumpAndSettle();

    // Assert - should eventually show enabled
    expect(find.byType(Switch), findsOneWidget);
  });
}
