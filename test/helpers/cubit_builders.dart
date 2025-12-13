import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:tesla_android/feature/connectivityCheck/model/connectivity_state.dart';
import 'package:tesla_android/feature/display/cubit/display_state.dart';
import 'package:tesla_android/feature/display/model/remote_display_state.dart';
import 'package:tesla_android/feature/home/cubit/ota_update_state.dart';
import 'package:tesla_android/feature/settings/bloc/audio_configuration_state.dart';
import 'package:tesla_android/feature/settings/bloc/device_info_state.dart';
import 'package:tesla_android/feature/settings/bloc/display_configuration_state.dart';
import 'package:tesla_android/feature/settings/bloc/gps_configuration_state.dart';
import 'package:tesla_android/feature/settings/bloc/rear_display_configuration_state.dart';
import 'package:tesla_android/feature/settings/bloc/system_configuration_state.dart';
import 'package:tesla_android/feature/settings/model/device_info.dart';
import 'package:tesla_android/feature/settings/model/system_configuration_response_body.dart';

import 'mock_cubits.mocks.dart';

/// Shared builders for creating configured mock cubits
/// Reduces duplication across widget and integration tests
class CubitBuilders {
  /// Creates a fully configured mock ConnectivityCheckCubit
  static MockConnectivityCheckCubit buildConnectivityCheckCubit({
    ConnectivityState? state,
    Stream<ConnectivityState>? stream,
  }) {
    final cubit = MockConnectivityCheckCubit();
    when(cubit.state).thenReturn(state ?? ConnectivityState.backendAccessible);
    when(cubit.stream).thenAnswer(
      (_) =>
          stream ?? Stream.value(state ?? ConnectivityState.backendAccessible),
    );
    return cubit;
  }

  /// Creates a fully configured mock DisplayCubit
  static MockDisplayCubit buildDisplayCubit({
    DisplayState? state,
    Stream<DisplayState>? stream,
  }) {
    final cubit = MockDisplayCubit();
    when(cubit.state).thenReturn(
      state ??
          DisplayStateNormal(
            viewSize: const Size(1280, 720),
            adjustedSize: const Size(1280, 720),
            rendererType: DisplayRendererType.mjpeg,
          ),
    );
    when(cubit.stream).thenAnswer((_) => stream ?? const Stream.empty());
    when(cubit.onWindowSizeChanged(any)).thenAnswer((_) async {});
    return cubit;
  }

  /// Creates a fully configured mock AudioConfigurationCubit
  static MockAudioConfigurationCubit buildAudioConfigurationCubit({
    AudioConfigurationState? state,
    Stream<AudioConfigurationState>? stream,
  }) {
    final cubit = MockAudioConfigurationCubit();
    when(cubit.state).thenReturn(
      state ??
          AudioConfigurationStateSettingsFetched(isEnabled: true, volume: 100),
    );
    when(cubit.stream).thenAnswer((_) => stream ?? const Stream.empty());
    when(cubit.fetchConfiguration()).thenAnswer((_) async {});
    return cubit;
  }

  /// Creates a fully configured mock OTAUpdateCubit
  static MockOTAUpdateCubit buildOTAUpdateCubit({
    OTAUpdateState? state,
    Stream<OTAUpdateState>? stream,
  }) {
    final cubit = MockOTAUpdateCubit();
    when(cubit.state).thenReturn(state ?? OTAUpdateStateInitial());
    when(cubit.stream).thenAnswer((_) => stream ?? const Stream.empty());
    return cubit;
  }

  /// Creates a fully configured mock TouchscreenCubit
  static MockTouchscreenCubit buildTouchscreenCubit({
    bool? state,
    Stream<bool>? stream,
  }) {
    final cubit = MockTouchscreenCubit();
    when(cubit.state).thenReturn(state ?? false);
    when(cubit.stream).thenAnswer((_) => stream ?? const Stream.empty());
    return cubit;
  }

