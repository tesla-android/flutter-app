import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tesla_android/common/network/configuration_service.dart';
import 'package:tesla_android/feature/settings/model/system_configuration_response_body.dart';

import '../../helpers/mock_services.mocks.dart';

void main() {
  group('ConfigurationService', () {
    late MockDio mockDio;
    late MockFlavor mockFlavor;
    late ConfigurationService service;

    setUp(() {
      mockDio = MockDio();
      mockFlavor = MockFlavor();

      when(
        mockFlavor.getString("configurationApiBaseUrl"),
      ).thenReturn("http://localhost");

      // Mock Dio's options to avoid NPEs if accessed by the service
      when(mockDio.options).thenReturn(BaseOptions());

      // Mock fetch method which is used by Retrofit
      // Retrofit uses fetch<T> internally
      when(mockDio.fetch<Map<String, dynamic>>(any)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: {},
          statusCode: 200,
        ),
      );

      service = ConfigurationService(mockDio, mockFlavor);
    });

    test('getConfiguration calls correct endpoint', () async {
      final responseData = {
        'persist.tesla-android.softap.band_type': 1,
        'persist.tesla-android.softap.channel': 6,
        'persist.tesla-android.softap.channel_width': 2,
        'persist.tesla-android.softap.is_enabled': 1,
        'persist.tesla-android.offline-mode.is_enabled': 0,
        'persist.tesla-android.offline-mode.telemetry.is_enabled': 1,
        'persist.tesla-android.offline-mode.tesla-firmware-downloads': 0,
        'persist.tesla-android.browser_audio.is_enabled': 1,
        'persist.tesla-android.browser_audio.volume': 100,
        'persist.tesla-android.gps.is_active': 1,
      };

      when(mockDio.fetch<Map<String, dynamic>>(any)).thenAnswer((
        invocation,
      ) async {
        return Response(
          requestOptions: RequestOptions(path: ''),
          data: responseData,
          statusCode: 200,
        );
      });

      final result = await service.getConfiguration();

      expect(result, isA<SystemConfigurationResponseBody>());
      expect(result.bandType, 1);

      verify(
        mockDio.fetch<Map<String, dynamic>>(
          argThat(
            predicate<RequestOptions>((options) {
              return options.method == 'GET' &&
                  options.path == '/configuration' &&
                  options.baseUrl == 'http://localhost';
            }),
          ),
        ),
      ).called(1);
    });

    test('setSoftApBand calls correct endpoint with body', () async {
      when(mockDio.fetch<dynamic>(any)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: null,
          statusCode: 200,
        ),
      );

      await service.setSoftApBand(1);

      verify(
        mockDio.fetch<dynamic>(
          argThat(
            predicate<RequestOptions>((options) {
              return options.method == 'POST' &&
                  options.path == '/softApBand' &&
                  options.data == 1;
            }),
          ),
        ),
      ).called(1);
    });

    test('getConfiguration handles network error', () async {
      when(mockDio.fetch<Map<String, dynamic>>(any)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/configuration'),
          type: DioExceptionType.connectionError,
          message: 'Network error',
        ),
      );

      expect(
        () async => await service.getConfiguration(),
        throwsA(isA<DioException>()),
      );
    });

    test('setSoftApBand handles server error', () async {
      when(mockDio.fetch<dynamic>(any)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/softApBand'),
          response: Response(
            requestOptions: RequestOptions(path: '/softApBand'),
            statusCode: 500,
            statusMessage: 'Internal Server Error',
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(
        () async => await service.setSoftApBand(1),
        throwsA(isA<DioException>()),
      );
    });
  });
}
