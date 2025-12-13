import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tesla_android/feature/settings/bloc/audio_configuration_state.dart';
import 'package:tesla_android/feature/settings/view_model/sound_settings_view_model.dart';

void main() {
  group('SoundSettingsViewModel', () {
    late SoundSettingsViewModel viewModel;

    setUp(() {
      viewModel = SoundSettingsViewModel();
    });

    group('state checking methods', () {
      test('isFetched returns true for SettingsFetched state', () {
        final state = AudioConfigurationStateSettingsFetched(
          isEnabled: true,
          volume: 50,
        );
        expect(viewModel.isFetched(state), true);
      });

      test('isLoading returns true for Loading state', () {
        final state = AudioConfigurationStateLoading();
        expect(viewModel.isLoading(state), true);
      });

      test('isLoading returns true for UpdateInProgress state', () {
        final state = AudioConfigurationStateSettingsUpdateInProgress();
        expect(viewModel.isLoading(state), true);
      });

      test('isError returns true for Error state', () {
        final state = AudioConfigurationStateError();
        expect(viewModel.isError(state), true);
      });
    });

    group('value extraction methods', () {
      final fetchedState = AudioConfigurationStateSettingsFetched(
        isEnabled: true,
        volume: 75,
      );

      test('getAudioEnabled extracts enabled status from fetched state', () {
        expect(viewModel.getAudioEnabled(fetchedState), true);
      });

      test('getVolume extracts volume from fetched state', () {
        expect(viewModel.getVolume(fetchedState), 75);
      });

      test('getAudioEnabled returns null for non-fetched state', () {
        expect(
          viewModel.getAudioEnabled(AudioConfigurationStateLoading()),
          null,
        );
      });

      test('getVolume returns null for non-fetched state', () {
        expect(viewModel.getVolume(AudioConfigurationStateLoading()), null);
      });
    });

    group('buildStateWidget', () {
      test('calls onFetched for SettingsFetched state', () {
        final state = AudioConfigurationStateSettingsFetched(
          isEnabled: true,
          volume: 50,
        );

        bool onFetchedCalled = false;
        viewModel.buildStateWidget(
          state: state,
          onFetched: () {
            onFetchedCalled = true;
            return const SizedBox.shrink();
          },
        );

        expect(onFetchedCalled, true);
      });
    });
  });
}
