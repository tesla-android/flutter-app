// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ustreamer_state_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UstreamerStateResult _$UstreamerStateResultFromJson(
        Map<String, dynamic> json) =>
    UstreamerStateResult(
      encoder: UstreamerStateEncoder.fromJson(
          json['encoder'] as Map<String, dynamic>),
      source:
          UstreamerStateSource.fromJson(json['source'] as Map<String, dynamic>),
      stream:
          UstreamerStateStream.fromJson(json['stream'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UstreamerStateResultToJson(
        UstreamerStateResult instance) =>
    <String, dynamic>{
      'encoder': instance.encoder,
      'source': instance.source,
      'stream': instance.stream,
    };
