import 'package:flutter/material.dart';

/// Base class for settings view models
///
/// Provides common state handling patterns that reduce duplication across
/// settings widgets. Subclasses must implement the state type checking methods.
///
/// Example usage:
/// ```dart
/// class SoundSettingsViewModel extends BaseSettingsViewModel<AudioConfigurationState> {
///   @override
///   bool isLoadingState(AudioConfigurationState state) =>
///       state is AudioConfigurationStateLoading ||
///       state is AudioConfigurationStateSettingsUpdateInProgress;
///   // ...
/// }
/// ```
abstract class BaseSettingsViewModel<TState> {
  /// Check if the state represents a loading condition
  bool isLoadingState(TState state);

  /// Check if settings have been successfully fetched
  bool isFetchedState(TState state);

  /// Check if the state represents an error condition
  bool isErrorState(TState state);

  /// Builds the appropriate widget based on the current state
  ///
  /// Returns the widget from [onFetched] if data is available,
  /// [onLoading] widget during loading states (defaults to CircularProgressIndicator),
  /// [onError] widget for error states (defaults to error text),
  /// or an empty SizedBox for unknown states.
  Widget buildStateWidget({
    required TState state,
    required Widget Function() onFetched,
    Widget Function()? onLoading,
    Widget Function()? onError,
  }) {
    if (isFetchedState(state)) {
      return onFetched();
    } else if (isLoadingState(state)) {
      return onLoading?.call() ?? const CircularProgressIndicator();
    } else if (isErrorState(state)) {
      return onError?.call() ?? const Text("Service error");
    }
    return const SizedBox.shrink();
  }

  /// Convenience alias for state checking
  bool isLoading(TState state) => isLoadingState(state);

  /// Convenience alias for state checking
  bool isError(TState state) => isErrorState(state);

  /// Convenience alias for state checking
  bool isFetched(TState state) => isFetchedState(state);
}
