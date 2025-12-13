import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tesla_android/feature/display/model/remote_display_state.dart';
import 'package:tesla_android/feature/settings/bloc/display_configuration_state.dart';
import 'package:tesla_android/feature/settings/view_model/display_settings_view_model.dart';

void main() {
  group('DisplaySettingsViewModel', () {
    late DisplaySettingsViewModel viewModel;

    setUp(() {
      viewModel = DisplaySettingsViewModel();
    });

    group('state checking methods', () {
      test('isFetched returns true for SettingsFetched state', () {
        final state = DisplayConfigurationStateSettingsFetched(
          resolutionPreset: DisplayResolutionModePreset.res720p,
          renderer: DisplayRendererType.mjpeg,
          isResponsive: true,
          quality: DisplayQualityPreset.quality80,
          refreshRate: DisplayRefreshRatePreset.refresh30hz,
        );

        expect(viewModel.isFetched(state), true);
      });

      test('isLoading returns true for Loading state', () {
        final state = DisplayConfigurationStateLoading();
        expect(viewModel.isLoading(state), true);
      });

      test('isLoading returns true for UpdateInProgress state', () {
        final state = DisplayConfigurationStateSettingsUpdateInProgress();
        expect(viewModel.isLoading(state), true);
      });

      test('isError returns true for Error state', () {
        final state = DisplayConfigurationStateError();
        expect(viewModel.isError(state), true);
      });
    });

    group('value extraction methods', () {
      final fetchedState = DisplayConfigurationStateSettingsFetched(
        resolutionPreset: DisplayResolutionModePreset.res720p,
        renderer: DisplayRendererType.h264WebCodecs,
        isResponsive: false,
        quality: DisplayQualityPreset.quality60,
        refreshRate: DisplayRefreshRatePreset.refresh60hz,
      );

      test('getRenderer extracts renderer from fetched state', () {
        expect(
          viewModel.getRenderer(fetchedState),
          DisplayRendererType.h264WebCodecs,
        );
      });

      test('getResolutionPreset extracts resolution from fetched state', () {
        expect(
          viewModel.getResolutionPreset(fetchedState),
          DisplayResolutionModePreset.res720p,
        );
      });

      test('getQualityPreset extracts quality from fetched state', () {
        expect(
          viewModel.getQualityPreset(fetchedState),
          DisplayQualityPreset.quality60,
        );
      });

      test('getRefreshRate extracts refresh rate from fetched state', () {
        expect(
          viewModel.getRefreshRate(fetchedState),
          DisplayRefreshRatePreset.refresh60hz,
        );
      });

      test('getResponsiveness extracts responsiveness from fetched state', () {
        expect(viewModel.getResponsiveness(fetchedState), false);
      });

      test('getRenderer returns null for non-fetched state', () {
        expect(viewModel.getRenderer(DisplayConfigurationStateLoading()), null);
      });
    });

    group('buildStateWidget', () {
      test('calls onFetched for SettingsFetched state', () {
        final state = DisplayConfigurationStateSettingsFetched(
          resolutionPreset: DisplayResolutionModePreset.res720p,
          renderer: DisplayRendererType.mjpeg,
          isResponsive: true,
          quality: DisplayQualityPreset.quality80,
          refreshRate: DisplayRefreshRatePreset.refresh30hz,
        );

        bool onFetchedCalled = false;
        viewModel.buildStateWidget(
          state: state,
          onFetched: () {
            onFetchedCalled = true;
            return Container();
          },
        );

        expect(onFetchedCalled, true);
      });
    });
  });
}
