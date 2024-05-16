mixin Logger {
  void log(String message) {
    print("[$runtimeType $hashCode] $message" );
  }

  void logException({exception, StackTrace? stackTrace}) {
    print("[$runtimeType] ${exception.toString()}");
    print("[$runtimeType] ${stackTrace.toString()}");
  }
}
