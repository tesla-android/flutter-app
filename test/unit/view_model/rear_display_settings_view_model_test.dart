import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tesla_android/feature/settings/bloc/rear_display_configuration_state.dart';
import 'package:tesla_android/feature/settings/view_model/rear_display_settings_view_model.dart';

void main() {
  group('RearDisplaySettingsViewModel', () {
    late RearDisplaySettingsViewModel viewModel;

    setUp(() {
      viewModel = RearDisplaySettingsViewModel();
    });

    group('state checking methods', () {
      test('isFetched returns true for SettingsFetched state', () {
        final state = RearDisplayConfigurationStateSettingsFetched(
          isRearDisplayEnabled: true,
          isRearDisplayPrioritised: false,
          isCurrentDisplayPrimary: true,
        );
        expect(viewModel.isFetched(state), true);
      });

      test('isLoading returns true for Loading state', () {
        final state = RearDisplayConfigurationStateLoading();
        expect(viewModel.isLoading(state), true);
      });

      test('isLoading returns true for UpdateInProgress state', () {
        final state = RearDisplayConfigurationStateSettingsUpdateInProgress();
        expect(viewModel.isLoading(state), true);
      });

      test('isError returns true for Error state', () {
        final state = RearDisplayConfigurationStateError();
        expect(viewModel.isError(state), true);
      });
    });

    group('value extraction methods', () {
      final fetchedState = RearDisplayConfigurationStateSettingsFetched(
        isRearDisplayEnabled: true,
        isRearDisplayPrioritised: false,
        isCurrentDisplayPrimary: true,
      );

      test(
        'getRearDisplayEnabled extracts enabled status from fetched state',
        () {
          expect(viewModel.getRearDisplayEnabled(fetchedState), true);
        },
      );

      test(
        'getRearDisplayPrioritised extracts priority from fetched state',
        () {
          expect(viewModel.getRearDisplayPrioritised(fetchedState), false);
        },
      );

      test(
        'getCurrentDisplayPrimary extracts primary status from fetched state',
        () {
          expect(viewModel.getCurrentDisplayPrimary(fetchedState), true);
        },
      );

      test('getRearDisplayEnabled returns null for non-fetched state', () {
        expect(
          viewModel.getRearDisplayEnabled(
            RearDisplayConfigurationStateLoading(),
          ),
          null,
        );
      });
    });

    group('buildStateWidget', () {
      test('calls onFetched for SettingsFetched state', () {
        final state = RearDisplayConfigurationStateSettingsFetched(
          isRearDisplayEnabled: true,
          isRearDisplayPrioritised: false,
          isCurrentDisplayPrimary: true,
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
