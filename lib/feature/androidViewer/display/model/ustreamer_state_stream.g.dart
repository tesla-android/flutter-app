// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ustreamer_state_stream.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UstreamerStateStream _$UstreamerStateStreamFromJson(
        Map<String, dynamic> json) =>
    UstreamerStateStream(
      queuedFps: json['queued_fps'] as int,
      clients: json['clients'] as int,
    );

Map<String, dynamic> _$UstreamerStateStreamToJson(
        UstreamerStateStream instance) =>
    <String, dynamic>{
      'queued_fps': instance.queuedFps,
      'clients': instance.clients,
    };
