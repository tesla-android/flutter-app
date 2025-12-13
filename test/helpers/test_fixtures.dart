import 'package:tesla_android/feature/display/model/remote_display_state.dart';
import 'package:tesla_android/feature/settings/model/device_info.dart';
import 'package:tesla_android/feature/settings/model/system_configuration_response_body.dart';

/// Test fixtures - sample data for testing
class TestFixtures {
  // Display State Fixtures
  static final RemoteDisplayState defaultDisplayState = RemoteDisplayState(
    width: 1920,
    height: 1080,
    density: 200,
    resolutionPreset: DisplayResolutionModePreset.res832p,
    renderer: DisplayRendererType.h264WebCodecs,
    isResponsive: 1,
    isH264: 1,
    refreshRate: DisplayRefreshRatePreset.refresh30hz,
    quality: DisplayQualityPreset.quality90,
    isRearDisplayEnabled: 0,
    isRearDisplayPrioritised: 0,
    isHeadless: 0,
  );

  static final RemoteDisplayState mjpegDisplayState = RemoteDisplayState(
    width: 1280,
    height: 720,
    density: 175,
    resolutionPreset: DisplayResolutionModePreset.res720p,
    renderer: DisplayRendererType.mjpeg,
    isResponsive: 1,
    isH264: 0,
    refreshRate: DisplayRefreshRatePreset.refresh45hz,
    quality: DisplayQualityPreset.quality70,
    isRearDisplayEnabled: 0,
    isRearDisplayPrioritised: 0,
    isHeadless: 0,
  );

  // Device Info Fixtures
  static final DeviceInfo rpi4DeviceInfo = DeviceInfo(
    cpuTemperature: 45,
    serialNumber: "RPI4TEST001",
    deviceModel: "rpi4",
    isCarPlayDetected: 0,
    isModemDetected: 1,
    releaseType: "stable",
    otaUrl: "https://example.com/ota",
    isGPSEnabled: 1,
  );

  static final DeviceInfo cm4DeviceInfo = DeviceInfo(
    cpuTemperature: 52,
    serialNumber: "CM4TEST001",
    deviceModel: "cm4",
    isCarPlayDetected: 1,
    isModemDetected: 1,
    releaseType: "stable",
    otaUrl: "https://example.com/ota",
    isGPSEnabled: 1,
  );

  // Configuration Fixtures
  static final SystemConfigurationResponseBody defaultConfiguration =
      SystemConfigurationResponseBody(
        bandType: 1,
        channel: 36,
        channelWidth: 80,
        isEnabledFlag: 1,
        isOfflineModeEnabledFlag: 0,
        isOfflineModeTelemetryEnabledFlag: 1,
        isOfflineModeTeslaFirmwareDownloadsEnabledFlag: 1,
        browserAudioIsEnabled: 1,
        browserAudioVolume: 80,
        isGPSEnabled: 1,
      );

  // JSON Fixtures for Testing Serialization
  static const Map<String, dynamic> displayStateJson = {
    'width': 1920,
    'height': 1080,
    'density': 200,
    'resolutionPreset': 0,
    'renderer': 1,
    'isResponsive': 1,
    'isH264': 1,
    'refreshRate': 30,
    'quality': 90,
    'isRearDisplayEnabled': 0,
    'isRearDisplayPrioritised': 0,
    'isHeadless': 0,
  };

  static const Map<String, dynamic> deviceInfoJson = {
    'cpu_temperature': 45,
    'serial_number': 'TEST001',
    'device_model': 'rpi4',
    'is_modem_detected': 1,
    'is_carplay_detected': 0,
    'release_type': 'stable',
    'ota_url': 'https://example.com/ota',
    'is_gps_enabled': 1,
  };

