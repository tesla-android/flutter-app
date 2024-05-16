// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_configuration_response_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemConfigurationResponseBody _$SystemConfigurationResponseBodyFromJson(
        Map<String, dynamic> json) =>
    SystemConfigurationResponseBody(
      bandType: (json['persist.tesla-android.softap.band_type'] as num).toInt(),
      channel: (json['persist.tesla-android.softap.channel'] as num).toInt(),
      channelWidth:
          (json['persist.tesla-android.softap.channel_width'] as num).toInt(),
      isEnabledFlag:
          (json['persist.tesla-android.softap.is_enabled'] as num).toInt(),
      isOfflineModeEnabledFlag:
          (json['persist.tesla-android.offline-mode.is_enabled'] as num)
              .toInt(),
      isOfflineModeTelemetryEnabledFlag:
          (json['persist.tesla-android.offline-mode.telemetry.is_enabled']
                  as num)
              .toInt(),
      isOfflineModeTeslaFirmwareDownloadsEnabledFlag:
          (json['persist.tesla-android.offline-mode.tesla-firmware-downloads']
                  as num)
              .toInt(),
      browserAudioIsEnabled:
          (json['persist.tesla-android.browser_audio.is_enabled'] as num?)
                  ?.toInt() ??
              1,
      browserAudioVolume:
          (json['persist.tesla-android.browser_audio.volume'] as num?)
                  ?.toInt() ??
              100,
    );

Map<String, dynamic> _$SystemConfigurationResponseBodyToJson(
        SystemConfigurationResponseBody instance) =>
    <String, dynamic>{
      'persist.tesla-android.softap.band_type': instance.bandType,
      'persist.tesla-android.softap.channel': instance.channel,
      'persist.tesla-android.softap.channel_width': instance.channelWidth,
      'persist.tesla-android.softap.is_enabled': instance.isEnabledFlag,
      'persist.tesla-android.offline-mode.is_enabled':
          instance.isOfflineModeEnabledFlag,
      'persist.tesla-android.offline-mode.telemetry.is_enabled':
          instance.isOfflineModeTelemetryEnabledFlag,
      'persist.tesla-android.offline-mode.tesla-firmware-downloads':
          instance.isOfflineModeTeslaFirmwareDownloadsEnabledFlag,
      'persist.tesla-android.browser_audio.is_enabled':
          instance.browserAudioIsEnabled,
      'persist.tesla-android.browser_audio.volume': instance.browserAudioVolume,
    };
