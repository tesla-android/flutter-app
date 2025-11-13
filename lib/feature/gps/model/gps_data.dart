import 'dart:core';

import 'package:json_annotation/json_annotation.dart';
import 'package:tesla_android/feature/gps/util/web_location_data.dart';

part 'gps_data.g.dart';

@JsonSerializable()
class GpsData {
  final String latitude;
  final String longitude;
  final String speed;
  final String bearing;
  @JsonKey(name: "vertical_accuracy")
  final String verticalAccuracy;
  final String timestamp;

  const GpsData({
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.bearing,
    required this.verticalAccuracy,
    required this.timestamp,
  });

  factory GpsData.fromJson(Map<String, dynamic> json) =>
      _$GpsDataFromJson(json);

  factory GpsData.fromLocationData(WebLocationData locationData) {
    return GpsData(
      latitude: locationData.latitude.toString(),
      longitude: locationData.longitude.toString(),
      speed: locationData.speed.toString(),
      bearing: locationData.speed.toString(),
      verticalAccuracy: locationData.accuracy.toString(),
      timestamp: locationData.time.toString(),
    );
  }

  Map<String, dynamic> toJson() => _$GpsDataToJson(this);
}