  static const Map<String, dynamic> configurationJson = {
    'persist.tesla-android.softap.band_type': 1,
    'persist.tesla-android.softap.channel': 36,
    'persist.tesla-android.softap.channel_width': 80,
    'persist.tesla-android.softap.is_enabled': 1,
    'persist.tesla-android.offline-mode.is_enabled': 0,
    'persist.tesla-android.offline-mode.telemetry.is_enabled': 1,
    'persist.tesla-android.offline-mode.tesla-firmware-downloads': 1,
    'persist.tesla-android.browser_audio.is_enabled': 1,
    'persist.tesla-android.browser_audio.volume': 80,
    'persist.tesla-android.gps.is_active': 1,
  };

  static final systemConfiguration = SystemConfigurationResponseBody.fromJson(
    configurationJson,
  );

  // Builder Pattern for Flexible Test Data Creation

  /// Builder for customizable RemoteDisplayState
  static RemoteDisplayStateBuilder displayStateBuilder() {
    return RemoteDisplayStateBuilder();
  }

  /// Builder for customizable DeviceInfo
  static DeviceInfoBuilder deviceInfoBuilder() {
    return DeviceInfoBuilder();
  }

  /// Builder for customizable SystemConfigurationResponseBody
  static SystemConfigurationBuilder systemConfigurationBuilder() {
    return SystemConfigurationBuilder();
  }
}

/// Builder for RemoteDisplayState with fluent API
class RemoteDisplayStateBuilder {
  int _width = 1920;
  int _height = 1080;
  final int _density = 200;
  DisplayResolutionModePreset _resolutionPreset =
      DisplayResolutionModePreset.res832p;
  DisplayRendererType _renderer = DisplayRendererType.h264WebCodecs;
  final int _isResponsive = 1;
  int _isH264 = 1;
  DisplayRefreshRatePreset _refreshRate = DisplayRefreshRatePreset.refresh30hz;
  DisplayQualityPreset _quality = DisplayQualityPreset.quality90;
  int _isRearDisplayEnabled = 0;
  int _isRearDisplayPrioritised = 0;
  int _isHeadless = 0;

  RemoteDisplayStateBuilder withResolution(int width, int height) {
    _width = width;
    _height = height;
    return this;
  }

  RemoteDisplayStateBuilder withRenderer(DisplayRendererType renderer) {
    _renderer = renderer;
    _isH264 = renderer == DisplayRendererType.h264WebCodecs ? 1 : 0;
    return this;
  }

  RemoteDisplayStateBuilder withPreset(DisplayResolutionModePreset preset) {
    _resolutionPreset = preset;
    return this;
  }

  RemoteDisplayStateBuilder withQuality(DisplayQualityPreset quality) {
    _quality = quality;
    return this;
  }

  RemoteDisplayStateBuilder withRefreshRate(DisplayRefreshRatePreset rate) {
    _refreshRate = rate;
    return this;
  }

  RemoteDisplayStateBuilder withRearDisplay({
    required bool enabled,
    bool prioritised = false,
  }) {
    _isRearDisplayEnabled = enabled ? 1 : 0;
    _isRearDisplayPrioritised = prioritised ? 1 : 0;
    return this;
  }

  RemoteDisplayStateBuilder asHeadless() {
    _isHeadless = 1;
    return this;
  }

  RemoteDisplayState build() {
    return RemoteDisplayState(
      width: _width,
      height: _height,
      density: _density,
      resolutionPreset: _resolutionPreset,
      renderer: _renderer,
      isResponsive: _isResponsive,
      isH264: _isH264,
      refreshRate: _refreshRate,
      quality: _quality,
      isRearDisplayEnabled: _isRearDisplayEnabled,
      isRearDisplayPrioritised: _isRearDisplayPrioritised,
      isHeadless: _isHeadless,
    );
  }
}

/// Builder for DeviceInfo with fluent API
class DeviceInfoBuilder {
  int _cpuTemperature = 45;
  String _serialNumber = "TEST001";
  String _deviceModel = "rpi4";
  int _isCarPlayDetected = 0;
  int _isModemDetected = 1;
  String _releaseType = "stable";
  final String _otaUrl = "https://example.com/ota";
  int _isGPSEnabled = 1;

