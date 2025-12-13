import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tesla_android/feature/home/cubit/ota_update_cubit.dart';
import 'package:tesla_android/feature/home/cubit/ota_update_state.dart';
import 'package:tesla_android/feature/home/widget/update_button.dart';

import '../../helpers/cubit_builders.dart';
import '../../helpers/mock_cubits.mocks.dart';

void main() {
  late MockOTAUpdateCubit mockOTAUpdateCubit;

  setUp(() {
    mockOTAUpdateCubit = CubitBuilders.buildOTAUpdateCubit();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<OTAUpdateCubit>(
          create: (_) => mockOTAUpdateCubit,
          child: const UpdateButton(),
        ),
      ),
    );
  }

  testWidgets('UpdateButton renders nothing when state is not Available', (
    WidgetTester tester,
  ) async {
    when(mockOTAUpdateCubit.state).thenReturn(OTAUpdateStateInitial());

    await tester.pumpWidget(buildTestWidget());

    expect(find.byType(IconButton), findsNothing);
    expect(find.byType(SizedBox), findsOneWidget);
  });

  testWidgets('UpdateButton renders button when state is Available', (
    WidgetTester tester,
  ) async {
    when(
      mockOTAUpdateCubit.state,
    ).thenReturn(OTAUpdateStateAvailable());

    await tester.pumpWidget(buildTestWidget());

    expect(find.byType(IconButton), findsOneWidget);
    expect(find.byIcon(Icons.download_rounded), findsOneWidget);
  });

  testWidgets('UpdateButton calls launchUpdater on tap', (
    WidgetTester tester,
  ) async {
    when(mockOTAUpdateCubit.state).thenReturn(OTAUpdateStateAvailable());

    await tester.pumpWidget(buildTestWidget());

    await tester.tap(find.byType(IconButton));
    await tester.pump();

    verify(mockOTAUpdateCubit.launchUpdater()).called(1);
  });
}
