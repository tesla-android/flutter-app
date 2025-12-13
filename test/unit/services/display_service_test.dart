import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tesla_android/common/network/display_service.dart';
import 'package:tesla_android/feature/display/model/remote_display_state.dart';

import '../../helpers/mock_services.mocks.dart';

void main() {
  group('DisplayService', () {
    late MockDio mockDio;
    late MockFlavor mockFlavor;
    late DisplayService service;

    setUp(() {
      mockDio = MockDio();
      mockFlavor = MockFlavor();

      when(
        mockFlavor.getString("configurationApiBaseUrl"),
      ).thenReturn("http://localhost");

      when(mockDio.options).thenReturn(BaseOptions());

      service = DisplayService(mockDio, mockFlavor);
    });

    test('getDisplayState calls correct endpoint', () async {
      final responseData = {
        'width': 1920,
        'height': 1080,
        'density': 160,
        'resolutionPreset': 1, // 720p
        'renderer': 0, // mjpeg
        'isResponsive': 1,
        'isH264': 0,
        'refreshRate': 60,
        'quality': 90,
        'isRearDisplayEnabled': 0,
        'isRearDisplayPrioritised': 0,
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

      final result = await service.getDisplayState();

      expect(result, isA<RemoteDisplayState>());
      expect(result.width, 1920);
      expect(result.height, 1080);

      verify(
        mockDio.fetch<Map<String, dynamic>>(
          argThat(
            predicate<RequestOptions>((options) {
              return options.method == 'GET' &&
                  options.path == '/displayState' &&
                  options.baseUrl == 'http://localhost';
            }),
          ),
        ),
      ).called(1);
    });

    test(
      'updateDisplayConfiguration calls correct endpoint with body',
      () async {
        final config = RemoteDisplayState(
          width: 1280,
          height: 720,
          density: 160,
          refreshRate: DisplayRefreshRatePreset.refresh30hz,
          resolutionPreset: DisplayResolutionModePreset.res720p,
          renderer: DisplayRendererType.mjpeg,
          isResponsive: 1,
          isH264: 0,
          quality: DisplayQualityPreset.quality90,
          isRearDisplayEnabled: 0,
          isRearDisplayPrioritised: 0,
        );

        when(mockDio.fetch<dynamic>(any)).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: null,
            statusCode: 200,
          ),
        );

        await service.updateDisplayConfiguration(config);

        verify(
          mockDio.fetch<dynamic>(
            argThat(
              predicate<RequestOptions>((options) {
                return options.method == 'POST' &&
                    options.path == '/displayState' &&
                    options.baseUrl == 'http://localhost' &&
                    options.headers['Content-Type'] == 'application/json';
              }),
            ),
          ),
        ).called(1);
      },
    );
  });
}
