import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:tesla_android/common/navigation/ta_page_factory.dart';
import 'package:tesla_android/feature/home/widget/settings_button.dart';

void main() {
  setUp(() {
    final pageFactory = TAPageFactory();
    GetIt.I.registerSingleton<TAPageFactory>(pageFactory);
  });

  tearDown(() {
    GetIt.I.reset();
  });

  group('SettingsButton Widget', () {
    testWidgets('renders IconButton with settings icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SettingsButton())),
      );

      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('triggers navigation on tap', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const Scaffold(body: SettingsButton()),
          routes: {'/about': (context) => const Scaffold(body: Text('About'))},
        ),
      );

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      expect(find.text('About'), findsOneWidget);
    });
  });
}
