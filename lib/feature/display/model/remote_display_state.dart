import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'remote_display_state.g.dart';

@JsonSerializable()
class RemoteDisplayState extends Equatable {
  final int width;
  final int height;
  final int density;
  @JsonKey(name: "lowres")
  final int lowRes;

  const RemoteDisplayState({
    required this.width,
    required this.height,
    required this.density,
    required this.lowRes,
  });

  factory RemoteDisplayState.fromJson(Map<String, dynamic> json) =>
      _$RemoteDisplayStateFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteDisplayStateToJson(this);

  @override
  List<Object?> get props => [width, height, density, lowRes];

  RemoteDisplayState updateLowRes({required bool isEnabled}) {
    return RemoteDisplayState(
      width: width,
      height: height,
      density: density,
      lowRes: isEnabled ? 1 : 0,
    );
  }
}
