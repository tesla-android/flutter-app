import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:tesla_android/feature/connectivityCheck/cubit/connectivity_check_cubit.dart';
import 'package:tesla_android/feature/connectivityCheck/model/connectivity_state.dart';
import 'package:tesla_android/feature/display/cubit/display_cubit.dart';
import 'package:tesla_android/feature/display/cubit/display_state.dart';
import 'package:tesla_android/feature/display/model/remote_display_state.dart';

import '../helpers/cubit_builders.dart';

void main() {
  group('Connectivity Flow', () {
    late ConnectivityCheckCubit mockConnectivityCubit;
    late DisplayCubit mockDisplayCubit;

    setUp(() {
      mockConnectivityCubit = CubitBuilders.buildConnectivityCheckCubit();
      mockDisplayCubit = CubitBuilders.buildDisplayCubit();
    });

    testWidgets('displays connected indicator when backend accessible', (
      WidgetTester tester,
    ) async {
      when(
        mockConnectivityCubit.state,
      ).thenReturn(ConnectivityState.backendAccessible);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ConnectivityCheckCubit>.value(
            value: mockConnectivityCubit,
            child: BlocBuilder<ConnectivityCheckCubit, ConnectivityState>(
              builder: (context, state) {
                return state == ConnectivityState.backendAccessible
                    ? const Icon(Icons.check_circle, key: Key('connected'))
                    : const Icon(Icons.error, key: Key('disconnected'));
              },
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('connected')), findsOneWidget);
      expect(find.byKey(const Key('disconnected')), findsNothing);
    });

    testWidgets('displays error indicator when backend not accessible', (
      WidgetTester tester,
    ) async {
      when(
        mockConnectivityCubit.state,
      ).thenReturn(ConnectivityState.backendUnreachable);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ConnectivityCheckCubit>.value(
            value: mockConnectivityCubit,
            child: BlocBuilder<ConnectivityCheckCubit, ConnectivityState>(
              builder: (context, state) {
                return state == ConnectivityState.backendAccessible
                    ? const Icon(Icons.check_circle, key: Key('connected'))
                    : const Icon(Icons.error, key: Key('disconnected'));
              },
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('disconnected')), findsOneWidget);
      expect(find.byKey(const Key('connected')), findsNothing);
    });

    testWidgets('display state reflects loading state correctly', (
      WidgetTester tester,
    ) async {
      when(mockDisplayCubit.state).thenReturn(DisplayStateInitial());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<DisplayCubit>.value(
            value: mockDisplayCubit,
            child: BlocBuilder<DisplayCubit, DisplayState>(
              builder: (context, state) {
                if (state is DisplayStateInitial) {
                  return const CircularProgressIndicator(key: Key('loading'));
                } else if (state is DisplayStateNormal) {
                  return const Text('Display Ready', key: Key('ready'));
                }
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('loading')), findsOneWidget);
    });

    testWidgets('display state shows ready when normal', (
      WidgetTester tester,
    ) async {
      when(mockDisplayCubit.state).thenReturn(
        DisplayStateNormal(
          viewSize: const Size(1280, 720),
          adjustedSize: const Size(1280, 720),
          rendererType: DisplayRendererType.mjpeg,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<DisplayCubit>.value(
            value: mockDisplayCubit,
            child: BlocBuilder<DisplayCubit, DisplayState>(
              builder: (context, state) {
                if (state is DisplayStateInitial) {
                  return const CircularProgressIndicator(key: Key('loading'));
                } else if (state is DisplayStateNormal) {
                  return const Text('Display Ready', key: Key('ready'));
                }
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('ready')), findsOneWidget);
    });
  });
}
