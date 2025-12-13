import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tesla_android/feature/settings/bloc/device_info_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/device_info_state.dart';
import 'package:tesla_android/feature/settings/model/device_info.dart';
import 'package:tesla_android/feature/settings/widget/device_settings.dart';

import '../helpers/cubit_builders.dart';
import '../helpers/settings_test_helpers.dart';

void main() {
  late DeviceInfoCubit mockDeviceCubit;

  setUp(() {
    mockDeviceCubit = CubitBuilders.buildDeviceInfoCubit();
  });

  testWidgets('DeviceSettings displays correct info from cubit', (
    WidgetTester tester,
  ) async {
    // Arrange
    final testInfo = DeviceInfo(
      cpuTemperature: 45,
      deviceModel: 'rpi4',
      serialNumber: 'TA-123456',
      isCarPlayDetected: 1,
      isModemDetected: 0,
      releaseType: 'Stable',
      otaUrl: 'http://ota.url',
      isGPSEnabled: 1,
    );

    when(
      mockDeviceCubit.state,
    ).thenReturn(DeviceInfoStateLoaded(deviceInfo: testInfo));

    // Act
    await tester.pumpWidget(
      SettingsTestHelpers.buildSettingsWidget(
        deviceInfoCubit: mockDeviceCubit,
        child: const DeviceSettings(),
      ),
    );
    await tester.pump();

    // Assert
    expect(find.text('45°C'), findsOneWidget);
    expect(find.text('Raspberry Pi 4'), findsOneWidget);
    expect(find.text('TA-123456'), findsOneWidget);
    expect(find.text('Connected'), findsOneWidget); // CarPlay detected
    expect(find.text('Not detected'), findsOneWidget); // Modem not detected
    expect(find.text('Stable'), findsOneWidget);
  });

  testWidgets('DeviceSettings shows loading indicator initially', (
    WidgetTester tester,
  ) async {
    // Arrange
    when(mockDeviceCubit.state).thenReturn(DeviceInfoStateLoading());

    // Act
    await tester.pumpWidget(
      SettingsTestHelpers.buildSettingsWidget(
        deviceInfoCubit: mockDeviceCubit,
        child: const DeviceSettings(),
      ),
    );

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
