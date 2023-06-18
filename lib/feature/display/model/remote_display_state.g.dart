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
      lowRes: json['lowres'] as int,
    );

Map<String, dynamic> _$RemoteDisplayStateToJson(RemoteDisplayState instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'density': instance.density,
      'lowres': instance.lowRes,
    };
