import 'package:flutter/foundation.dart';

mixin Logger {
  void log(String message) {
    if (kDebugMode) {
      print("[$runtimeType $hashCode] $message" );
    }
  }

  void logException({dynamic exception, StackTrace? stackTrace}) {
    if (kDebugMode) {
      print("[$runtimeType] ${exception.toString()}");
      print("[$runtimeType] ${stackTrace.toString()}");
    }
  }
}
