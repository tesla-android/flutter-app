// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ustreamer_state_encoder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UstreamerStateEncoder _$UstreamerStateEncoderFromJson(
        Map<String, dynamic> json) =>
    UstreamerStateEncoder(
      type: json['type'] as String,
      quality: json['quality'] as int,
    );

Map<String, dynamic> _$UstreamerStateEncoderToJson(
        UstreamerStateEncoder instance) =>
    <String, dynamic>{
      'type': instance.type,
      'quality': instance.quality,
    };
