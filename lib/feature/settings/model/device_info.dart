import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device_info.g.dart';

@JsonSerializable()
class DeviceInfo extends Equatable {
  @JsonKey(name: "cpu_temperature", defaultValue: 0)
  final int cpuTemperature;
  @JsonKey(name: "serial_number", defaultValue: "undefined")
  final String serialNumber;
  @JsonKey(name: "device_model", defaultValue: "undefined")
  final String deviceModel;
  @JsonKey(name: "is_modem_detected", defaultValue: 0)
  final int isModemDetected;
  @JsonKey(name: "is_carplay_detected", defaultValue: 0)
  final int isCarPlayDetected;

  const DeviceInfo({
    required this.cpuTemperature,
    required this.serialNumber,
    required this.deviceModel,
    required this.isCarPlayDetected,
    required this.isModemDetected,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceInfoToJson(this);

  @override
  List<Object?> get props => [
        cpuTemperature,
        serialNumber,
        deviceModel,
        isModemDetected,
        isCarPlayDetected,
      ];
}

extension DeviceNameExtension on DeviceInfo {
  String get deviceName {
    if (deviceModel == "rpi4") {
      return "Raspberry Pi 4";
    } else if (deviceModel == "cm4") {
      return "Compute Module 4";
    } else {
      return "UNOFFICIAL $deviceModel";
    }
  }
}
