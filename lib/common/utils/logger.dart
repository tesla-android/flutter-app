import 'package:sentry_flutter/sentry_flutter.dart';

mixin Logger {
  void log(String message) {
    print("[$runtimeType] $message");
  }

  void logException({exception, StackTrace? stackTrace}) {
    print("[$runtimeType] ${exception.toString()}");
    print("[$runtimeType] ${stackTrace.toString()}");
  }

  void logExceptionAndUploadToSentry({exception, StackTrace? stackTrace}) {
    logException(exception: exception, stackTrace: stackTrace);
    Sentry.captureException(exception, stackTrace: stackTrace);
  }
}
