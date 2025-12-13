import 'package:flutter/material.dart';
import 'package:tesla_android/common/di/ta_locator.dart';
import 'package:tesla_android/common/navigation/ta_page_factory.dart';
import 'package:tesla_android/common/ui/constants/ta_colors.dart';
import 'package:tesla_android/common/utils/logger.dart';

Future<void> main() async {
  await configureTADependencies();

  runApp(TeslaAndroid());
}

class TeslaAndroid extends StatelessWidget with Logger {
  TeslaAndroid({super.key});

  final TAPageFactory _pageFactory = getIt<TAPageFactory>();

  @override
  Widget build(BuildContext context) {
    MediaQueryData windowData = MediaQueryData.fromView(View.of(context));

    return MediaQuery(
      data: windowData.copyWith(
        devicePixelRatio: 1.0,
        textScaler: const TextScaler.linear(1.5),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: getIt<GlobalKey<NavigatorState>>(),
        title: 'Tesla Android',
        theme: ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
          colorSchemeSeed: TAColors.settingsPrimaryColor,
          fontFamily: 'Roboto',
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          colorSchemeSeed: TAColors.settingsPrimaryColor,
          fontFamily: 'Roboto',
        ),
        themeMode: ThemeMode.system,
        initialRoute: _pageFactory.initialRoute,
        routes: _pageFactory.getRoutes(),
      ),
    );
  }
}
