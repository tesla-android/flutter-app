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
  @JsonKey(defaultValue: DisplayRendererType.mjpeg)
  final DisplayRendererType renderer;
  final int? isHeadless;
  @JsonKey(defaultValue: 1)
  final int isResponsive;
  @JsonKey(defaultValue: 0)
  final int isH264;
  @JsonKey(defaultValue: DisplayRefreshRatePreset.refresh30hz)
  final DisplayRefreshRatePreset refreshRate;
  @JsonKey(defaultValue: DisplayQualityPreset.quality90)
  final DisplayQualityPreset quality;
  @JsonKey(defaultValue: 0)
  final int isRearDisplayEnabled;
  @JsonKey(defaultValue: 0)
  final int isRearDisplayPrioritised;

  const RemoteDisplayState({
    required this.width,
    required this.height,
    required this.density,
    required this.lowRes,
    required this.renderer,
    required this.isResponsive,
    required this.isH264,
    required this.refreshRate,
    required this.quality,
    required this.isRearDisplayEnabled,
    required this.isRearDisplayPrioritised,
    this.isHeadless,
  });

  factory RemoteDisplayState.fromJson(Map<String, dynamic> json) =>
      _$RemoteDisplayStateFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteDisplayStateToJson(this);

  @override
  List<Object?> get props => [
    width,
    height,
    density,
    lowRes,
    renderer,
    isResponsive,
    isH264,
    refreshRate,
    quality,
    isRearDisplayEnabled,
    isRearDisplayPrioritised,
    isHeadless,
  ];

  RemoteDisplayState updateResolution({
    required DisplayResolutionModePreset newPreset,
  }) {
    return copyWith(
      lowRes: newPreset,
      density: newPreset.density(isH264: isH264 == 1),
    );
  }

  RemoteDisplayState updateRenderer({required DisplayRendererType newType}) {
    return copyWith(
      renderer: newType,
      isH264: newType != DisplayRendererType.mjpeg ? 1 : 0,
    );
  }

  RemoteDisplayState updateQuality({required DisplayQualityPreset newQuality}) {
    return copyWith(quality: newQuality);
  }

  RemoteDisplayState updateRefreshRate({
    required DisplayRefreshRatePreset newRefreshRate,
  }) {
    return copyWith(refreshRate: newRefreshRate);
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
    DisplayRefreshRatePreset? refreshRate,
    DisplayQualityPreset? quality,
    int? isRearDisplayEnabled,
    int? isRearDisplayPrioritised,
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
      refreshRate: refreshRate ?? this.refreshRate,
      quality: quality ?? this.quality,
      isRearDisplayEnabled: isRearDisplayEnabled ?? this.isRearDisplayEnabled,
      isRearDisplayPrioritised:
          isRearDisplayPrioritised ?? this.isRearDisplayPrioritised,
    );
  }
}

enum DisplayRefreshRatePreset {
  @JsonValue(30)
  refresh30hz,
  @JsonValue(45)
  refresh45hz,
  @JsonValue(60)
  refresh60hz;

  String name() {
    switch (index) {
      case 0:
        return "30 Hz";
      case 1:
        return "45 Hz";
      case 2:
        return "60 Hz";
      default:
        return "30 Hz";
    }
  }

  int value() {
    switch (index) {
      case 0:
        return 30;
      case 1:
        return 45;
      case 2:
        return 60;
      default:
        return 30;
    }
  }
}

enum DisplayQualityPreset {
  @JsonValue(40)
  quality40,
  @JsonValue(50)
  quality50,
  @JsonValue(60)
  quality60,
  @JsonValue(70)
  quality70,
  @JsonValue(80)
  quality80,
  @JsonValue(90)
  quality90;

  String name() {
    switch (index) {
      case 0:
        return "40";
      case 1:
        return "50";
      case 2:
        return "60";
      case 3:
        return "70";
      case 4:
        return "80";
      case 5:
        return "90";
      default:
        return "90";
    }
  }

  int value() {
    return int.parse(name());
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

  int density({required bool isH264}) {
    if (isH264) {
      switch (index) {
        case 0:
          return 200;
        case 1:
          return 175;
        default:
          return 175;
      }
    } else {
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
  mjpeg,
  @JsonValue(1)
  h264WebCodecs,
  @JsonValue(2)
  h264Brodway;

  String name() {
    switch (index) {
      case 0:
        return "Motion JPEG";
      case 1:
        return "h264 (WebCodecs)";
      case 2:
        return "h264 (legacy)";
      default:
        return "mjpeg";
    }
  }

  String resourcePath() {
    switch (index) {
      case 0:
        return "mjpeg";
      case 1:
        return "h264WebCodecs";
      case 2:
        return "h264Brodway";
      default:
        return "mjpeg";
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
