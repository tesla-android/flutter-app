import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tesla_android/common/network/github_service.dart';
import 'package:tesla_android/feature/home/model/github_release.dart';

import '../../helpers/mock_services.mocks.dart';

void main() {
  group('GitHubService', () {
    late MockDio mockDio;
    late MockFlavor mockFlavor;
    late GitHubService service;

    setUp(() {
      mockDio = MockDio();
      mockFlavor = MockFlavor();

      // GitHubService uses hardcoded URL, but factory takes flavor
      service = GitHubService(mockDio, mockFlavor);

      when(mockDio.options).thenReturn(BaseOptions());
    });

    test('getLatestRelease calls correct endpoint', () async {
      final responseData = {
        'name': 'v2023.1.1',
        'body': 'Release notes...',
        'html_url': 'https://github.com/...',
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

      final result = await service.getLatestRelease();

      expect(result, isA<GitHubRelease>());
      expect(result.name, 'v2023.1.1');

      verify(
        mockDio.fetch<Map<String, dynamic>>(
          argThat(
            predicate<RequestOptions>((options) {
              return options.method == 'GET' &&
                  options.path ==
                      '/repos/tesla-android/android-raspberry-pi/releases/latest' &&
                  options.baseUrl == 'https://api.github.com' &&
                  options.headers['X-GitHub-Api-Version'] == '2022-11-28';
            }),
          ),
        ),
      ).called(1);
    });
  });
}
