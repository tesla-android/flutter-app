import 'package:json_annotation/json_annotation.dart';

part 'ustreamer_state_stream.g.dart';

@JsonSerializable()
class UstreamerStateStream {
  @JsonKey(name: "queued_fps")
  final int queuedFps;
  final int clients;

  UstreamerStateStream({
    required this.queuedFps,
    required this.clients,
  });

  factory UstreamerStateStream.fromJson(Map<String, dynamic> json) =>
      _$UstreamerStateStreamFromJson(json);

  Map<String, dynamic> toJson() => _$UstreamerStateStreamToJson(this);
}
