import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:tesla_android/common/service/dialog_service.dart';
import 'package:tesla_android/feature/settings/bloc/system_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/system_configuration_state.dart';
import 'package:tesla_android/feature/settings/model/system_configuration_response_body.dart';
import 'package:tesla_android/feature/settings/widget/hotspot_settings.dart';

import '../helpers/cubit_builders.dart';
import '../helpers/mock_services.mocks.dart';
import '../helpers/settings_test_helpers.dart';

void main() {
  late MockDialogService mockDialogService;
  late SystemConfigurationCubit mockSystemCubit;

  setUp(() {
    mockDialogService = MockDialogService();
    mockSystemCubit = CubitBuilders.buildSystemConfigurationCubit();

    final getIt = GetIt.instance;
    if (getIt.isRegistered<DialogService>()) {
      getIt.unregister<DialogService>();
    }
    getIt.registerSingleton<DialogService>(mockDialogService);
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  testWidgets('HotspotSettings shows banner when settings are modified', (
    WidgetTester tester,
  ) async {
    // Arrange
    final testConfig = SystemConfigurationResponseBody(
      bandType: 1,
      channel: 6,
      channelWidth: 2,
      isEnabledFlag: 1,
      isOfflineModeEnabledFlag: 1,
      isOfflineModeTelemetryEnabledFlag: 0,
      isOfflineModeTeslaFirmwareDownloadsEnabledFlag: 1,
      browserAudioIsEnabled: 1,
      browserAudioVolume: 100,
      isGPSEnabled: 1,
    );

    when(mockSystemCubit.state).thenReturn(
      SystemConfigurationStateSettingsFetched(currentConfiguration: testConfig),
    );

    when(mockSystemCubit.stream).thenAnswer(
      (_) => Stream.fromIterable([
        SystemConfigurationStateSettingsFetched(
          currentConfiguration: testConfig,
        ),
        SystemConfigurationStateSettingsModified(
          currentConfiguration: testConfig,
          newBandType: testConfig.currentSoftApBandType,
          isSoftApEnabled: true,
          isOfflineModeEnabled: false, // Changed value
          isOfflineModeTelemetryEnabled: false,
          isOfflineModeTeslaFirmwareDownloadsEnabled: true,
        ),
      ]),
    );

    // Act
    await tester.pumpWidget(
      SettingsTestHelpers.buildSettingsWidget(
        systemCubit: mockSystemCubit,
        child: const HotspotSettings(),
      ),
    );
    await tester.pump(); // Process initial state
    await tester.pump(); // Process stream update

    // Assert
    verify(
      mockDialogService.showMaterialBanner(
        context: anyNamed('context'),
        banner: anyNamed('banner'),
      ),
    ).called(1);
  });
}
