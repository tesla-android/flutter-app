// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ustreamer_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UstreamerState _$UstreamerStateFromJson(Map<String, dynamic> json) =>
    UstreamerState(
      status: json['ok'] as bool,
      result:
          UstreamerStateResult.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UstreamerStateToJson(UstreamerState instance) =>
    <String, dynamic>{
      'ok': instance.status,
      'result': instance.result,
    };
