// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ustreamer_state_source.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UstreamerStateSource _$UstreamerStateSourceFromJson(
        Map<String, dynamic> json) =>
    UstreamerStateSource(
      resolution: UstreamerStateResolution.fromJson(
          json['resolution'] as Map<String, dynamic>),
      online: json['online'] as bool,
      desiredFps: json['desired_fps'] as int,
      capturedFps: json['captured_fps'] as int,
    );

Map<String, dynamic> _$UstreamerStateSourceToJson(
        UstreamerStateSource instance) =>
    <String, dynamic>{
      'resolution': instance.resolution,
      'online': instance.online,
      'desired_fps': instance.desiredFps,
      'captured_fps': instance.capturedFps,
    };
