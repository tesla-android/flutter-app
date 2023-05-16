// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_configuration_response_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemConfigurationResponseBody _$SystemConfigurationResponseBodyFromJson(
        Map<String, dynamic> json) =>
    SystemConfigurationResponseBody(
      bandType: json['persist.tesla-android.softap.band_type'] as int,
      channel: json['persist.tesla-android.softap.channel'] as int,
      channelWidth: json['persist.tesla-android.softap.channel_width'] as int,
      isEnabledFlag: json['persist.tesla-android.softap.is_enabled'] as int,
    );

Map<String, dynamic> _$SystemConfigurationResponseBodyToJson(
        SystemConfigurationResponseBody instance) =>
    <String, dynamic>{
      'persist.tesla-android.softap.band_type': instance.bandType,
      'persist.tesla-android.softap.channel': instance.channel,
      'persist.tesla-android.softap.channel_width': instance.channelWidth,
      'persist.tesla-android.softap.is_enabled': instance.isEnabledFlag,
    };
