import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tesla_android/common/network/device_info_service.dart';
import 'package:tesla_android/feature/settings/model/device_info.dart';

import '../../helpers/mock_services.mocks.dart';

void main() {
  group('DeviceInfoService', () {
    late MockDio mockDio;
    late MockFlavor mockFlavor;
    late DeviceInfoService service;

    setUp(() {
      mockDio = MockDio();
      mockFlavor = MockFlavor();

      when(
        mockFlavor.getString("configurationApiBaseUrl"),
      ).thenReturn("http://localhost");

      when(mockDio.options).thenReturn(BaseOptions());

      service = DeviceInfoService(mockDio, mockFlavor);
    });

    test('getDeviceInfo calls correct endpoint', () async {
      final responseData = {
        'cpu_temperature': 45,
        'serial_number': '123456',
        'device_model': 'Raspberry Pi 4',
        'is_carplay_detected': 1,
        'is_modem_detected': 0,
        'release_type': 'stable',
        'ota_url': 'http://ota.url',
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

      final result = await service.getDeviceInfo();

      expect(result, isA<DeviceInfo>());
      expect(result.cpuTemperature, 45);
      expect(result.serialNumber, '123456');

      verify(
        mockDio.fetch<Map<String, dynamic>>(
          argThat(
            predicate<RequestOptions>((options) {
              return options.method == 'GET' &&
                  options.path == '/deviceInfo' &&
                  options.baseUrl == 'http://localhost';
            }),
          ),
        ),
      ).called(1);
    });

    test('openUpdater calls correct endpoint', () async {
      when(mockDio.fetch<dynamic>(any)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: null,
          statusCode: 200,
        ),
      );

      await service.openUpdater();

      verify(
        mockDio.fetch<dynamic>(
          argThat(
            predicate<RequestOptions>((options) {
              return options.method == 'GET' &&
                  options.path == '/openUpdater' &&
                  options.baseUrl == 'http://localhost';
            }),
          ),
        ),
      ).called(1);
    });

    test('getDeviceInfo handles timeout', () async {
      when(mockDio.fetch<Map<String, dynamic>>(any)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/deviceInfo'),
          type: DioExceptionType.receiveTimeout,
          message: 'Receive timeout',
        ),
      );

      expect(
        () async => await service.getDeviceInfo(),
        throwsA(isA<DioException>()),
      );
    });
  });
}
