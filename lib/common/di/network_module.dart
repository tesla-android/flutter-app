import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@module
abstract class NetworkModule {
  @singleton
  Dio get provideDio => Dio(BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 5000
  ));
}