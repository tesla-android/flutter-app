import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tesla_android/feature/settings/bloc/rear_display_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/rear_display_configuration_state.dart';
import 'package:tesla_android/feature/settings/widget/rear_display_settings.dart';

import '../../helpers/mock_cubits.mocks.dart';

void main() {
  late MockRearDisplayConfigurationCubit mockCubit;

  setUp(() {
    mockCubit = MockRearDisplayConfigurationCubit();
  });

  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<RearDisplayConfigurationCubit>.value(
          value: mockCubit,
          child: child,
        ),
      ),
    );
  }

  group('RearDisplaySettings Widget', () {
    testWidgets('shows loading indicator when loading', (tester) async {
      when(mockCubit.state).thenReturn(RearDisplayConfigurationStateLoading());
      when(
        mockCubit.stream,
      ).thenAnswer((_) => Stream.value(RearDisplayConfigurationStateLoading()));

      await tester.pumpWidget(makeTestableWidget(const RearDisplaySettings()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error text when error state', (tester) async {
      when(mockCubit.state).thenReturn(RearDisplayConfigurationStateError());
      when(
        mockCubit.stream,
      ).thenAnswer((_) => Stream.value(RearDisplayConfigurationStateError()));

      await tester.pumpWidget(makeTestableWidget(const RearDisplaySettings()));
      await tester.pumpAndSettle();

      expect(find.text('Service error'), findsWidgets);
    });

    testWidgets('shows rear display switch when settings fetched', (
      tester,
    ) async {
      final state = RearDisplayConfigurationStateSettingsFetched(
        isRearDisplayEnabled: false,
        isCurrentDisplayPrimary: false,
        isRearDisplayPrioritised: false,
      );

      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream.value(state));

      await tester.pumpWidget(makeTestableWidget(const RearDisplaySettings()));
      await tester.pumpAndSettle();

      expect(find.text('Rear Display Support'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('shows additional settings when rear display enabled', (
      tester,
    ) async {
      final state = RearDisplayConfigurationStateSettingsFetched(
        isRearDisplayEnabled: true,
        isCurrentDisplayPrimary: true,
        isRearDisplayPrioritised: false,
      );

      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream.value(state));

      await tester.pumpWidget(makeTestableWidget(const RearDisplaySettings()));
      await tester.pumpAndSettle();

      expect(find.text('Primary Display'), findsOneWidget);
      expect(find.text('Rear Display Priority'), findsOneWidget);
      expect(find.byType(Switch), findsNWidgets(3)); // 3 switches total
    });

    testWidgets('calls setRearDisplayState when toggling rear display switch', (
      tester,
    ) async {
      final state = RearDisplayConfigurationStateSettingsFetched(
        isRearDisplayEnabled: false,
        isCurrentDisplayPrimary: false,
        isRearDisplayPrioritised: false,
      );

      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream.value(state));

      await tester.pumpWidget(makeTestableWidget(const RearDisplaySettings()));
      await tester.pumpAndSettle();

      final switchFinder = find.byType(Switch);
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      verify(mockCubit.setRearDisplayState(true)).called(1);
    });

    testWidgets('calls setDisplayType when toggling primary display switch', (
      tester,
    ) async {
      final state = RearDisplayConfigurationStateSettingsFetched(
        isRearDisplayEnabled: true,
        isCurrentDisplayPrimary: false,
        isRearDisplayPrioritised: false,
      );

      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream.value(state));

      await tester.pumpWidget(makeTestableWidget(const RearDisplaySettings()));
      await tester.pumpAndSettle();

      // Find the primary display switch (second switch in the list)
      final switches = find.byType(Switch);
      await tester.tap(switches.at(1));
      await tester.pumpAndSettle();

      verify(mockCubit.setDisplayType(isCurrentDisplayPrimary: true)).called(1);
    });

    testWidgets(
      'calls setRearDisplayPrioritization when toggling priority switch',
      (tester) async {
        final state = RearDisplayConfigurationStateSettingsFetched(
          isRearDisplayEnabled: true,
          isCurrentDisplayPrimary: true,
          isRearDisplayPrioritised: false,
        );

        when(mockCubit.state).thenReturn(state);
        when(mockCubit.stream).thenAnswer((_) => Stream.value(state));

        await tester.pumpWidget(
          makeTestableWidget(const RearDisplaySettings()),
        );
        await tester.pumpAndSettle();

        // Find the priority switch (third switch in the list)
        final switches = find.byType(Switch);
        await tester.tap(switches.at(2));
        await tester.pumpAndSettle();

        verify(mockCubit.setRearDisplayPrioritization(true)).called(1);
      },
    );
  });
}