  /// Creates a fully configured mock DisplayConfigurationCubit
  static MockDisplayConfigurationCubit buildDisplayConfigurationCubit({
    DisplayConfigurationState? state,
    Stream<DisplayConfigurationState>? stream,
  }) {
    final cubit = MockDisplayConfigurationCubit();
    when(cubit.state).thenReturn(
      state ??
          DisplayConfigurationStateSettingsFetched(
            resolutionPreset: DisplayResolutionModePreset.res720p,
            renderer: DisplayRendererType.mjpeg,
            isResponsive: true,
            quality: DisplayQualityPreset.quality60,
            refreshRate: DisplayRefreshRatePreset.refresh60hz,
          ),
    );
    when(cubit.stream).thenAnswer((_) => stream ?? const Stream.empty());
    return cubit;
  }

  /// Creates a fully configured mock RearDisplayConfigurationCubit
  static MockRearDisplayConfigurationCubit buildRearDisplayConfigurationCubit({
    RearDisplayConfigurationState? state,
    Stream<RearDisplayConfigurationState>? stream,
  }) {
    final cubit = MockRearDisplayConfigurationCubit();
    when(cubit.state).thenReturn(
      state ??
          RearDisplayConfigurationStateSettingsFetched(
            isRearDisplayEnabled: false,
            isRearDisplayPrioritised: false,
            isCurrentDisplayPrimary: true,
          ),
    );
    when(cubit.stream).thenAnswer((_) => stream ?? const Stream.empty());
    return cubit;
  }

  /// Creates a fully configured mock SystemConfigurationCubit
  static MockSystemConfigurationCubit buildSystemConfigurationCubit({
    SystemConfigurationState? state,
    Stream<SystemConfigurationState>? stream,
  }) {
    final cubit = MockSystemConfigurationCubit();
    when(cubit.state).thenReturn(
      state ??
          SystemConfigurationStateSettingsFetched(
            currentConfiguration: SystemConfigurationResponseBody(
              isEnabledFlag: 1,
              bandType: 1,
              channel: 6,
              channelWidth: 2,
              isOfflineModeEnabledFlag: 0,
              isOfflineModeTelemetryEnabledFlag: 0,
              isOfflineModeTeslaFirmwareDownloadsEnabledFlag: 0,
              browserAudioIsEnabled: 1,
              browserAudioVolume: 100,
              isGPSEnabled: 1,
            ),
          ),
    );
    when(cubit.stream).thenAnswer((_) => stream ?? const Stream.empty());
    return cubit;
  }

  /// Creates a fully configured mock GPSConfigurationCubit
  static MockGPSConfigurationCubit buildGPSConfigurationCubit({
    GPSConfigurationState? state,
    Stream<GPSConfigurationState>? stream,
  }) {
    final cubit = MockGPSConfigurationCubit();
    when(
      cubit.state,
    ).thenReturn(state ?? GPSConfigurationStateLoaded(isGPSEnabled: true));
    when(cubit.stream).thenAnswer((_) => stream ?? const Stream.empty());
    return cubit;
  }

  /// Creates a fully configured mock DeviceInfoCubit
  static MockDeviceInfoCubit buildDeviceInfoCubit({
    DeviceInfoState? state,
    Stream<DeviceInfoState>? stream,
  }) {
    final cubit = MockDeviceInfoCubit();
    when(cubit.state).thenReturn(
      state ??
          DeviceInfoStateLoaded(
            deviceInfo: const DeviceInfo(
              cpuTemperature: 40,
              serialNumber: "123",
              deviceModel: "Raspberry Pi 4",
              isCarPlayDetected: 0,
              isModemDetected: 0,
              releaseType: "stable",
              otaUrl: "http://example.com",
              isGPSEnabled: 1,
            ),
          ),
    );
    when(cubit.stream).thenAnswer((_) => stream ?? const Stream.empty());
    return cubit;
  }
}