  DeviceInfoBuilder withTemperature(int temp) {
    _cpuTemperature = temp;
    return this;
  }

  DeviceInfoBuilder withModel(String model) {
    _deviceModel = model;
    return this;
  }

  DeviceInfoBuilder withSerialNumber(String serial) {
    _serialNumber = serial;
    return this;
  }

  DeviceInfoBuilder withCarPlay(bool detected) {
    _isCarPlayDetected = detected ? 1 : 0;
    return this;
  }

  DeviceInfoBuilder withModem(bool detected) {
    _isModemDetected = detected ? 1 : 0;
    return this;
  }

  DeviceInfoBuilder withGPS(bool enabled) {
    _isGPSEnabled = enabled ? 1 : 0;
    return this;
  }

  DeviceInfoBuilder withReleaseType(String type) {
    _releaseType = type;
    return this;
  }

  DeviceInfo build() {
    return DeviceInfo(
      cpuTemperature: _cpuTemperature,
      serialNumber: _serialNumber,
      deviceModel: _deviceModel,
      isCarPlayDetected: _isCarPlayDetected,
      isModemDetected: _isModemDetected,
      releaseType: _releaseType,
      otaUrl: _otaUrl,
      isGPSEnabled: _isGPSEnabled,
    );
  }
}

/// Builder for SystemConfigurationResponseBody with fluent API
class SystemConfigurationBuilder {
  int _bandType = 1;
  int _channel = 36;
  int _channelWidth = 80;
  int _isEnabledFlag = 1;
  int _isOfflineModeEnabledFlag = 0;
  int _isOfflineModeTelemetryEnabledFlag = 1;
  int _isOfflineModeTeslaFirmwareDownloadsEnabledFlag = 1;
  int _browserAudioIsEnabled = 1;
  int _browserAudioVolume = 80;
  int _isGPSEnabled = 1;

  SystemConfigurationBuilder withSoftAp({
    int? bandType,
    int? channel,
    int? channelWidth,
    bool? enabled,
  }) {
    if (bandType != null) _bandType = bandType;
    if (channel != null) _channel = channel;
    if (channelWidth != null) _channelWidth = channelWidth;
    if (enabled != null) _isEnabledFlag = enabled ? 1 : 0;
    return this;
  }

  SystemConfigurationBuilder withOfflineMode({
    bool? enabled,
    bool? telemetry,
    bool? firmwareDownloads,
  }) {
    if (enabled != null) _isOfflineModeEnabledFlag = enabled ? 1 : 0;
    if (telemetry != null) {
      _isOfflineModeTelemetryEnabledFlag = telemetry ? 1 : 0;
    }
    if (firmwareDownloads != null) {
      _isOfflineModeTeslaFirmwareDownloadsEnabledFlag = firmwareDownloads
          ? 1
          : 0;
    }
    return this;
  }

  SystemConfigurationBuilder withAudio({bool? enabled, int? volume}) {
    if (enabled != null) _browserAudioIsEnabled = enabled ? 1 : 0;
    if (volume != null) _browserAudioVolume = volume;
    return this;
  }

  SystemConfigurationBuilder withGPS(bool enabled) {
    _isGPSEnabled = enabled ? 1 : 0;
    return this;
  }

  SystemConfigurationResponseBody build() {
    return SystemConfigurationResponseBody(
      bandType: _bandType,
      channel: _channel,
      channelWidth: _channelWidth,
      isEnabledFlag: _isEnabledFlag,
      isOfflineModeEnabledFlag: _isOfflineModeEnabledFlag,
      isOfflineModeTelemetryEnabledFlag: _isOfflineModeTelemetryEnabledFlag,
      isOfflineModeTeslaFirmwareDownloadsEnabledFlag:
          _isOfflineModeTeslaFirmwareDownloadsEnabledFlag,
      browserAudioIsEnabled: _browserAudioIsEnabled,
      browserAudioVolume: _browserAudioVolume,
      isGPSEnabled: _isGPSEnabled,
    );
  }
}
