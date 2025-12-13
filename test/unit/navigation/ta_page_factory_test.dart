import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:mockito/mockito.dart';
import 'package:tesla_android/common/navigation/ta_page.dart';
import 'package:tesla_android/common/navigation/ta_page_factory.dart';
import 'package:tesla_android/feature/about/about_page.dart';
import 'package:tesla_android/feature/donations/widget/donation_page.dart';
import 'package:tesla_android/feature/settings/bloc/audio_configuration_state.dart';
import 'package:tesla_android/feature/settings/bloc/gps_configuration_state.dart';
import 'package:tesla_android/feature/display/cubit/display_state.dart';
import 'package:tesla_android/feature/home/cubit/ota_update_state.dart';
import 'package:tesla_android/feature/releaseNotes/cubit/release_notes_state.dart';
import 'package:tesla_android/feature/settings/bloc/display_configuration_state.dart';
import 'package:tesla_android/feature/settings/bloc/rear_display_configuration_state.dart';
import 'package:tesla_android/feature/settings/bloc/system_configuration_state.dart';
import 'package:tesla_android/feature/settings/bloc/device_info_state.dart';
import 'package:tesla_android/feature/connectivityCheck/model/connectivity_state.dart';
import 'package:tesla_android/common/service/audio_service.dart';
import 'package:tesla_android/feature/settings/model/system_configuration_response_body.dart';
import 'package:tesla_android/feature/settings/model/device_info.dart';
import 'package:tesla_android/feature/display/model/remote_display_state.dart';

import '../../helpers/mock_cubits.mocks.dart';

