import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:tesla_android/common/di/ta_locator.dart';
import 'package:tesla_android/common/navigation/ta_page_factory.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.debug = kDebugMode;
      options.dist = "1";
      options.dsn =
          'https://c18dd8bef7c74eec8c6074e6f8c9fd09@sentry.teslaandroid.com/2';
      options.attachScreenshot = true;
      options.attachViewHierarchy = false;
    },
    appRunner: _runMyApp,
  );
}

Future<void> _runMyApp() async {
  await configureTADependencies();

  runApp(
    SentryScreenshotWidget(
      child: TeslaAndroid(),
    ),
  );
}

class TeslaAndroid extends StatelessWidget {
  TeslaAndroid({Key? key}) : super(key: key);

  final TAPageFactory _pageFactory = getIt<TAPageFactory>();

  @override
  Widget build(BuildContext context) {
    MediaQueryData windowData =
        MediaQueryData.fromView(View.of(context));

    return MediaQuery(
      data: windowData.copyWith(textScaleFactor: 1.5, devicePixelRatio: 1.0),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: getIt<GlobalKey<NavigatorState>>(),
        title: 'Tesla Android',
        theme: ThemeData(
            brightness: Brightness.light,
            useMaterial3: true,
            colorSchemeSeed: Colors.red.shade900,
            fontFamily: 'Roboto'),
        darkTheme: ThemeData(
            brightness: Brightness.light,
            useMaterial3: true,
            colorSchemeSeed: Colors.red.shade900,
            fontFamily: 'Roboto'),
        themeMode: ThemeMode.system,
        initialRoute: _pageFactory.initialRoute,
        routes: _pageFactory.getRoutes(),
        navigatorObservers: [
          SentryNavigatorObserver(),
        ],
      ),
    );
  }
}
