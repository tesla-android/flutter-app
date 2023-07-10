import 'package:equatable/equatable.dart';
import 'package:tesla_android/feature/gps/util/web_location_data.dart';

abstract class GpsState extends Equatable {
  const GpsState();

  @override
  List<Object?> get props => [];
}

class GpsStateInitial extends GpsState {}

class GpsStateInitialisationError extends GpsState {}

class GpsStatePermissionNotGranted extends GpsState {}

class GpsStateManuallyDisabled extends GpsState {}

class GpsStateActive extends GpsState {}

WebLocationData get initialLocationData {
  return WebLocationData(
    latitude: 53.4289,
    longitude: 14.5530,
    verticalAccuracy: 0,
  );
}
