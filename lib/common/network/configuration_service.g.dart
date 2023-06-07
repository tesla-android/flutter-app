// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuration_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _ConfigurationService implements ConfigurationService {
  _ConfigurationService(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<SystemConfigurationResponseBody> getConfiguration() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SystemConfigurationResponseBody>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
      responseType: ResponseType.json,
    )
            .compose(
              _dio.options,
              '/configuration',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SystemConfigurationResponseBody.fromJson(_result.data!);
    return value;
  }

  @override
  Future<dynamic> setSoftApBand(band) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Content-Type': 'text/plain'};
    _headers.removeWhere((k, v) => v == null);
    final _data = band;
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'text/plain',
    )
        .compose(
          _dio.options,
          '/softApBand',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> setSoftApChannel(channel) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Content-Type': 'text/plain'};
    _headers.removeWhere((k, v) => v == null);
    final _data = channel;
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'text/plain',
    )
        .compose(
          _dio.options,
          '/softApChannel',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> setSoftApChannelWidth(channelWidth) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Content-Type': 'text/plain'};
    _headers.removeWhere((k, v) => v == null);
    final _data = channelWidth;
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'text/plain',
    )
        .compose(
          _dio.options,
          '/softApChannelWidth',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> setSoftApState(isEnabledFlag) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Content-Type': 'text/plain'};
    _headers.removeWhere((k, v) => v == null);
    final _data = isEnabledFlag;
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'text/plain',
    )
        .compose(
          _dio.options,
          '/softApState',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> setOfflineModeState(isEnabledFlag) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Content-Type': 'text/plain'};
    _headers.removeWhere((k, v) => v == null);
    final _data = isEnabledFlag;
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'text/plain',
    )
        .compose(
          _dio.options,
          '/offlineModeState',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> setOfflineModeTelemetryState(isEnabledFlag) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Content-Type': 'text/plain'};
    _headers.removeWhere((k, v) => v == null);
    final _data = isEnabledFlag;
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'text/plain',
    )
        .compose(
          _dio.options,
          '/offlineModeTelemetryState',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> setOfflineModeTeslaFirmwareDownloads(isEnabledFlag) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Content-Type': 'text/plain'};
    _headers.removeWhere((k, v) => v == null);
    final _data = isEnabledFlag;
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'text/plain',
    )
        .compose(
          _dio.options,
          '/offlineModeTeslaFirmwareDownloads',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
