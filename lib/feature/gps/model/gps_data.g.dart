// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gps_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GpsData _$GpsDataFromJson(Map<String, dynamic> json) => GpsData(
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
      verticalAccuracy: json['vertical_accuracy'] as String,
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$GpsDataToJson(GpsData instance) => <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'vertical_accuracy': instance.verticalAccuracy,
      'timestamp': instance.timestamp,
    };
