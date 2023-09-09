import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'health_state.g.dart';

@JsonSerializable()
class HealthState extends Equatable {
  @JsonKey(name: "cpu_temperature", defaultValue: 0)
  final int cpuTemperature;
  @JsonKey(name: "serial_number", defaultValue: "undefined")
  final String serialNumber;
  @JsonKey(name: "device_model", defaultValue: "undefined")
  final String deviceModel;

  const HealthState({
    required this.cpuTemperature,
    required this.serialNumber,
    required this.deviceModel,
  });

  factory HealthState.fromJson(Map<String, dynamic> json) =>
      _$HealthStateFromJson(json);

  Map<String, dynamic> toJson() => _$HealthStateToJson(this);

  @override
  List<Object?> get props => [
    cpuTemperature,
    serialNumber,
    deviceModel,
  ];
}

extension DeviceNameExtension on HealthState {
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
