import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/network/configuration_service.dart';
import 'package:tesla_android/feature/settings/model/system_configuration_response_body.dart';

@injectable
class SystemConfigurationRepository {
  final ConfigurationService _configurationService;

  SystemConfigurationRepository(this._configurationService);

  Future<SystemConfigurationResponseBody> getConfiguration() {
    return _configurationService.getConfiguration();
  }

  Future setSoftApBand(int band) {
    return _configurationService.setSoftApBand(band);
  }

  Future setSoftApChannel(int channel) {
    return _configurationService.setSoftApChannel(channel);
  }

  Future setSoftApChannelWidth(int channelWidth) {
    return _configurationService.setSoftApChannelWidth(channelWidth);
  }

  Future setSoftApState(int isEnabledFlag) {
    return _configurationService.setSoftApState(isEnabledFlag);
  }

  Future setOfflineModeState(int isEnabledFlag) {
    return _configurationService.setOfflineModeState(isEnabledFlag);
  }

  Future setOfflineModeTelemetryState(int isEnabledFlag) {
    return _configurationService.setOfflineModeTelemetryState(isEnabledFlag);
  }

  Future setOfflineModeTeslaFirmwareDownloads(int isEnabledFlag) {
    return _configurationService
        .setOfflineModeTeslaFirmwareDownloads(isEnabledFlag);
  }

  Future setBrowserAudioState(int isEnabledFlag) {
    return _configurationService.setBrowserAudioState(isEnabledFlag);
  }

  Future setBrowserAudioVolume(int volume) {
    return _configurationService.setBrowserAudioVolume(volume);
  }
}
