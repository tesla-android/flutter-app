import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tesla_android/common/network/health_service.dart';

import '../../helpers/mock_services.mocks.dart';

void main() {
  group('HealthService', () {
    late MockDio mockDio;
    late MockFlavor mockFlavor;
    late HealthService service;

    setUp(() {
      mockDio = MockDio();
      mockFlavor = MockFlavor();

      when(
        mockFlavor.getString("configurationApiBaseUrl"),
      ).thenReturn("http://localhost");

      when(mockDio.options).thenReturn(BaseOptions());

      service = HealthService(mockDio, mockFlavor);
    });

    test('getHealthCheck calls correct endpoint', () async {
      when(mockDio.fetch<dynamic>(any)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: null,
          statusCode: 200,
        ),
      );

      await service.getHealthCheck();

      verify(
        mockDio.fetch<dynamic>(
          argThat(
            predicate<RequestOptions>((options) {
              return options.method == 'GET' &&
                  options.path == '/health' &&
                  options.baseUrl == 'http://localhost';
            }),
          ),
        ),
      ).called(1);
    });

    test('getHealthCheck handles error response', () async {
      when(mockDio.fetch<dynamic>(any)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/health'),
          response: Response(
            requestOptions: RequestOptions(path: '/health'),
            statusCode: 503,
            statusMessage: 'Service Unavailable',
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(
        () async => await service.getHealthCheck(),
        throwsA(isA<DioException>()),
      );
    });

    test('getHealthCheck handles network timeout', () async {
      when(mockDio.fetch<dynamic>(any)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/health'),
          type: DioExceptionType.connectionTimeout,
          message: 'Connection timeout',
        ),
      );

      expect(
        () async => await service.getHealthCheck(),
        throwsA(isA<DioException>()),
      );
    });
  });
}
