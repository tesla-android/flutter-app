import 'dart:async';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/utils/logger.dart';
import 'package:tesla_android/feature/gps/cubit/gps_state.dart';
import 'package:tesla_android/feature/gps/model/gps_data.dart';
import 'package:tesla_android/feature/gps/transport/gps_transport.dart';
import 'package:tesla_android/feature/gps/util/web_location.dart';

@injectable
class GpsCubit extends Cubit<GpsState> with Logger {
  final WebLocation _location;
  final GpsTransport _gpsTransport;

  StreamSubscription? _locationUpdatesStreamSubscription;

  GpsCubit(this._location, this._gpsTransport) : super(GpsStateInitial());

  @override
  Future<void> close() {
    log("close");
    _gpsTransport.disconnect();
    _locationUpdatesStreamSubscription?.cancel();
    _locationUpdatesStreamSubscription = null;
    return super.close();
  }

  void enableIfNeeded() {
    _gpsTransport.connect();
    enableGps();
  }

  Future<void> enableGps() async {
    if (state is GpsStateInitial || state is GpsStateInitialisationError) {
      try {
        await _checkGpsPermission().timeout(const Duration(seconds: 120));
      } catch (exception, stacktrace) {
        if (!isClosed) emit(GpsStateInitialisationError());
        if (exception is TimeoutException) {
          log("Timed out waiting for GPS init");
        } else {
          logExceptionAndUploadToSentry(
              exception: exception, stackTrace: stacktrace);
        }
      }
    } else {
      log("GPS already activated");
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
      if (!isClosed) emit(GpsStatePermissionNotGranted());
      return;
    }
    _onLocationPermissionGranted();
  }

  void _onLocationPermissionGranted() {
    _emitCurrentLocation();
    _subscribeToLocationUpdates();
    return;
  }

  void _emitCurrentLocation() async {
    try {
      final location = await _location.getLocation();
      if (!isClosed) emit(GpsStateActive());
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
      if (!isClosed) emit(GpsStateActive());
      _gpsTransport.sendJson(GpsData.fromLocationData(locationData));
    });
  }
}
