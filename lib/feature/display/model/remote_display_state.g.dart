// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_display_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoteDisplayState _$RemoteDisplayStateFromJson(Map<String, dynamic> json) =>
    RemoteDisplayState(
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
      density: (json['density'] as num).toInt(),
      lowRes: $enumDecode(_$DisplayResolutionModePresetEnumMap, json['lowres']),
      renderer:
          $enumDecodeNullable(_$DisplayRendererTypeEnumMap, json['renderer']) ??
          DisplayRendererType.mjpeg,
      isResponsive: (json['isResponsive'] as num?)?.toInt() ?? 1,
      isH264: (json['isH264'] as num?)?.toInt() ?? 0,
      refreshRate:
          $enumDecodeNullable(
            _$DisplayRefreshRatePresetEnumMap,
            json['refreshRate'],
          ) ??
          DisplayRefreshRatePreset.refresh30hz,
      quality:
          $enumDecodeNullable(_$DisplayQualityPresetEnumMap, json['quality']) ??
          DisplayQualityPreset.quality90,
      isRearDisplayEnabled:
          (json['isRearDisplayEnabled'] as num?)?.toInt() ?? 0,
      isRearDisplayPrioritised:
          (json['isRearDisplayPrioritised'] as num?)?.toInt() ?? 0,
      isHeadless: (json['isHeadless'] as num?)?.toInt(),
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
      'refreshRate': _$DisplayRefreshRatePresetEnumMap[instance.refreshRate]!,
      'quality': _$DisplayQualityPresetEnumMap[instance.quality]!,
      'isRearDisplayEnabled': instance.isRearDisplayEnabled,
      'isRearDisplayPrioritised': instance.isRearDisplayPrioritised,
    };

const _$DisplayResolutionModePresetEnumMap = {
  DisplayResolutionModePreset.res832p: 0,
  DisplayResolutionModePreset.res720p: 1,
  DisplayResolutionModePreset.res640p: 2,
  DisplayResolutionModePreset.res544p: 3,
  DisplayResolutionModePreset.res480p: 4,
};

const _$DisplayRendererTypeEnumMap = {
  DisplayRendererType.mjpeg: 0,
  DisplayRendererType.h264WebCodecs: 1,
  DisplayRendererType.h264Brodway: 2,
};

const _$DisplayRefreshRatePresetEnumMap = {
  DisplayRefreshRatePreset.refresh30hz: 30,
  DisplayRefreshRatePreset.refresh45hz: 45,
  DisplayRefreshRatePreset.refresh60hz: 60,
};

const _$DisplayQualityPresetEnumMap = {
  DisplayQualityPreset.quality40: 40,
  DisplayQualityPreset.quality50: 50,
  DisplayQualityPreset.quality60: 60,
  DisplayQualityPreset.quality70: 70,
  DisplayQualityPreset.quality80: 80,
  DisplayQualityPreset.quality90: 90,
};
