import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tesla_android/feature/settings/view_model/base_settings_view_model.dart';

// Test state classes
class TestState {}

class TestStateLoading extends TestState {}

class TestStateFetched extends TestState {
  final String value;
  TestStateFetched(this.value);
}

class TestStateError extends TestState {
  final String message;
  TestStateError(this.message);
}

// Concrete implementation for testing
class TestViewModel extends BaseSettingsViewModel<TestState> {
  @override
  bool isLoadingState(TestState state) => state is TestStateLoading;

  @override
  bool isFetchedState(TestState state) => state is TestStateFetched;

  @override
  bool isErrorState(TestState state) => state is TestStateError;

  String? getValue(TestState state) {
    if (state is TestStateFetched) {
      return state.value;
    }
    return null;
  }
}

void main() {
  group('BaseSettingsViewModel', () {
    late TestViewModel viewModel;

    setUp(() {
      viewModel = TestViewModel();
    });

    group('state type checking', () {
      test('isLoadingState returns true for loading state', () {
        expect(viewModel.isLoadingState(TestStateLoading()), true);
        expect(viewModel.isLoading(TestStateLoading()), true);
      });

      test('isLoadingState returns false for non-loading states', () {
        expect(viewModel.isLoadingState(TestStateFetched('test')), false);
        expect(viewModel.isLoadingState(TestStateError('error')), false);
      });

      test('isFetchedState returns true for fetched state', () {
        expect(viewModel.isFetchedState(TestStateFetched('test')), true);
        expect(viewModel.isFetched(TestStateFetched('test')), true);
      });

      test('isFetchedState returns false for non-fetched states', () {
        expect(viewModel.isFetchedState(TestStateLoading()), false);
        expect(viewModel.isFetchedState(TestStateError('error')), false);
      });

      test('isErrorState returns true for error state', () {
        expect(viewModel.isErrorState(TestStateError('error')), true);
        expect(viewModel.isError(TestStateError('error')), true);
      });

      test('isErrorState returns false for non-error states', () {
        expect(viewModel.isErrorState(TestStateLoading()), false);
        expect(viewModel.isErrorState(TestStateFetched('test')), false);
      });
    });

    group('buildStateWidget', () {
      test('returns onFetched widget when state is fetched', () {
        final widget = viewModel.buildStateWidget(
          state: TestStateFetched('test'),
          onFetched: () => const Text('Fetched'),
        );

        expect(widget, isA<Text>());
        expect((widget as Text).data, 'Fetched');
      });

      test('returns custom onLoading widget when state is loading', () {
        final widget = viewModel.buildStateWidget(
          state: TestStateLoading(),
          onFetched: () => const Text('Fetched'),
          onLoading: () => const Text('Loading...'),
        );

        expect(widget, isA<Text>());
        expect((widget as Text).data, 'Loading...');
      });

      test('returns CircularProgressIndicator by default for loading', () {
        final widget = viewModel.buildStateWidget(
          state: TestStateLoading(),
          onFetched: () => const Text('Fetched'),
        );

        expect(widget, isA<CircularProgressIndicator>());
      });

      test('returns custom onError widget when state is error', () {
        final widget = viewModel.buildStateWidget(
          state: TestStateError('Something went wrong'),
          onFetched: () => const Text('Fetched'),
          onError: () => const Text('Custom Error'),
        );

        expect(widget, isA<Text>());
        expect((widget as Text).data, 'Custom Error');
      });

      test('returns default error text when no onError provided', () {
        final widget = viewModel.buildStateWidget(
          state: TestStateError('error'),
          onFetched: () => const Text('Fetched'),
        );

        expect(widget, isA<Text>());
        expect((widget as Text).data, 'Service error');
      });

      test('returns SizedBox.shrink for unknown states', () {
        final widget = viewModel.buildStateWidget(
          state: TestState(), // Base state, not recognized
          onFetched: () => const Text('Fetched'),
        );

        expect(widget, isA<SizedBox>());
      });
    });

    group('concrete value extraction', () {
      test('getValue returns value from fetched state', () {
        expect(viewModel.getValue(TestStateFetched('hello')), 'hello');
      });

      test('getValue returns null for non-fetched states', () {
        expect(viewModel.getValue(TestStateLoading()), null);
        expect(viewModel.getValue(TestStateError('error')), null);
      });
    });
  });
}
