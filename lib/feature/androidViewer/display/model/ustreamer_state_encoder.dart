import 'package:json_annotation/json_annotation.dart';

part 'ustreamer_state_encoder.g.dart';

@JsonSerializable()
class UstreamerStateEncoder {
  final String type;
  final int quality;

  UstreamerStateEncoder({
    required this.type,
    required this.quality,
  });

  factory UstreamerStateEncoder.fromJson(Map<String, dynamic> json) =>
      _$UstreamerStateEncoderFromJson(json);

  Map<String, dynamic> toJson() => _$UstreamerStateEncoderToJson(this);
}
