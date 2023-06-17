import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'remote_display_state.g.dart';

@JsonSerializable()
class RemoteDisplayState extends Equatable {
  final int width;
  final int height;
  final int density;

  const RemoteDisplayState({
    required this.width,
    required this.height,
    required this.density,
  });

  factory RemoteDisplayState.fromJson(Map<String, dynamic> json) =>
      _$RemoteDisplayStateFromJson(json);

  Map<String, dynamic> toJson() =>
      _$RemoteDisplayStateToJson(this);
  
  @override
  List<Object?> get props => [width, height, density];
}
