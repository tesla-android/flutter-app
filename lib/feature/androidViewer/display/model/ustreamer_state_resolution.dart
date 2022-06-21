import 'package:json_annotation/json_annotation.dart';

part 'ustreamer_state_resolution.g.dart';

@JsonSerializable()
class UstreamerStateResolution {
  final int width;
  final int height;

  const UstreamerStateResolution({
    required this.width,
    required this.height,
  });

  factory UstreamerStateResolution.fromJson(Map<String, dynamic> json) =>
      _$UstreamerStateResolutionFromJson(json);

  Map<String, dynamic> toJson() => _$UstreamerStateResolutionToJson(this);

  static const normalStreamWidth = 896;
  static const normalStreamHeight = 700;

  static const normalStreamResolution = UstreamerStateResolution(
    width: normalStreamWidth,
    height: normalStreamHeight,
  );

  @override
  bool operator ==(Object other) {
    // TODO: implement ==
    return (other is UstreamerStateResolution) &&
        width == other.width &&
        height == other.height;
  }
}
