import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:tesla_android/common/di/ta_locator.dart';
import 'package:tesla_android/common/navigation/ta_page_factory.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://c18dd8bef7c74eec8c6074e6f8c9fd09@sentry.teslaandroid.com/2';
      options.attachScreenshot = true;
      options.attachViewHierarchy = true;
    },
    appRunner: _runMyApp,
  );
}

Future<void> _runMyApp() async {
  await configureTADependencies();

  runApp(
    SentryScreenshotWidget(
      child: SentryUserInteractionWidget(
        child: TeslaAndroid(),
      ),
    ),
  );
}

class TeslaAndroid extends StatelessWidget {
  TeslaAndroid({Key? key}) : super(key: key);

  final TAPageFactory _pageFactory = getIt<TAPageFactory>();

  @override
  Widget build(BuildContext context) {
    MediaQueryData windowData =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window);

    final switchTheme = SwitchThemeData(
      trackColor:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        return Colors.red.withOpacity(.40);
      }),
      thumbColor:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return Colors.red.withOpacity(.60);
        }
        return Colors.red;
      }),
    );

    return MediaQuery(
      data: windowData.copyWith(textScaleFactor: 1.5),
      child: MaterialApp(
        useInheritedMediaQuery: true,
        debugShowCheckedModeBanner: false,
        navigatorKey: getIt<GlobalKey<NavigatorState>>(),
        title: 'Tesla Android',
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.red,
            switchTheme: switchTheme,
            fontFamily: 'Roboto'),
        darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.red,
            switchTheme: switchTheme,
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                selectedItemColor: Colors.red),
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
