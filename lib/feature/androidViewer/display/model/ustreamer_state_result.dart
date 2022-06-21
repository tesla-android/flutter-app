import 'package:json_annotation/json_annotation.dart';
import 'package:tesla_android/feature/androidViewer/display/model/ustreamer_state_encoder.dart';
import 'package:tesla_android/feature/androidViewer/display/model/ustreamer_state_source.dart';
import 'package:tesla_android/feature/androidViewer/display/model/ustreamer_state_stream.dart';

part 'ustreamer_state_result.g.dart';

@JsonSerializable()
class UstreamerStateResult {
  final UstreamerStateEncoder encoder;
  final UstreamerStateSource source;
  final UstreamerStateStream stream;

  UstreamerStateResult({
    required this.encoder,
    required this.source,
    required this.stream,
  });

  factory UstreamerStateResult.fromJson(Map<String, dynamic> json) =>
      _$UstreamerStateResultFromJson(json);

  Map<String, dynamic> toJson() => _$UstreamerStateResultToJson(this);
}
