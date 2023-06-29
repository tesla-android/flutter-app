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
      lowRes: $enumDecode(_$DisplayLowResModePresetEnumMap, json['lowres']),
      renderer:
          $enumDecodeNullable(_$DisplayRendererTypeEnumMap, json['renderer']) ??
              DisplayRendererType.imgTag,
      isHeadless: json['isHeadless'] as int?,
    );

Map<String, dynamic> _$RemoteDisplayStateToJson(RemoteDisplayState instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'density': instance.density,
      'lowres': _$DisplayLowResModePresetEnumMap[instance.lowRes]!,
      'renderer': _$DisplayRendererTypeEnumMap[instance.renderer]!,
      'isHeadless': instance.isHeadless,
    };

const _$DisplayLowResModePresetEnumMap = {
  DisplayLowResModePreset.res832p: 0,
  DisplayLowResModePreset.res640p: 1,
  DisplayLowResModePreset.res544p: 2,
  DisplayLowResModePreset.res480p: 3,
};

const _$DisplayRendererTypeEnumMap = {
  DisplayRendererType.imgTag: 0,
  DisplayRendererType.workerWebGLWebCodecs: 1,
  DisplayRendererType.webGLWebCodecs: 2,
  DisplayRendererType.webGL: 3,
  DisplayRendererType.canvasWebCodecs: 4,
  DisplayRendererType.canvas: 5,
};
