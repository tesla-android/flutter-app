// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceInfo _$DeviceInfoFromJson(Map<String, dynamic> json) => DeviceInfo(
      cpuTemperature: json['cpu_temperature'] as int? ?? 0,
      serialNumber: json['serial_number'] as String? ?? 'undefined',
      deviceModel: json['device_model'] as String? ?? 'undefined',
      isCarPlayDetected: json['is_carplay_detected'] as int? ?? 0,
      isModemDetected: json['is_modem_detected'] as int? ?? 0,
    );

Map<String, dynamic> _$DeviceInfoToJson(DeviceInfo instance) =>
    <String, dynamic>{
      'cpu_temperature': instance.cpuTemperature,
      'serial_number': instance.serialNumber,
      'device_model': instance.deviceModel,
      'is_modem_detected': instance.isModemDetected,
      'is_carplay_detected': instance.isCarPlayDetected,
    };
