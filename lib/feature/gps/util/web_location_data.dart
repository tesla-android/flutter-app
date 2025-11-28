import 'package:equatable/equatable.dart';

class WebLocationData extends Equatable {
  const WebLocationData({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.speed,
    required this.heading,
    required this.time
  });

  final double latitude;
  final double longitude;
  final double accuracy;
  final double speed;
  final double heading;
  final int time;

  @override
  List<Object?> get props => [
    latitude,
    longitude,
    accuracy,
    speed,
    heading,
    time,
  ];
}