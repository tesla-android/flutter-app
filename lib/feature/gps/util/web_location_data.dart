import 'package:equatable/equatable.dart';

class WebLocationData extends Equatable {
  WebLocationData({
    this.latitude,
    this.longitude,
    this.verticalAccuracy,
    this.approximatedSpeed,
    this.approximatedBearing,
  }) : time = DateTime.now();

  /// Latitude in degrees
  final double? latitude;

  /// Longitude, in degrees
  final double? longitude;

  /// Estimated vertical accuracy of this location, in meters.
  final double? verticalAccuracy;

  /// Time of the WebLocationData
  final DateTime time;

  /// Estimated speed, in meters per second
  final double? approximatedSpeed;

  /// Estimated bearing, in degrees
  final double? approximatedBearing;

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        verticalAccuracy,
        time,
        approximatedSpeed,
        approximatedBearing,
      ];

  WebLocationData addApproximatedData({
    required double approximatedSpeed,
    required double approximatedBearing,
  }) {
    return WebLocationData(
      latitude: latitude,
      longitude: longitude,
      verticalAccuracy: verticalAccuracy,
      approximatedSpeed: approximatedSpeed,
      approximatedBearing: approximatedBearing,
    );
  }
}
