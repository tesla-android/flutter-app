import 'package:json_annotation/json_annotation.dart';
import 'package:tesla_android/feature/androidViewer/display/model/ustreamer_state_resolution.dart';

part 'ustreamer_state_source.g.dart';

@JsonSerializable()
class UstreamerStateSource {
  final UstreamerStateResolution resolution;
  final bool online;
  @JsonKey(name: "desired_fps")
  final int desiredFps;
  @JsonKey(name: "captured_fps")
  final int capturedFps;

  UstreamerStateSource({
    required this.resolution,
    required this.online,
    required this.desiredFps,
    required this.capturedFps,
  });

  factory UstreamerStateSource.fromJson(Map<String, dynamic> json) =>
      _$UstreamerStateSourceFromJson(json);

  Map<String, dynamic> toJson() => _$UstreamerStateSourceToJson(this);
}
