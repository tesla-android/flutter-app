import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tesla_android/feature/settings/bloc/rear_display_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/rear_display_configuration_state.dart';
import 'package:tesla_android/feature/settings/widget/rear_display_settings.dart';

import '../helpers/cubit_builders.dart';
import '../helpers/settings_test_helpers.dart';

void main() {
  late RearDisplayConfigurationCubit mockCubit;

  setUp(() {
    mockCubit = CubitBuilders.buildRearDisplayConfigurationCubit();
  });

  testWidgets('RearDisplaySettings allows toggling all three switches', (
    WidgetTester tester,
  ) async {
    // Arrange - all settings initially enabled
    when(mockCubit.state).thenReturn(
      RearDisplayConfigurationStateSettingsFetched(
        isRearDisplayEnabled: true,
        isRearDisplayPrioritised: true,
        isCurrentDisplayPrimary: true,
      ),
    );

    // Act
    await tester.pumpWidget(
      SettingsTestHelpers.buildSettingsWidget(
        rearDisplayCubit: mockCubit,
        child: const RearDisplaySettings(),
      ),
    );
    await tester.pump();

    // Assert - all three switches should be visible
    final switches = find.byType(Switch);
    expect(switches, findsNWidgets(3));

    // Act - toggle rear display off
    await tester.tap(switches.first);
    await tester.pump();

    // Assert - verify setRearDisplayState was called
    verify(mockCubit.setRearDisplayState(false)).called(1);
  });

  testWidgets('RearDisplaySettings hides conditional settings when disabled', (
    WidgetTester tester,
  ) async {
    // Arrange - rear display disabled
    when(mockCubit.state).thenReturn(
      RearDisplayConfigurationStateSettingsFetched(
        isRearDisplayEnabled: false,
        isRearDisplayPrioritised: false,
        isCurrentDisplayPrimary: true,
      ),
    );

    // Act
    await tester.pumpWidget(
      SettingsTestHelpers.buildSettingsWidget(
        rearDisplayCubit: mockCubit,
        child: const RearDisplaySettings(),
      ),
    );
    await tester.pump();

    // Assert - only one switch (Rear Display Support) should be visible
    final switches = find.byType(Switch);
    expect(switches, findsOneWidget);

    // Primary Display and Priority settings should not be shown
    expect(find.text('Primary Display'), findsNothing);
    expect(find.text('Rear Display Priority'), findsNothing);
  });

  testWidgets('RearDisplaySettings shows loading indicators correctly', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(mockCubit.state).thenReturn(RearDisplayConfigurationStateLoading());

    // Act
    await tester.pumpWidget(
      SettingsTestHelpers.buildSettingsWidget(
        rearDisplayCubit: mockCubit,
        child: const RearDisplaySettings(),
      ),
    );

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('RearDisplaySettings shows error message on failure', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(mockCubit.state).thenReturn(RearDisplayConfigurationStateError());

    // Act
    await tester.pumpWidget(
      SettingsTestHelpers.buildSettingsWidget(
        rearDisplayCubit: mockCubit,
        child: const RearDisplaySettings(),
      ),
    );

    // Assert
    expect(find.text('Service error'), findsOneWidget);
  });

  testWidgets(
    'RearDisplaySettings handles state transition from loading to fetched',
    (WidgetTester tester) async {
      // Arrange - start with loading
      when(mockCubit.state).thenReturn(RearDisplayConfigurationStateLoading());
      when(mockCubit.stream).thenAnswer(
        (_) => Stream.fromIterable([
          RearDisplayConfigurationStateLoading(),
          RearDisplayConfigurationStateSettingsFetched(
            isRearDisplayEnabled: true,
            isRearDisplayPrioritised: false,
            isCurrentDisplayPrimary: true,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(
        SettingsTestHelpers.buildSettingsWidget(
          rearDisplayCubit: mockCubit,
          child: const RearDisplaySettings(),
        ),
      );

      // Initial loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for state transition
      await tester.pumpAndSettle();

      // Assert - should now show switches
      expect(find.byType(Switch), findsWidgets);
    },
  );
}
