import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tesla_android/feature/settings/bloc/system_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/system_configuration_state.dart';
import 'package:tesla_android/feature/settings/widget/hotspot_settings.dart';
import 'package:tesla_android/feature/settings/model/softap_band_type.dart';

import '../../helpers/mock_cubits.mocks.dart';
import '../../helpers/test_fixtures.dart';

void main() {
  late MockSystemConfigurationCubit mockCubit;

  setUp(() {
    mockCubit = MockSystemConfigurationCubit();
  });

  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<SystemConfigurationCubit>.value(
          value: mockCubit,
          child: child,
        ),
      ),
    );
  }

  group('HotspotSettings Widget', () {
    testWidgets('shows loading indicator when state is not fetched/modified', (
      tester,
    ) async {
      when(mockCubit.state).thenReturn(SystemConfigurationStateInitial());
      when(
        mockCubit.stream,
      ).thenAnswer((_) => Stream.value(SystemConfigurationStateInitial()));

      await tester.pumpWidget(makeTestableWidget(const HotspotSettings()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows configuration when state is Fetched', (tester) async {
      final config = TestFixtures.systemConfiguration;
      final state = SystemConfigurationStateSettingsFetched(
        currentConfiguration: config,
      );

      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream.value(state));

      await tester.pumpWidget(makeTestableWidget(const HotspotSettings()));
      await tester.pumpAndSettle();

      // Verify Dropdown for Band Type
      expect(find.text('Frequency band and channel'), findsOneWidget);
      // Verify Switches (Offline mode, Telemetry, Updates)
      expect(find.text('Offline mode'), findsOneWidget);
      expect(find.text('Tesla Telemetry'), findsOneWidget);
      expect(find.text('Tesla Software Updates'), findsOneWidget);

      // Verify loading indicator is gone
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('calls updateSoftApBand when dropdown changed', (tester) async {
      final config =
          TestFixtures.systemConfiguration; // Default band is 1 (2.4GHz)
      final state = SystemConfigurationStateSettingsFetched(
        currentConfiguration: config,
      );

      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream.value(state));

      await tester.pumpWidget(makeTestableWidget(const HotspotSettings()));
      await tester.pumpAndSettle();

      // Find dropdown and tap it
      final dropdownFinder = find.byType(DropdownButton<SoftApBandType>);
      await tester.tap(dropdownFinder);
      await tester.pumpAndSettle();

      // Select 5GHz (assuming it's in the list)
      final itemFinder = find.text('5 GHZ - Channel 36').last;

      await tester.tap(itemFinder);
      await tester.pumpAndSettle();

      verify(mockCubit.updateSoftApBand(SoftApBandType.band5GHz36)).called(1);
    });
  });
}
