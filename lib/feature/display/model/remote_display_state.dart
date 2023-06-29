import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'remote_display_state.g.dart';

@JsonSerializable()
class RemoteDisplayState extends Equatable {
  final int width;
  final int height;
  final int density;
  @JsonKey(name: "lowres")
  final DisplayLowResModePreset lowRes;
  @JsonKey(defaultValue: DisplayRendererType.imgTag)
  final DisplayRendererType renderer;
  final int? isHeadless;

  const RemoteDisplayState({
    required this.width,
    required this.height,
    required this.density,
    required this.lowRes,
    required this.renderer,
    this.isHeadless,
  });

  factory RemoteDisplayState.fromJson(Map<String, dynamic> json) =>
      _$RemoteDisplayStateFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteDisplayStateToJson(this);

  @override
  List<Object?> get props => [width, height, density, lowRes, renderer, isHeadless];

  RemoteDisplayState updateLowRes(
      {required DisplayLowResModePreset newPreset}) {
    return copyWith(
      lowRes: lowRes,
      density: lowRes.density(),
    );
  }

  RemoteDisplayState updateRenderer(
      {required DisplayRendererType newType}) {
    return copyWith(renderer: newType);
  }

  RemoteDisplayState copyWith({
    int? width,
    int? height,
    int? density,
    int? isHeadless,
    DisplayLowResModePreset? lowRes,
    DisplayRendererType? renderer,
  }) {
    return RemoteDisplayState(
      width: width ?? this.width,
      height: height ?? this.height,
      density: density ?? this.density,
      lowRes: lowRes ?? this.lowRes,
      isHeadless: isHeadless ?? this.isHeadless,
      renderer: renderer ?? this.renderer,
    );
  }
}

enum DisplayLowResModePreset {
  @JsonValue(0)
  res832p,
  @JsonValue(1)
  res640p,
  @JsonValue(2)
  res544p,
  @JsonValue(3)
  res480p;

  double maxHeight() {
    switch (index) {
      case 0:
        return 832;
      case 1:
        return 640;
      case 2:
        return 544;
      case 3:
        return 480;
      default:
        return 832;
    }
  }

  int density() {
    switch (index) {
      case 0:
        return 200;
      case 1:
        return 180;
      case 2:
        return 170;
      case 3:
        return 160;
      default:
        return 832;
    }
  }

  String name() {
    switch (index) {
      case 0:
        return "832p";
      case 1:
        return "640p";
      case 2:
        return "544p";
      case 3:
        return "480p";
      default:
        return "832p";
    }
  }
}

enum DisplayRendererType {
  @JsonValue(0)
  imgTag,
  @JsonValue(1)
  workerWebGLWebCodecs,
  @JsonValue(2)
  webGLWebCodecs,
  @JsonValue(3)
  webGL,
  @JsonValue(4)
  canvasWebCodecs,
  @JsonValue(5)
  canvas;

  String name() {
    switch (index) {
      case 0:
        return "Image tag";
      case 1:
        return "Worker + WebGL + WebCodecs";
      case 2:
        return "WebGL + WebCodecs";
      case 3:
        return "WebGL";
      case 4:
        return "2D Canvas + WebCodecs";
      case 5:
        return "2D Canvas";
      default:
        return "Image tag";
    }
  }

  String resourcePath() {
    switch (index) {
      case 0:
        return "/display/imgTag.html";
      case 1:
        return "/display/workerWebGLWebCodecs.html";
      case 2:
        return "/display/webGLWebCodecs.html";
      case 3:
        return "/display/webGL.html";
      case 4:
        return "/display/canvasWebCodecs.html";
      case 5:
        return "/display/canvas.html";
      default:
        return "/display/imgTag.html";
    }
  }

  String binaryType() {
    switch (index) {
      case 0:
        return "blob";
      case 1:
        return "arraybuffer";
      case 2:
        return "arraybuffer";
      case 3:
        return "blob";
      case 4:
        return "arraybuffer";
      case 5:
        return "blob";
      default:
        return "blob";
    }
  }
}
