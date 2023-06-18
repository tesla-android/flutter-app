// ignore: avoid_web_libraries_in_flutter
import 'dart:async';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' show Geolocation, Geoposition, Permissions, window;
import 'dart:math' hide log;

import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/utils/logger.dart';
import 'package:tesla_android/feature/gps/util/web_location_data.dart';

@injectable
class WebLocation with Logger {
  final Geolocation _geolocation;
  final Permissions? _permissions;

  StreamController<WebLocationData>? _locationStreamController;
  Timer? _locationTimer;

  static const int _bufferSize = 5;
  final List<WebLocationData> _locationBuffer = [];

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
      const Duration(milliseconds: 1000),
      (Timer t) => getLocation(
              timeout: const Duration(milliseconds: 950),
              maximumAge: const Duration(milliseconds: 900))
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
    var data = WebLocationData(
      latitude: result.coords?.latitude?.toDouble(),
      longitude: result.coords?.longitude?.toDouble(),
      verticalAccuracy: result.coords?.accuracy?.toDouble(),
      time: result.timestamp?.toDouble(),
    );

    _locationBuffer.add(data);
    if (_locationBuffer.length > _bufferSize) {
      _locationBuffer.removeAt(0);
    }

    if (_locationBuffer.length >= 2) {
      for (int i = _locationBuffer.length - 2; i >= 0; i--) {
        final previousLocation = _locationBuffer[i];

        final previousLat = previousLocation.latitude;
        final previousLng = previousLocation.longitude;
        final currentLat = data.latitude;
        final currentLng = data.longitude;

        final distance = _calculateDistance(
            previousLat!, previousLng!, currentLat!, currentLng!);
        if (distance >= 5.0) {
          final elapsedTimeSec = (data.time! - previousLocation.time!) / 1000;

          final approximatedSpeed = distance / elapsedTimeSec;
          final approximatedBearing = _calculateBearing(
              previousLat, previousLng, currentLat, currentLng);
          data.addApproximatedData(
            approximatedSpeed: approximatedSpeed,
            approximatedBearing: approximatedBearing,
          );
          break;
        }
      }
    }
    return data;
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371;
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    lat1 = _degreesToRadians(lat1);
    lat2 = _degreesToRadians(lat2);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c * 1000;
  }

  double _calculateBearing(double lat1, double lon1, double lat2, double lon2) {
    lat1 = _degreesToRadians(lat1);
    lat2 = _degreesToRadians(lat2);
    double dLon = _degreesToRadians(lon2 - lon1);

    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);

    double bearing = _radiansToDegrees(atan2(y, x));

    return (bearing + 360) % 360;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  double _radiansToDegrees(double radians) {
    return radians * 180 / pi;
  }
}
