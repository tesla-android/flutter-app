import 'dart:async';
import 'dart:collection';
import 'dart:html';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesla_android/common/utils/logger.dart';
import 'package:tesla_android/feature/gps/cubit/gps_state.dart';
import 'package:tesla_android/feature/gps/model/gps_data.dart';
import 'package:tesla_android/feature/gps/transport/gps_transport.dart';
import 'package:tesla_android/feature/gps/util/web_location.dart';

@injectable
class GpsCubit extends Cubit<GpsState> with Logger {
  final SharedPreferences _sharedPreferences;
  final WebLocation _location;
  final GpsTransport _gpsTransport;

  static const _sharedPreferencesKey = 'GpsCubit_isEnabled';

  StreamSubscription? _locationUpdatesStreamSubscription;
  final Queue<int> _locationUpdateTimestamps = Queue<int>();

  GpsCubit(this._sharedPreferences, this._location, this._gpsTransport)
      : super(GpsStateInitial()) {
    _setInitialState();
    _gpsTransport.connect();
  }

  @override
  Future<void> close() {
    _gpsTransport.disconnect();
    _locationUpdatesStreamSubscription?.cancel();
    _locationUpdatesStreamSubscription = null;
    return super.close();
  }

  Future<void> enableGps() async {
    try {
      await _checkGpsPermission().timeout(const Duration(seconds: 30));
    } catch (exception, stacktrace) {
      emit(GpsStateInitialisationError());
      if (exception is TimeoutException) {
        log("Timed out waiting for GPS init");
      } else {
        logExceptionAndUploadToSentry(
            exception: exception, stackTrace: stacktrace);
      }
    }
  }

  void disableGPS() {
    _gpsTransport.disconnect();
    _locationUpdatesStreamSubscription?.cancel();
    _locationUpdatesStreamSubscription = null;
    _sharedPreferences.setBool(_sharedPreferencesKey, false);
    emit(GpsStateManuallyDisabled());
  }

  void _setInitialState() {
    final shouldEnable =
        _sharedPreferences.getBool(_sharedPreferencesKey) ?? true;
    if (shouldEnable) {
      _sharedPreferences.setBool(_sharedPreferencesKey, true);
      enableGps();
    } else {
      disableGPS();
    }
  }

  Future<void> _checkGpsPermission() async {
    final gpsPermissionStatus = await _location.getPermissionStatus();
    if (gpsPermissionStatus == false) {
      var gpsPermissionRequested = await _location.requestPermission();
      gpsPermissionRequested = await _location.getPermissionStatus();
      if (gpsPermissionRequested) {
        _onLocationPermissionGranted();
        return;
      }
      emit(GpsStatePermissionNotGranted());
      return;
    }
    _onLocationPermissionGranted();
  }

  void _onLocationPermissionGranted() {
    emit(GpsStateActive(currentLocation: initialLocationData));
    _emitCurrentLocation();
    _subscribeToLocationUpdates();
    return;
  }

  void _emitCurrentLocation() async {
    try {
      final location = await _location.getLocation();
      emit(GpsStateActive(currentLocation: location));
      _gpsTransport.sendJson(GpsData.fromLocationData(location));
    } catch (exception, stacktrace) {
      if (exception is PositionError) {
        logException(exception: exception, stackTrace: stacktrace);
        return;
      }
      logExceptionAndUploadToSentry(
          exception: exception, stackTrace: stacktrace);
    }
  }

  void _subscribeToLocationUpdates() async {
    _locationUpdatesStreamSubscription =
        _location.locationStream.listen((locationData) async {
          _registerLocationUpdate();

          final averageUpdateInterval =
          _calculateAverageUpdateIntervalInSeconds();

          emit(GpsStateActive(
            currentLocation: locationData,
            averageUpdateIntervalInSeconds: averageUpdateInterval,
          ));

          _gpsTransport.sendJson(GpsData.fromLocationData(locationData));
        });
  }

  void _registerLocationUpdate() {
    final currentTimestamp = DateTime.now().millisecondsSinceEpoch;

    _locationUpdateTimestamps.addLast(currentTimestamp);

    // Remove timestamps older than 60 seconds
    final oneMinuteAgo = currentTimestamp - 60000;
    while (_locationUpdateTimestamps.first < oneMinuteAgo) {
      _locationUpdateTimestamps.removeFirst();
    }
  }

  double _calculateAverageUpdateIntervalInSeconds() {
    final totalUpdates = _locationUpdateTimestamps.length;
    if (totalUpdates < 2) {
      return 0;
    }

    final oldestUpdateTimestamp = _locationUpdateTimestamps.first;
    final newestUpdateTimestamp = _locationUpdateTimestamps.last;
    final totalDurationInSeconds =
        (newestUpdateTimestamp - oldestUpdateTimestamp) / 1000;

    final result = totalDurationInSeconds / (totalUpdates - 1);

    return result;
  }
}
