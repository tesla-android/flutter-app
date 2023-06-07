import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sentry_dio/sentry_dio.dart';

@module
abstract class NetworkModule {
  @singleton
  Dio get dio => Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
          sendTimeout: const Duration(seconds: 5),
        ),
      )..addSentry();
}
