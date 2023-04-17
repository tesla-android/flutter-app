import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesla_android/feature/gps/cubit/gps_state.dart';
import 'package:tesla_android/feature/gps/utils/nmea_converter.dart';

@lazySingleton
class GpsCubit extends Cubit<GpsState> {
  final SharedPreferences _sharedPreferences;
  final Location _location;

  static const _sharedPreferencesKey = 'GpsCubit_isEnabled';

  StreamSubscription? _locationUpdatesStreamSubscription;

  GpsCubit(this._sharedPreferences, this._location) : super(GpsStateInitial()) {
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
      await _enableGpsService();
      await _checkGpsPermission();
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
    if (gpsPermissionStatus != PermissionStatus.granted ) {
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
    _emitInitialLocation();
    _subscribeToLocationUpdates();
    return;
  }

  void _emitInitialLocation() async {
    try {
      final location = await _location.getLocation();
      emit(GpsStateActive(currentLocation: location));
      debugPrint(NmeaConverter.locationToNMEA(location));
    } catch (_) {
      debugPrint("Failed to fetch initial location");
    }
  }

  void _subscribeToLocationUpdates() {
    _locationUpdatesStreamSubscription =
        _location.onLocationChanged.listen((locationData) {
      emit(GpsStateActive(currentLocation: locationData));
    });
  }

  void disableGPS() {
    if (state is GpsStateActive) {
      _locationUpdatesStreamSubscription?.cancel();
      _locationUpdatesStreamSubscription = null;
      _sharedPreferences.setBool(_sharedPreferencesKey, false);
      emit(GpsStateManuallyDisabled());
    }
  }
}
