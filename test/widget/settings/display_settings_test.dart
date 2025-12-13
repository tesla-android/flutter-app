import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tesla_android/feature/display/model/remote_display_state.dart';
import 'package:tesla_android/feature/settings/bloc/display_configuration_state.dart';
import 'package:tesla_android/feature/settings/widget/display_settings.dart';

import '../../helpers/mock_cubits.mocks.dart';
import '../../helpers/settings_test_helpers.dart';

void main() {
  late MockDisplayConfigurationCubit mockCubit;

  setUp(() {
    mockCubit = MockDisplayConfigurationCubit();
  });

  group('DisplaySettings Widget', () {
    testWidgets('shows loading indicator when state is Loading', (
      tester,
    ) async {
      when(mockCubit.state).thenReturn(DisplayConfigurationStateLoading());
      when(
        mockCubit.stream,
      ).thenAnswer((_) => Stream.value(DisplayConfigurationStateLoading()));

      await tester.pumpWidget(
        SettingsTestHelpers.buildSettingsWidget(
          displayCubit: mockCubit,
          child: const DisplaySettings(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('shows error text when error state', (tester) async {
      when(mockCubit.state).thenReturn(DisplayConfigurationStateError());
      when(
        mockCubit.stream,
      ).thenAnswer((_) => Stream.value(DisplayConfigurationStateError()));

      await tester.pumpWidget(
        SettingsTestHelpers.buildSettingsWidget(
          displayCubit: mockCubit,
          child: const DisplaySettings(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Service error'), findsWidgets);
    });

    testWidgets('shows configuration when settings fetched', (tester) async {
      final state = DisplayConfigurationStateSettingsFetched(
        resolutionPreset: DisplayResolutionModePreset.res720p,
        renderer: DisplayRendererType.mjpeg,
        isResponsive: true,
        quality: DisplayQualityPreset.quality80,
        refreshRate: DisplayRefreshRatePreset.refresh30hz,
      );

      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream.value(state));

      await tester.pumpWidget(
        SettingsTestHelpers.buildSettingsWidget(
          displayCubit: mockCubit,
          child: const DisplaySettings(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Renderer'), findsOneWidget);
      expect(find.text('Resolution'), findsOneWidget);
      expect(find.text('Image quality'), findsOneWidget);
      expect(find.text('Refresh rate'), findsOneWidget);
    });

    testWidgets('shows renderer dropdown with current value', (tester) async {
      final state = DisplayConfigurationStateSettingsFetched(
        resolutionPreset: DisplayResolutionModePreset.res720p,
        renderer: DisplayRendererType.mjpeg,
        isResponsive: true,
        quality: DisplayQualityPreset.quality80,
        refreshRate: DisplayRefreshRatePreset.refresh30hz,
      );

      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream.value(state));

      await tester.pumpWidget(
        SettingsTestHelpers.buildSettingsWidget(
          displayCubit: mockCubit,
          child: const DisplaySettings(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DropdownButton<DisplayRendererType>), findsOneWidget);
    });

    testWidgets('shows resolution dropdown with current value', (tester) async {
      final state = DisplayConfigurationStateSettingsFetched(
        resolutionPreset: DisplayResolutionModePreset.res720p,
        renderer: DisplayRendererType.mjpeg,
        isResponsive: true,
        quality: DisplayQualityPreset.quality80,
        refreshRate: DisplayRefreshRatePreset.refresh30hz,
      );

      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream.value(state));

      await tester.pumpWidget(
        SettingsTestHelpers.buildSettingsWidget(
          displayCubit: mockCubit,
          child: const DisplaySettings(),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byType(DropdownButton<DisplayResolutionModePreset>),
        findsOneWidget,
      );
    });

    testWidgets('shows quality dropdown with current value', (tester) async {
      final state = DisplayConfigurationStateSettingsFetched(
        resolutionPreset: DisplayResolutionModePreset.res720p,
        renderer: DisplayRendererType.mjpeg,
        isResponsive: true,
        quality: DisplayQualityPreset.quality80,
        refreshRate: DisplayRefreshRatePreset.refresh30hz,
      );

      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream.value(state));

      await tester.pumpWidget(
        SettingsTestHelpers.buildSettingsWidget(
          displayCubit: mockCubit,
          child: const DisplaySettings(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DropdownButton<DisplayQualityPreset>), findsOneWidget);
    });

    testWidgets('shows refresh rate dropdown', (tester) async {
      final state = DisplayConfigurationStateSettingsFetched(
        resolutionPreset: DisplayResolutionModePreset.res720p,
        renderer: DisplayRendererType.mjpeg,
        isResponsive: true,
        quality: DisplayQualityPreset.quality80,
        refreshRate: DisplayRefreshRatePreset.refresh30hz,
      );

      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream.value(state));

      await tester.pumpWidget(
        SettingsTestHelpers.buildSettingsWidget(
          displayCubit: mockCubit,
          child: const DisplaySettings(),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byType(DropdownButton<DisplayRefreshRatePreset>),
        findsOneWidget,
      );
    });

    testWidgets('shows responsive switch with current value', (tester) async {
      final state = DisplayConfigurationStateSettingsFetched(
        resolutionPreset: DisplayResolutionModePreset.res720p,
        renderer: DisplayRendererType.mjpeg,
        isResponsive: true,
        quality: DisplayQualityPreset.quality80,
        refreshRate: DisplayRefreshRatePreset.refresh30hz,
      );

      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream.value(state));

      await tester.pumpWidget(
        SettingsTestHelpers.buildSettingsWidget(
          displayCubit: mockCubit,
          child: const DisplaySettings(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Dynamic aspect ratio'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
    });
  });
}
