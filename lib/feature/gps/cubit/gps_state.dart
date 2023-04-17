import 'package:location/location.dart';
import 'package:tesla_android/feature/gps/utils/nmea_converter.dart';

abstract class GpsState {}

class GpsStateInitial extends GpsState {}

class GpsStateInitialisationError extends GpsState {}

class GpsStatePermissionNotGranted extends GpsState {}

class GpsStateManuallyDisabled extends GpsState {}

class GpsStateActive extends GpsState {
  final LocationData currentLocation;

  GpsStateActive({required this.currentLocation});

  String get nmeaString => NmeaConverter.locationToNMEA(currentLocation);
}

LocationData get initialLocationData {
  return LocationData.fromMap({
    'latitude': 53.4289,
    'longitude': 14.5530,
    'accuracy': 10,
    'altitude': 0,
    'speed': 0,
    'speed_accuracy': 0,
    'heading': 0,
    'time': DateTime.now().millisecondsSinceEpoch.toDouble() / 1000,
    'isMock': 1,
    'verticalAccuracy': 0,
    'headingAccuracy': 0,
    'elapsedRealtimeNanos': 0,
    'elapsedRealtimeUncertaintyNanos': 0,
    'satelliteNumber': 0,
    'provider': 'mock',
  });
}
