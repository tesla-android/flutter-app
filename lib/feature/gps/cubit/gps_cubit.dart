import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesla_android/feature/gps/cubit/gps_state.dart';
import 'package:tesla_android/feature/gps/model/gps_data.dart';
import 'package:tesla_android/feature/gps/transport/gps_transport.dart';

@singleton
class GpsCubit extends Cubit<GpsState> {
  final SharedPreferences _sharedPreferences;
  final Location _location;
  final GpsTransport _gpsTransport;

  static const _sharedPreferencesKey = 'GpsCubit_isEnabled';

  StreamSubscription? _locationUpdatesStreamSubscription;

  GpsCubit(this._sharedPreferences, this._location, this._gpsTransport)
      : super(GpsStateInitial()) {
    _setInitialState();
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

  Future<void> enableGps() async {
    try {
      _gpsTransport.maintainConnection();
      await _enableGpsService().timeout(const Duration(seconds: 30));
      await _checkGpsPermission().timeout(const Duration(seconds: 30));
    } catch (e) {
      emit(GpsStateInitialisationError());
    }
  }

  Future<void> _enableGpsService() async {
    final gpsServiceEnabled = await _location.serviceEnabled();
    if (!gpsServiceEnabled) {
      final gpsServiceRequested = await _location.requestService();
      if (!gpsServiceRequested) {
        throw Exception();
      }
    }
  }

  Future<void> _checkGpsPermission() async {
    final gpsPermissionStatus = await _location.hasPermission();
    if (gpsPermissionStatus != PermissionStatus.granted) {
      final gpsPermissionRequested = await _location.requestPermission();
      if (gpsPermissionRequested == PermissionStatus.granted) {
        _onLocationPermissionGranted();
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
      _gpsTransport.sendGpsData(GpsData.fromLocationData(location));
    } catch (exception) {
      debugPrint("Failed to fetch current location $exception");
    }
  }

  void _subscribeToLocationUpdates() async {
    _locationUpdatesStreamSubscription =
        _location.onLocationChanged.listen((locationData) async {
      final location = await _location.getLocation();
      emit(GpsStateActive(currentLocation: location));
      _gpsTransport.sendGpsData(GpsData.fromLocationData(location));
    });
  }

  void disableGPS() {
    _locationUpdatesStreamSubscription?.cancel();
    _locationUpdatesStreamSubscription = null;
    _sharedPreferences.setBool(_sharedPreferencesKey, false);
    emit(GpsStateManuallyDisabled());
  }
}
