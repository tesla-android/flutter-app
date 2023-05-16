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

  SystemConfigurationResponseBody({
    required this.bandType,
    required this.channel,
    required this.channelWidth,
    required this.isEnabledFlag,
  });

  factory SystemConfigurationResponseBody.fromJson(Map<String, dynamic> json) =>
      _$SystemConfigurationResponseBodyFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SystemConfigurationResponseBodyToJson(this);

  SoftApBandType get currentSoftApBandType =>
      (bandType == 1) ? SoftApBandType.band2_4GHz : SoftApBandType.band5GHz;
}
