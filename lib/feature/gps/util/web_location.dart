import 'dart:async';
import 'dart:js_interop';

import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/utils/logger.dart';
import 'package:tesla_android/feature/gps/util/web_location_data.dart';
import 'package:web/web.dart';

@injectable
class WebLocation with Logger {
  final Geolocation _geolocation;
  final Permissions _permissions;

  StreamController<WebLocationData>? _locationStreamController;
  Timer? _locationTimer;

  WebLocation()
    : _geolocation = window.navigator.geolocation,
      _permissions = window.navigator.permissions;

  Future<WebLocationData> getLocation() {
    final completer = Completer<GeolocationPosition>();
    _geolocation.getCurrentPosition(
      (GeolocationPosition result) {
        completer.complete(result);
      }.toJS,
      () {
        completer.completeError(Exception('location error'));
      }.toJS,
      PositionOptions(),
    );

    return completer.future.then(_toLocationData);
  }

  Future<bool> getPermissionStatus() async {
    PermissionStatus result = await _permissions
        .query(_PermissionDescriptor(name: 'geolocation'))
        .toDart;

    switch (result.state) {
      case 'granted':
        return true;
      default:
        return false;
    }
  }

  Future<bool> requestPermission() async {
    try {
      final completer = Completer<GeolocationPosition>();
      _geolocation.getCurrentPosition(
        (GeolocationPosition result) {
          completer.complete(result);
        }.toJS,
        () {
          completer.completeError(Exception('location error'));
        }.toJS,
        PositionOptions(),
      );
      await completer.future;
      return true;
    } catch (exception, stackTrace) {
      logException(exception: exception, stackTrace: stackTrace);
      return false;
    }
  }

  Stream<WebLocationData> get locationStream {
    _locationStreamController ??= StreamController<WebLocationData>.broadcast(
      onListen: _startLocationUpdates,
      onCancel: _stopLocationUpdates,
    );
    return _locationStreamController!.stream;
  }

  void _startLocationUpdates() {
    _locationTimer ??= Timer.periodic(
      const Duration(milliseconds: 1000),
      (Timer t) => getLocation()
          .then((locationData) {
            _locationStreamController!.add(locationData);
          })
          .catchError((exception, stackTrace) {
            logException(exception: exception, stackTrace: stackTrace);
          }),
    );
  }

  void _stopLocationUpdates() {
    _locationTimer?.cancel();
    _locationTimer = null;
  }

  WebLocationData _toLocationData(GeolocationPosition result) {
    return WebLocationData(
      latitude: result.coords.latitude,
      longitude: result.coords.longitude,
      accuracy: result.coords.accuracy,
      speed: result.coords.speed ?? 0.0,
      heading: result.coords.heading ?? 0.0,
      time: result.timestamp,
    );
  }
}

// copied from https://github.com/dart-lang/web/commit/7604578eb538c471d438608673c037121d95dba5#diff-6f4c7956b6e25b547b16fc561e54d5e7d520d2c79a59ace4438c60913cc2b1a2L35-L40
extension type _PermissionDescriptor._(JSObject _) implements JSObject {
  external factory _PermissionDescriptor({required String name});

  external set name(String value);
  external String get name;
}
