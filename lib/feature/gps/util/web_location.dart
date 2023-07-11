import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' show Geolocation, Geoposition, Permissions, window;

import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/utils/logger.dart';
import 'package:tesla_android/feature/gps/util/web_location_data.dart';

@injectable
class WebLocation with Logger {
  final Geolocation _geolocation;
  final Permissions? _permissions;

  StreamController<WebLocationData>? _locationStreamController;
  Timer? _locationTimer;

  WebLocation()
      : _geolocation = window.navigator.geolocation,
        _permissions = window.navigator.permissions;

  Future<WebLocationData> getLocation({
    Duration? maximumAge,
    Duration? timeout,
  }) {
    return _geolocation
        .getCurrentPosition(
          enableHighAccuracy: true,
          maximumAge: maximumAge,
          timeout: timeout,
        )
        .then(_toLocationData);
  }

  Future<bool> getPermissionStatus() async {
    final result = await _permissions?.query(
      <String, String>{
        'name': 'geolocation',
      },
    );

    switch (result?.state) {
      case 'granted':
        return true;
      default:
        return false;
    }
  }

  Future<bool> requestPermission() async {
    try {
      await _geolocation.getCurrentPosition();
      return true;
    } catch (exception, stackTrace) {
      logException(
        exception: exception,
        stackTrace: stackTrace,
      );
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
      const Duration(milliseconds: 500),
      (Timer t) => getLocation(
              timeout: const Duration(milliseconds: 450),
              maximumAge: const Duration(milliseconds: 450))
          .then((locationData) {
        _locationStreamController!.add(locationData);
      }).catchError((error) {
        // I do not care about failures
      }),
    );
  }

  void _stopLocationUpdates() {
    _locationTimer?.cancel();
    _locationTimer = null;
  }

  WebLocationData _toLocationData(Geoposition result) {
    return WebLocationData(
      latitude: result.coords?.latitude?.toDouble(),
      longitude: result.coords?.longitude?.toDouble(),
      verticalAccuracy: result.coords?.accuracy?.toDouble(),
    );
  }
}