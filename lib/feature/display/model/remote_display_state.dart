import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'remote_display_state.g.dart';

@JsonSerializable()
class RemoteDisplayState extends Equatable {
  final int width;
  final int height;
  final int density;
  @JsonKey(name: "lowres")
  final DisplayResolutionModePreset lowRes;
  @JsonKey(defaultValue: DisplayRendererType.imgTag)
  final DisplayRendererType renderer;
  final int? isHeadless;
  @JsonKey(defaultValue: 1)
  final int isResponsive;
  @JsonKey(defaultValue: 1)
  final int isH264;

  const RemoteDisplayState({
    required this.width,
    required this.height,
    required this.density,
    required this.lowRes,
    required this.renderer,
    required this.isResponsive,
    required this.isH264,
    this.isHeadless,
  });

  factory RemoteDisplayState.fromJson(Map<String, dynamic> json) =>
      _$RemoteDisplayStateFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteDisplayStateToJson(this);

  @override
  List<Object?> get props =>
      [width, height, density, lowRes, renderer, isHeadless];

  RemoteDisplayState updateResolution(
      {required DisplayResolutionModePreset newPreset}) {
    return copyWith(
      lowRes: newPreset,
      density: newPreset.density(),
    );
  }

  RemoteDisplayState updateRenderer({required DisplayRendererType newType}) {
    return copyWith(renderer: newType, isH264: newType == DisplayRendererType.h264WebCodecs ? 1 : 0);
  }

  RemoteDisplayState copyWith({
    int? width,
    int? height,
    int? density,
    int? isHeadless,
    DisplayResolutionModePreset? lowRes,
    DisplayRendererType? renderer,
    int? isH264,
    int? isResponsive,
  }) {
    return RemoteDisplayState(
      width: width ?? this.width,
      height: height ?? this.height,
      density: density ?? this.density,
      lowRes: lowRes ?? this.lowRes,
      isHeadless: isHeadless ?? this.isHeadless,
      renderer: renderer ?? this.renderer,
      isH264: isH264 ?? this.isH264,
      isResponsive: isResponsive ?? this.isResponsive,
    );
  }
}

enum DisplayResolutionModePreset {
  @JsonValue(0)
  res832p,
  @JsonValue(1)
  res720p,
  @JsonValue(2)
  res640p,
  @JsonValue(3)
  res544p,
  @JsonValue(4)
  res480p;

  double maxHeight() {
    switch (index) {
      case 0:
        return 832;
      case 1:
        return 720;
      case 2:
        return 640;
      case 3:
        return 544;
      case 4:
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
        return 175;
      case 2:
        return 155;
      case 3:
        return 130;
      case 4:
        return 115;
      default:
        return 832;
    }
  }

  String name() {
    switch (index) {
      case 0:
        return "832p";
      case 1:
        return "720p";
      case 2:
        return "640p";
      case 3:
        return "544p";
      case 4:
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
  h264WebCodecs;

  String name() {
    switch (index) {
      case 0:
        return "Motion JPEG - Image tag (legacy)";
      case 1:
        return "Motion JPEG - WebCodecs/WebGL";
      case 2:
        return "H264 video - WebCodecs/WebGL";
      default:
        return "Motion JPEG - Image tag (legacy)";
    }
  }

  String resourcePath() {
    switch (index) {
      case 0:
        return "imgTag";
      case 1:
        return "webGLWebCodecs";
      case 2:
        return "h264";
      default:
        return "imgTag";
    }
  }

  bool needsSSL() {
    switch (index) {
      case 0:
        return false;
      case 1:
        return true;
      default:
        return false;
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
      default:
        return "blob";
    }
  }
}
