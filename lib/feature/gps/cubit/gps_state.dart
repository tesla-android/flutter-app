import 'dart:html';

import 'package:tesla_android/feature/gps/model/gps_data.dart';
import 'package:tesla_android/feature/gps/util/web_location_data.dart';

abstract class GpsState {}

class GpsStateInitial extends GpsState {}

class GpsStateInitialisationError extends GpsState {}

class GpsStatePermissionNotGranted extends GpsState {}

class GpsStateManuallyDisabled extends GpsState {}

class GpsStateActive extends GpsState {
  final WebLocationData currentLocation;
  final double? averageUpdateIntervalInSeconds;

  GpsStateActive({
    required this.currentLocation,
    this.averageUpdateIntervalInSeconds,
  });
}

WebLocationData get initialLocationData {
  return WebLocationData(
    latitude: 53.4289,
    longitude: 14.5530,
    verticalAccuracy: 0,
    time: DateTime.now().millisecondsSinceEpoch.toDouble() / 1000,
  );
}
