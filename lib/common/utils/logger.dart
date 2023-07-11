// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:aptabase_flutter/aptabase_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:tesla_android/common/di/ta_locator.dart';

mixin Logger {
  void log(String message) {
    print("[$runtimeType $hashCode] $message" );
  }

  void logException({exception, StackTrace? stackTrace}) {
    print("[$runtimeType] ${exception.toString()}");
    print("[$runtimeType] ${stackTrace.toString()}");
  }

  void logExceptionAndUploadToSentry({exception, StackTrace? stackTrace}) {
    logException(exception: exception, stackTrace: stackTrace);
    Sentry.captureException(exception, stackTrace: stackTrace);
  }

  void dispatchAnalyticsEvent({required String eventName, required Map<String, dynamic> props}) {
    final userAgent = window.navigator.userAgent;
    final teslaSoftwareVersion = _getTeslaSoftwareInfo(userAgent) ?? "unknown";
    props.addAll({"userAgent": userAgent});
    props.addAll({"teslaSoftwareVersion": teslaSoftwareVersion});
    props.addAll({"viewportWidth": window.innerWidth});
    props.addAll({"viewportHeight": window.innerHeight});
    getIt<Aptabase>().trackEvent(eventName, props);
  }

  String? _getTeslaSoftwareInfo(String userAgent) {
    final pattern = RegExp(r'Tesla/(.*)');
    final match = pattern.firstMatch(userAgent);

    if (match != null) {
      final version = match.group(1);
      if(version != null) {
        final versionParts = version.split('-');
        final versionName = versionParts[1];
        return versionName;
      }
    }
    return null;
  }
}
