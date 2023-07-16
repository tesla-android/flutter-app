// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_display_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoteDisplayState _$RemoteDisplayStateFromJson(Map<String, dynamic> json) =>
    RemoteDisplayState(
      width: json['width'] as int,
      height: json['height'] as int,
      density: json['density'] as int,
      lowRes: $enumDecode(_$DisplayResolutionModePresetEnumMap, json['lowres']),
      renderer:
          $enumDecodeNullable(_$DisplayRendererTypeEnumMap, json['renderer']) ??
              DisplayRendererType.imgTag,
      isResponsive: json['isResponsive'] as int? ?? 1,
      isH264: json['isH264'] as int? ?? 1,
      isHeadless: json['isHeadless'] as int?,
    );

Map<String, dynamic> _$RemoteDisplayStateToJson(RemoteDisplayState instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'density': instance.density,
      'lowres': _$DisplayResolutionModePresetEnumMap[instance.lowRes]!,
      'renderer': _$DisplayRendererTypeEnumMap[instance.renderer]!,
      'isHeadless': instance.isHeadless,
      'isResponsive': instance.isResponsive,
      'isH264': instance.isH264,
    };

const _$DisplayResolutionModePresetEnumMap = {
  DisplayResolutionModePreset.res832p: 0,
  DisplayResolutionModePreset.res720p: 1,
  DisplayResolutionModePreset.res640p: 2,
  DisplayResolutionModePreset.res544p: 3,
  DisplayResolutionModePreset.res480p: 4,
};

const _$DisplayRendererTypeEnumMap = {
  DisplayRendererType.imgTag: 0,
  DisplayRendererType.workerWebGLWebCodecs: 1,
  DisplayRendererType.h264WebCodecs: 2,
};
