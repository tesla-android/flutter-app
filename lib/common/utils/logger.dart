// ignore_for_file: avoid_print

import 'package:dio/dio.dart';

mixin Logger {
  void log(String message) {
    print("[$runtimeType $hashCode] $message");
  }

  void logException({dynamic exception, StackTrace? stackTrace}) {
    if (exception is DioException &&
        (exception.type == DioExceptionType.connectionError ||
            exception.type == DioExceptionType.unknown)) {
      print("[$runtimeType] Network Error: ${exception.message}");
      print(
        "[$runtimeType] Hint: If running locally without hardware, use '?mock=true' in the URL.",
      );
      return;
    }

    print("[$runtimeType] ${exception.toString()}");
    if (stackTrace != null) {
      print("[$runtimeType] ${stackTrace.toString()}");
    }
  }
}
