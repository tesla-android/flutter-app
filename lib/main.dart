
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tesla_android/common/di/ta_locator.dart';
import 'package:tesla_android/common/navigation/ta_page_factory.dart';
import 'package:tesla_android/common/ui/constants/ta_colors.dart';
import 'package:tesla_android/common/utils/logger.dart';

Future<void> main() async {
  await configureTADependencies();

  final FlutterExceptionHandler? defaultOnError = FlutterError.onError;

  FlutterError.onError = (FlutterErrorDetails details) {
    if (_isHotReloadJsInteropError(details)) {
      debugPrint(
        '[IGNORED] Hot-reload JS Interop null error:\n'
            '${details.exceptionAsString()}\n'
            '${details.stack}',
      );
      return;
    }

    if (defaultOnError != null) {
      defaultOnError(details);
    } else {
      FlutterError.dumpErrorToConsole(details);
    }
  };

  runApp(
    TeslaAndroid(),
  );
}

bool _isHotReloadJsInteropError(FlutterErrorDetails details) {
  if (!kDebugMode) return false;

  final msg = details.exceptionAsString();
  final stack = details.stack?.toString() ?? '';

  final isUnexpectedNull =
  msg.contains('DartError: Unexpected null value');

  final isFromVideoFrameHelper =
      stack.contains('video_frame_to_image.dart') ||
          stack.contains('js_allow_interop_patch.dart');

  return isUnexpectedNull && isFromVideoFrameHelper;
}

class TeslaAndroid extends StatelessWidget with Logger {
  TeslaAndroid({super.key});

  final TAPageFactory _pageFactory = getIt<TAPageFactory>();

  @override
  Widget build(BuildContext context) {
    MediaQueryData windowData = MediaQueryData.fromView(View.of(context));

    return MediaQuery(
      data: windowData.copyWith(devicePixelRatio: 1.0, textScaler: const TextScaler.linear(1.5)),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: getIt<GlobalKey<NavigatorState>>(),
        title: 'Tesla Android',
        theme: ThemeData(
            brightness: Brightness.light,
            useMaterial3: true,
            colorSchemeSeed: TAColors.settingsPrimaryColor,
            fontFamily: 'Roboto'),
        darkTheme: ThemeData(
            brightness: Brightness.dark,
            useMaterial3: true,
            colorSchemeSeed: TAColors.settingsPrimaryColor,
            fontFamily: 'Roboto'),
        themeMode: ThemeMode.system,
        initialRoute: _pageFactory.initialRoute,
        routes: _pageFactory.getRoutes(),
      ),
    );
  }
}
