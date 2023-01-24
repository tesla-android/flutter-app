import 'package:flutter/material.dart';
import 'package:tesla_android/common/di/ta_locator.dart';
import 'package:tesla_android/common/navigation/ta_page_factory.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureTADependencies();
  runApp(const TeslaAndroid());
}

class TeslaAndroid extends StatefulWidget {
  const TeslaAndroid({Key? key}) : super(key: key);

  @override
  _TeslaAndroidState createState() => _TeslaAndroidState();
}

class _TeslaAndroidState extends State<TeslaAndroid> {
  final TAPageFactory _pageFactory = getIt<TAPageFactory>();

  @override
  Widget build(BuildContext context) {
    MediaQueryData windowData =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return MediaQuery(
      data: windowData.copyWith(textScaleFactor: 1.5),
      child: MaterialApp(
        useInheritedMediaQuery: true,
        debugShowCheckedModeBanner: false,
        navigatorKey: GlobalKey<NavigatorState>(),
        title: 'Tesla Android',
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.red,
            fontFamily: 'Roboto'),
        darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.red,
            fontFamily: 'Roboto'),
        themeMode: ThemeMode.system,
        initialRoute: _pageFactory.initialRoute,
        routes: _pageFactory.getRoutes(),
      ),
    );
  }
}
