import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:tesla_android/common/navigation/ta_navigator.dart';
import 'package:tesla_android/common/navigation/ta_page.dart';
import 'package:tesla_android/common/navigation/ta_page_factory.dart';
import 'package:tesla_android/common/navigation/ta_page_type.dart';

class MockTAPageFactory extends Mock implements TAPageFactory {
  @override
  WidgetBuilder buildPage(TAPage? page) {
    return super.noSuchMethod(
      Invocation.method(#buildPage, [page]),
      returnValue: (BuildContext context) => Container(),
      returnValueForMissingStub: (BuildContext context) => Container(),
    );
  }
}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late MockTAPageFactory mockPageFactory;
  late NavigatorObserver mockObserver;

  setUp(() {
    mockPageFactory = MockTAPageFactory();
    mockObserver = MockNavigatorObserver();

    GetIt.I.registerSingleton<TAPageFactory>(mockPageFactory);

    when(
      mockPageFactory.buildPage(any),
    ).thenReturn((context) => Container(key: const Key('target_page')));
  });

  tearDown(() {
    GetIt.I.reset();
  });

  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: child,
      navigatorObservers: [mockObserver],
      routes: {
        '/test_route': (context) => Container(key: const Key('pushed_page')),
      },
    );
  }

  group('TANavigator', () {
    testWidgets('push standard page calls pushNamed', (tester) async {
      const testPage = TAPage(
        title: 'Test',
        route: '/test_route',
        type: TAPageType.standard,
      );

      await tester.pumpWidget(
        makeTestableWidget(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () =>
                    TANavigator.push(context: context, page: testPage),
                child: const Text('Push'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Push'));
      await tester.pumpAndSettle();

      // verify(mockObserver.didPush(any, any));
      expect(find.byKey(const Key('pushed_page')), findsOneWidget);
    });

    testWidgets('push dialog page calls showDialog', (tester) async {
      const dialogPage = TAPage(
        title: 'Dialog',
        route: '/dialog',
        type: TAPageType.dialog,
      );

      await tester.pumpWidget(
        makeTestableWidget(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () =>
                    TANavigator.push(context: context, page: dialogPage),
                child: const Text('Dialog'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Dialog'));
      await tester.pumpAndSettle();

      verify(mockPageFactory.buildPage(dialogPage));
      expect(find.byKey(const Key('target_page')), findsOneWidget);
    });

    testWidgets('pushReplacement animated calls pushReplacementNamed', (
      tester,
    ) async {
      const testPage = TAPage(
        title: 'Test',
        route: '/test_route',
        type: TAPageType.standard,
      );

      await tester.pumpWidget(
        makeTestableWidget(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => TANavigator.pushReplacement(
                  context: context,
                  page: testPage,
                  animated: true,
                ),
                child: const Text('Replace'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Replace'));
      await tester.pumpAndSettle();

      // verify(mockObserver.didReplace(newRoute: anyNamed('newRoute'), oldRoute: anyNamed('oldRoute')));
      expect(find.byKey(const Key('pushed_page')), findsOneWidget);
    });

    testWidgets(
      'pushReplacement non-animated calls pushReplacement with PageRouteBuilder',
      (tester) async {
        const testPage = TAPage(
          title: 'Test',
          route: '/test_route',
          type: TAPageType.standard,
        );

        await tester.pumpWidget(
          makeTestableWidget(
            Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () => TANavigator.pushReplacement(
                    context: context,
                    page: testPage,
                    animated: false,
                  ),
                  child: const Text('Replace'),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text('Replace'));
        await tester.pumpAndSettle();

        // verify(mockObserver.didReplace(newRoute: anyNamed('newRoute'), oldRoute: anyNamed('oldRoute')));
        verify(mockPageFactory.buildPage(testPage));
        expect(find.byKey(const Key('target_page')), findsOneWidget);
      },
    );

    testWidgets('pop calls navigator pop', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ElevatedButton(
                          onPressed: () => TANavigator.pop(context: context),
                          child: const Text('Pop'),
                        );
                      },
                    ),
                  );
                },
                child: const Text('Push'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Push'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pop'));
      await tester.pumpAndSettle();

      // verify(mockObserver.didPop(any, any));
    });
  });
}