void main() {
  late TAPageFactory pageFactory;
  late MockAudioConfigurationCubit mockAudioCubit;
  late MockGPSConfigurationCubit mockGPSCubit;
  late MockTouchscreenCubit mockTouchscreenCubit;
  late MockDisplayCubit mockDisplayCubit;
  late MockOTAUpdateCubit mockOTACubit;
  late MockReleaseNotesCubit mockReleaseNotesCubit;
  late MockSystemConfigurationCubit mockSystemCubit;
  late MockDisplayConfigurationCubit mockDisplayConfigCubit;
  late MockRearDisplayConfigurationCubit mockRearDisplayCubit;
  late MockDeviceInfoCubit mockDeviceInfoCubit;
  late MockConnectivityCheckCubit mockConnectivityCubit;
  late MockAudioService mockAudioService;

  setUp(() {
    pageFactory = TAPageFactory();

    // Create mocks
    mockAudioCubit = MockAudioConfigurationCubit();
    mockGPSCubit = MockGPSConfigurationCubit();
    mockTouchscreenCubit = MockTouchscreenCubit();
    mockDisplayCubit = MockDisplayCubit();
    mockOTACubit = MockOTAUpdateCubit();
    mockReleaseNotesCubit = MockReleaseNotesCubit();
    mockSystemCubit = MockSystemConfigurationCubit();
    mockDisplayConfigCubit = MockDisplayConfigurationCubit();
    mockRearDisplayCubit = MockRearDisplayConfigurationCubit();
    mockDeviceInfoCubit = MockDeviceInfoCubit();
    mockConnectivityCubit = MockConnectivityCheckCubit();
    mockAudioService = MockAudioService();

    // Register factories in GetIt for page building
    GetIt.I.registerFactory(() => mockAudioCubit);
    GetIt.I.registerFactory(() => mockGPSCubit);
    GetIt.I.registerFactory(() => mockTouchscreenCubit);
    GetIt.I.registerFactory(() => mockDisplayCubit);
    GetIt.I.registerFactory(() => mockOTACubit);
    GetIt.I.registerFactory(() => mockReleaseNotesCubit);
    GetIt.I.registerFactory(() => mockSystemCubit);
    GetIt.I.registerFactory(() => mockDisplayConfigCubit);
    GetIt.I.registerFactory(() => mockRearDisplayCubit);
    GetIt.I.registerFactory(() => mockDeviceInfoCubit);
    GetIt.I.registerFactory(() => mockConnectivityCubit);
    GetIt.I.registerSingleton<AudioService>(mockAudioService);

    // Stub cubit methods & states
    when(mockOTACubit.checkForUpdates()).thenAnswer((_) async {});
    when(mockGPSCubit.fetchConfiguration()).thenAnswer((_) async {});
    when(mockAudioCubit.fetchConfiguration()).thenAnswer((_) async {});
    when(mockDisplayConfigCubit.fetchConfiguration()).thenAnswer((_) async {});
    when(mockRearDisplayCubit.fetchConfiguration()).thenAnswer((_) async {});
    when(mockSystemCubit.fetchConfiguration()).thenAnswer((_) async {});
    when(mockDeviceInfoCubit.fetchConfiguration()).thenAnswer((_) async {});
    when(mockAudioService.getAudioState()).thenReturn("stopped");

    // Default States
    when(mockAudioCubit.state).thenReturn(
      AudioConfigurationStateSettingsFetched(isEnabled: true, volume: 100),
    );
    when(mockAudioCubit.stream).thenAnswer((_) => const Stream.empty());

    when(
      mockGPSCubit.state,
    ).thenReturn(GPSConfigurationStateLoaded(isGPSEnabled: true));
    when(mockGPSCubit.stream).thenAnswer((_) => const Stream.empty());

    when(mockTouchscreenCubit.state).thenReturn(false);
    when(mockTouchscreenCubit.stream).thenAnswer((_) => const Stream.empty());

    when(mockDisplayCubit.state).thenReturn(DisplayStateInitial());
    when(mockDisplayCubit.stream).thenAnswer((_) => const Stream.empty());

    when(mockOTACubit.state).thenReturn(OTAUpdateStateInitial());
    when(mockOTACubit.stream).thenAnswer((_) => const Stream.empty());

    when(mockReleaseNotesCubit.state).thenReturn(ReleaseNotesStateInitial());
    when(mockReleaseNotesCubit.stream).thenAnswer((_) => const Stream.empty());

    when(mockDisplayConfigCubit.state).thenReturn(
      DisplayConfigurationStateSettingsFetched(
        resolutionPreset: DisplayResolutionModePreset.res720p,
        renderer: DisplayRendererType.mjpeg,
        isResponsive: true,
        quality: DisplayQualityPreset.quality80,
        refreshRate: DisplayRefreshRatePreset.refresh30hz,
      ),
    );
    when(mockDisplayConfigCubit.stream).thenAnswer((_) => const Stream.empty());

    when(mockRearDisplayCubit.state).thenReturn(
      RearDisplayConfigurationStateSettingsFetched(
        isRearDisplayEnabled: false,
        isCurrentDisplayPrimary: true,
        isRearDisplayPrioritised: false,
      ),
    );
    when(mockRearDisplayCubit.stream).thenAnswer((_) => const Stream.empty());

    when(mockSystemCubit.state).thenReturn(
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
    when(mockSystemCubit.stream).thenAnswer((_) => const Stream.empty());

    when(mockDeviceInfoCubit.state).thenReturn(
      DeviceInfoStateLoaded(
        deviceInfo: const DeviceInfo(
          cpuTemperature: 40,
          serialNumber: "123",
          deviceModel: "Pi4",
          isCarPlayDetected: 0,
          isModemDetected: 0,
          releaseType: "stable",
          otaUrl: "url",
          isGPSEnabled: 1,
        ),
      ),
    );
    when(mockDeviceInfoCubit.stream).thenAnswer((_) => const Stream.empty());

    when(
      mockConnectivityCubit.state,
    ).thenReturn(ConnectivityState.backendAccessible);
    when(mockConnectivityCubit.stream).thenAnswer((_) => const Stream.empty());

    PackageInfo.setMockInitialValues(
      appName: 'Tesla Android',
      packageName: 'com.teslaandroid',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );

    GetIt.I.registerSingleton<TAPageFactory>(pageFactory);
  });

  tearDown(() {
    GetIt.I.reset();
  });

  group('TAPageFactory', () {
    test('getRoutes returns map with all available page routes', () {
      final routes = pageFactory.getRoutes();
      expect(routes, isNotEmpty);
      expect(routes.length, equals(TAPage.availablePages.length));
    });

    testWidgets('buildPage(home) returns MultiBlocProvider', (tester) async {
      late Widget builtWidget;
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            builtWidget = pageFactory.buildPage(TAPage.home)(context);
            return const SizedBox();
          },
        ),
      );
      expect(builtWidget, isA<MultiBlocProvider>());
    });

    testWidgets('buildPage(settings) returns MultiBlocProvider', (
      tester,
    ) async {
      late Widget builtWidget;
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            builtWidget = pageFactory.buildPage(TAPage.settings)(context);
            return const SizedBox();
          },
        ),
      );
      expect(builtWidget, isA<MultiBlocProvider>());
    });

    testWidgets('buildPage(releaseNotes) returns BlocProvider', (tester) async {
      late Widget builtWidget;
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            builtWidget = pageFactory.buildPage(TAPage.releaseNotes)(context);
            return const SizedBox();
          },
        ),
      );
      expect(builtWidget, isA<BlocProvider>());
    });

    testWidgets('buildPage(about) returns AboutPage', (tester) async {
      late Widget builtWidget;
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            builtWidget = pageFactory.buildPage(TAPage.about)(context);
            return const SizedBox();
          },
        ),
      );
      expect(builtWidget, isA<AboutPage>());
    });

    testWidgets('buildPage(donations) returns DonationPage', (tester) async {
      late Widget builtWidget;
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            builtWidget = pageFactory.buildPage(TAPage.donations)(context);
            return const SizedBox();
          },
        ),
      );
      expect(builtWidget, isA<DonationPage>());
    });

    testWidgets('buildPage(empty) returns SizedBox', (tester) async {
      late Widget builtWidget;
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            builtWidget = pageFactory.buildPage(TAPage.empty)(context);
            return const SizedBox();
          },
        ),
      );
      expect(builtWidget, isA<SizedBox>());
    });
  });
}
