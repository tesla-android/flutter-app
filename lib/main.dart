import 'dart:html';

import 'package:flutter/material.dart';
import 'package:tesla_android/common/di/ta_locator.dart';
import 'package:tesla_android/common/navigation/ta_page_factory.dart';
import 'package:tesla_android/common/ui/constants/ta_colors.dart';
import 'package:tesla_android/common/utils/logger.dart';

Future<void> main() async {
  await configureTADependencies();

  runApp(
    TeslaAndroid(),
  );
}

class TeslaAndroid extends StatelessWidget with Logger {
  TeslaAndroid({Key? key}) : super(key: key);

  final TAPageFactory _pageFactory = getIt<TAPageFactory>();

  @override
  Widget build(BuildContext context) {
    MediaQueryData windowData = MediaQueryData.fromView(View.of(context));

    return MediaQuery(
      data: windowData.copyWith(textScaleFactor: 1.5, devicePixelRatio: 1.0),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: getIt<GlobalKey<NavigatorState>>(),
        title: 'Tesla Android',
        theme: ThemeData(
            brightness: Brightness.light,
            useMaterial3: true,
            colorSchemeSeed: TAColors.SETTING_PRIMARY_COLOR,
            fontFamily: 'Roboto'),
        darkTheme: ThemeData(
            brightness: Brightness.dark,
            useMaterial3: true,
            colorSchemeSeed: TAColors.SETTING_PRIMARY_COLOR,
            fontFamily: 'Roboto'),
        themeMode: ThemeMode.system,
        initialRoute: _pageFactory.initialRoute,
        routes: _pageFactory.getRoutes(),
      ),
    );
  }
}
