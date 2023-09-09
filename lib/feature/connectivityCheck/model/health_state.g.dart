// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthState _$HealthStateFromJson(Map<String, dynamic> json) => HealthState(
      cpuTemperature: json['cpu_temperature'] as int? ?? 0,
      serialNumber: json['serial_number'] as String? ?? 'undefined',
      deviceModel: json['device_model'] as String? ?? 'undefined',
    );

Map<String, dynamic> _$HealthStateToJson(HealthState instance) =>
    <String, dynamic>{
      'cpu_temperature': instance.cpuTemperature,
      'serial_number': instance.serialNumber,
      'device_model': instance.deviceModel,
    };
