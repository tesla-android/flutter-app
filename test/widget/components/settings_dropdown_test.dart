import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tesla_android/common/ui/components/settings_dropdown.dart';

enum TestEnum {
  optionA,
  optionB;

  String name() => toString().split('.').last;
}

void main() {
  group('SettingsDropdown', () {
    testWidgets('renders correctly with given items', (WidgetTester tester) async {
      TestEnum? selectedValue = TestEnum.optionA;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return SettingsDropdown<TestEnum>(
                  value: selectedValue!,
                  items: TestEnum.values,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                  itemLabel: (item) => item.name(),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('optionA'), findsOneWidget);
      expect(find.byType(DropdownButton<TestEnum>), findsOneWidget);

      await tester.tap(find.text('optionA'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('optionB').last);
      await tester.pumpAndSettle();

      expect(selectedValue, TestEnum.optionB);
      expect(find.text('optionB'), findsOneWidget);
    });

    test('DisplayRendererTypeExt extension works', () {
       // Valid enum with name() method
       expect(TestEnum.optionA.displayName(), 'optionA');
       
       // Plain object
       final obj = Object();
       // The extension is on Object, so any object has .displayName()
       // But wait, the extension is defined in the file but not exported? 
       // It seems to be accessible if imported.
       
       expect(obj.displayName(), obj.toString());
    });
  });
}
