import 'package:json_annotation/json_annotation.dart';
import 'package:tesla_android/feature/androidViewer/display/model/ustreamer_state_result.dart';

part 'ustreamer_state.g.dart';

@JsonSerializable()
class UstreamerState {
  @JsonKey(name: "ok")
  final bool status;

  final UstreamerStateResult result;

  UstreamerState({
    required this.status,
    required this.result,
  });

  factory UstreamerState.fromJson(Map<String, dynamic> json) =>
      _$UstreamerStateFromJson(json);

  Map<String, dynamic> toJson() => _$UstreamerStateToJson(this);
}
