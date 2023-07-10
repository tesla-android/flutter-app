import 'package:equatable/equatable.dart';

class WebLocationData extends Equatable {
  WebLocationData({
    this.latitude,
    this.longitude,
    this.verticalAccuracy,
  }) : time = DateTime.now();

  /// Latitude in degrees
  final double? latitude;

  /// Longitude, in degrees
  final double? longitude;

  /// Estimated vertical accuracy of this location, in meters.
  final double? verticalAccuracy;

  /// Time of the WebLocationData
  final DateTime time;

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        verticalAccuracy,
        time,
      ];
}
