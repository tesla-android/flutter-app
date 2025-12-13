import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tesla_android/feature/settings/bloc/gps_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/gps_configuration_state.dart';
import 'package:tesla_android/feature/settings/widget/gps_settings.dart';

import '../helpers/cubit_builders.dart';
import '../helpers/settings_test_helpers.dart';

void main() {
  late GPSConfigurationCubit mockGpsCubit;

  setUp(() {
    mockGpsCubit = CubitBuilders.buildGPSConfigurationCubit();
  });

  testWidgets('GpsSettings allows toggling GPS on/off', (
    WidgetTester tester,
  ) async {
    // Arrange - GPS initially enabled
    when(
      mockGpsCubit.state,
    ).thenReturn(GPSConfigurationStateLoaded(isGPSEnabled: true));

    // Act
    await tester.pumpWidget(
      SettingsTestHelpers.buildSettingsWidget(
        gpsCubit: mockGpsCubit,
        child: const GpsSettings(),
      ),
    );
    await tester.pump();

    // Assert - verify switch shows GPS enabled
    final gpsSwitch = find.byType(Switch);
    expect(gpsSwitch, findsOneWidget);

    Switch switchWidget = tester.widget(gpsSwitch);
    expect(switchWidget.value, true);

    // Act - toggle GPS off
    await tester.tap(gpsSwitch);
    await tester.pump();

    // Assert - verify setState was called with false
    verify(mockGpsCubit.setState(false)).called(1);
  });

  testWidgets('GpsSettings shows loading indicator during update', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(
      mockGpsCubit.state,
    ).thenReturn(GPSConfigurationStateUpdateInProgress(isGPSEnabled: true));

    // Act
    await tester.pumpWidget(
      SettingsTestHelpers.buildSettingsWidget(
        gpsCubit: mockGpsCubit,
        child: const GpsSettings(),
      ),
    );

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('GpsSettings shows error message on failure', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(mockGpsCubit.state).thenReturn(GPSConfigurationStateError());

    // Act
    await tester.pumpWidget(
      SettingsTestHelpers.buildSettingsWidget(
        gpsCubit: mockGpsCubit,
        child: const GpsSettings(),
      ),
    );

    // Assert
    expect(find.text('Service error'), findsOneWidget);
  });
}
