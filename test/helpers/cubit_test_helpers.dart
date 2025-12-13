import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Shared test helpers for common cubit testing patterns
/// Reduces boilerplate in individual cubit test files
class CubitTestHelpers {
  /// Tests common cubit behavior: initial state and proper cleanup
  ///
  /// Usage:
  /// ```dart
  /// testCubitBasics<MyCubit, MyState>(
  ///   buildCubit: () => MyCubit(mockDep),
  ///   expectedInitialState: MyStateInitial(),
  /// );
  /// ```
  static void testCubitBasics<T extends BlocBase<S>, S>({
    required T Function() buildCubit,
    required S expectedInitialState,
    String? description,
  }) {
    group(description ?? 'Cubit basics', () {
      test('initial state is correct', () async {
        final cubit = buildCubit();
        expect(cubit.state, equals(expectedInitialState));
        await cubit.close();
      });

      test('close works properly', () async {
        final cubit = buildCubit();
        await cubit.close();
        expect(cubit.isClosed, true);
      });
    });
  }

  /// Tests that a cubit properly handles async operations
  /// Useful for testing repository call patterns
  static void testAsyncOperation<T extends BlocBase<S>, S>({
    required T Function() buildCubit,
    required Future<void> Function(T cubit) act,
    required void Function() verify,
    String? description,
  }) {
    test(description ?? 'async operation completes', () async {
      final cubit = buildCubit();
      await act(cubit);
      verify();
      await cubit.close();
    });
  }
}
