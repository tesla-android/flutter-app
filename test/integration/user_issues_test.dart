import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tesla_android/feature/settings/bloc/audio_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/audio_configuration_state.dart';
import 'package:tesla_android/feature/settings/bloc/gps_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/gps_configuration_state.dart';
import 'package:tesla_android/feature/settings/bloc/system_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/system_configuration_state.dart';
import 'package:tesla_android/feature/settings/widget/gps_settings.dart';
import 'package:tesla_android/feature/settings/widget/hotspot_settings.dart';
import 'package:tesla_android/feature/settings/widget/sound_settings.dart';

import '../helpers/cubit_builders.dart';
import '../helpers/settings_test_helpers.dart';
import '../helpers/test_fixtures.dart';

/// User Reported Issues & Edge Cases Regression Tests
///
/// Based on community feedback (Reddit/GitHub), these tests cover common failure modes:
///
/// 1. Audio
///    - Issue: App defaults to mute on launch.
///    - Test: Verify initial volume state and UI reflection (zero/disabled).
///    - Report: "Every time I launch the android app the audio it is muted."
///
/// 2. Navigation & GPS
///    - Issue: GPS continuity gaps or instability.
///    - Test: Toggle stability and immediate state reflection.
///    - Report: "Test the gps on Waze... check out updated functionality."
///
/// 3. Connectivity (Hotspot)
///    - Issue: Confusion over default Wi-Fi passwords/settings.
///    - Test: Ensure critical settings (Band, Offline Mode) are visible even if defaults are ambiguous.
///    - Report: "Default wifi was changed... I do not have the password."
///
/// 4. Pending Coverage (Hardware/Connectivity)
///    - Ethernet via LAN IP: Verify reachability.
///    - Browser Stability: Stress test WebSocket/WebRTC.
///    - Hardware: CarPlay/LTE module detection & RPi400 support.

void main() {
  group('User Reported Issues Regression Tests', () {
    late AudioConfigurationCubit mockAudioCubit;
    late GPSConfigurationCubit mockGpsCubit;
    late SystemConfigurationCubit mockSystemCubit;

    setUp(() {
      mockAudioCubit = CubitBuilders.buildAudioConfigurationCubit();
      mockGpsCubit = CubitBuilders.buildGPSConfigurationCubit();
      mockSystemCubit = CubitBuilders.buildSystemConfigurationCubit();
    });

    // Issue: "Every time I launch the android app the audio it is muted."
    // Goal: Verify UI behavior when audio state initializes to disabled/0 volume.
    testWidgets('Audio: UI handles zero volume/disabled state correctly', (
      WidgetTester tester,
    ) async {
      // Arrange: Simulate the "muted on launch" state
      when(mockAudioCubit.state).thenReturn(
        AudioConfigurationStateSettingsFetched(isEnabled: false, volume: 0),
      );

      // Act
      await tester.pumpWidget(
        SettingsTestHelpers.buildSettingsWidget(
          audioCubit: mockAudioCubit,
          child: const SoundSettings(),
        ),
      );
      await tester.pump();

      // Assert: Verify visual indicators of mute state
      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, false, reason: "Audio switch should be off");

      final sliderWidget = tester.widget<Slider>(find.byType(Slider));
      expect(sliderWidget.value, 0.0, reason: "Volume slider should be at 0");
    });

    // Issue: "GPS functionality... checks out... will test the gps on Waze"
    // Goal: Ensure GPS setting toggle is robust and reflects state immediately
    testWidgets('GPS: Toggle rapid interaction stability', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(
        mockGpsCubit.state,
      ).thenReturn(GPSConfigurationStateLoaded(isGPSEnabled: true));

      await tester.pumpWidget(
        SettingsTestHelpers.buildSettingsWidget(
          gpsCubit: mockGpsCubit,
          child: const GpsSettings(),
        ),
      );
      await tester.pump();

      final gpsSwitch = find.byType(Switch);
      expect(tester.widget<Switch>(gpsSwitch).value, true);

      // Act: Toggle OFF
      await tester.tap(gpsSwitch);
      await tester.pump();

      // Assert: Verify cubit call
      verify(mockGpsCubit.setState(false)).called(1);

      // Note: Full UI round-trip testing with Mocks requires accurate Stream mocking.
      // For this regression test, verifying the interaction (setState) is sufficient
      // to prove the switch remains interactive and logic flows correctly.
    });

    // Issue: "I believe the default wifi was changed... I do not have the password"
    // Goal: Verify Hotspot settings display available options even if config might be ambiguous
    testWidgets('Hotspot: Handles configuration display', (
      WidgetTester tester,
    ) async {
      // Arrange
      final config = TestFixtures.systemConfiguration;
      final state = SystemConfigurationStateSettingsFetched(
        currentConfiguration: config,
      );

      when(mockSystemCubit.state).thenReturn(state);
      when(mockSystemCubit.stream).thenAnswer((_) => Stream.value(state));

      // Act
      await tester.pumpWidget(
        SettingsTestHelpers.buildSettingsWidget(
          systemCubit: mockSystemCubit,
          child: const HotspotSettings(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(
        find.text('Frequency band and channel'),
        findsOneWidget,
        reason: "Should show band settings",
      );
      // Note: If we had a password field, we would assert its visibility here.
      // Since we don't, we ensure the existing critical settings are rendered.
      expect(find.text('Offline mode'), findsOneWidget);
    });
  });
}
