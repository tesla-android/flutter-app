import 'package:json_annotation/json_annotation.dart';
import 'package:tesla_android/feature/gps/util/web_location_data.dart';

part 'gps_data.g.dart';

@JsonSerializable()
class GpsData {
  final String latitude;
  final String longitude;
  @JsonKey(name: "vertical_accuracy")
  final String verticalAccuracy;
  final String bearing;
  final String speed;
  final String timestamp;

  const GpsData({
    required this.latitude,
    required this.longitude,
    required this.verticalAccuracy,
    required this.timestamp,
    this.bearing = "not-available",
    this.speed = "not-available",
  });

  factory GpsData.fromJson(Map<String, dynamic> json) =>
      _$GpsDataFromJson(json);

  factory GpsData.fromLocationData(WebLocationData locationData) {
    return GpsData(
      latitude: locationData.latitude.toString(),
      longitude: locationData.longitude.toString(),
      verticalAccuracy: locationData.verticalAccuracy.toString(),
      timestamp: locationData.time.toString(),
      speed: locationData.approximatedSpeed.toString(),
      bearing: locationData.approximatedBearing.toString(),
    );
  }

  Map<String, dynamic> toJson() => _$GpsDataToJson(this);
}
