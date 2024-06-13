import 'package:json_annotation/json_annotation.dart';
import 'package:tesla_android/feature/settings/model/softap_band_type.dart';

part 'system_configuration_response_body.g.dart';

@JsonSerializable()
class SystemConfigurationResponseBody {
  @JsonKey(name: "persist.tesla-android.softap.band_type")
  final int bandType;
  @JsonKey(name: "persist.tesla-android.softap.channel")
  final int channel;
  @JsonKey(name: "persist.tesla-android.softap.channel_width")
  final int channelWidth;
  @JsonKey(name: "persist.tesla-android.softap.is_enabled")
  final int isEnabledFlag;
  @JsonKey(name: "persist.tesla-android.offline-mode.is_enabled")
  final int isOfflineModeEnabledFlag;
  @JsonKey(name: "persist.tesla-android.offline-mode.telemetry.is_enabled")
  final int isOfflineModeTelemetryEnabledFlag;
  @JsonKey(name: "persist.tesla-android.offline-mode.tesla-firmware-downloads")
  final int isOfflineModeTeslaFirmwareDownloadsEnabledFlag;
  @JsonKey(
    name: "persist.tesla-android.browser_audio.is_enabled",
    defaultValue: 1,
  )
  final int browserAudioIsEnabled;
  @JsonKey(
    name: "persist.tesla-android.browser_audio.volume",
    defaultValue: 100,
  )
  final int browserAudioVolume;
  @JsonKey(
    name: "persist.tesla-android.gps.is_active",
    defaultValue: 1,
  )
  final int isGPSEnabled;

  SystemConfigurationResponseBody({
    required this.bandType,
    required this.channel,
    required this.channelWidth,
    required this.isEnabledFlag,
    required this.isOfflineModeEnabledFlag,
    required this.isOfflineModeTelemetryEnabledFlag,
    required this.isOfflineModeTeslaFirmwareDownloadsEnabledFlag,
    required this.browserAudioIsEnabled,
    required this.browserAudioVolume,
    required this.isGPSEnabled,
  });

  factory SystemConfigurationResponseBody.fromJson(Map<String, dynamic> json) =>
      _$SystemConfigurationResponseBodyFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SystemConfigurationResponseBodyToJson(this);

  SoftApBandType get currentSoftApBandType =>
      SoftApBandType.matchBandTypeFromConfig(
        band: bandType,
        channel: channel,
        channelWidth: channelWidth,
      );
}
