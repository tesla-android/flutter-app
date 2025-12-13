import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:tesla_android/feature/connectivityCheck/cubit/connectivity_check_cubit.dart';
import 'package:tesla_android/feature/connectivityCheck/model/connectivity_state.dart';
import 'package:tesla_android/feature/display/cubit/display_cubit.dart';
import 'package:tesla_android/feature/display/cubit/display_state.dart';
import 'package:tesla_android/feature/display/model/remote_display_state.dart';
import 'package:tesla_android/feature/home/cubit/ota_update_cubit.dart';
import 'package:tesla_android/feature/home/cubit/ota_update_state.dart';
import 'package:tesla_android/feature/home/home_page.dart';
import 'package:tesla_android/feature/home/widget/audio_button.dart';
import 'package:tesla_android/feature/home/widget/settings_button.dart';
import 'package:tesla_android/feature/home/widget/update_button.dart';
import 'package:tesla_android/feature/settings/bloc/audio_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/audio_configuration_state.dart';
import 'package:tesla_android/feature/touchscreen/cubit/touchscreen_cubit.dart';
import 'package:tesla_android/common/service/audio_service.dart';

import '../../helpers/cubit_builders.dart';
import '../../helpers/mock_cubits.mocks.dart';

void main() {
  late MockConnectivityCheckCubit mockConnectivityCheckCubit;
  late MockDisplayCubit mockDisplayCubit;
  late MockAudioConfigurationCubit mockAudioConfigurationCubit;
  late MockOTAUpdateCubit mockOTAUpdateCubit;

  late MockTouchscreenCubit mockTouchscreenCubit;
  late MockAudioService mockAudioService;

  setUp(() {
    // Use CubitBuilders for consistent mock setup
    mockConnectivityCheckCubit = CubitBuilders.buildConnectivityCheckCubit();
    mockDisplayCubit = CubitBuilders.buildDisplayCubit();
    mockAudioConfigurationCubit = CubitBuilders.buildAudioConfigurationCubit();
    mockOTAUpdateCubit = CubitBuilders.buildOTAUpdateCubit();
    mockTouchscreenCubit = CubitBuilders.buildTouchscreenCubit();

    mockAudioService = MockAudioService();
    when(mockAudioService.getAudioState()).thenReturn('stopped');
    when(mockAudioService.addAudioStateListener(any)).thenReturn(() {});

    GetIt.I.registerSingleton<ConnectivityCheckCubit>(
      mockConnectivityCheckCubit,
    );
    GetIt.I.registerSingleton<DisplayCubit>(mockDisplayCubit);
    GetIt.I.registerSingleton<AudioConfigurationCubit>(
      mockAudioConfigurationCubit,
    );
    GetIt.I.registerSingleton<OTAUpdateCubit>(mockOTAUpdateCubit);
    GetIt.I.registerSingleton<TouchscreenCubit>(mockTouchscreenCubit);
    GetIt.I.registerSingleton<AudioService>(mockAudioService);
  });

  tearDown(() {
    GetIt.I.reset();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ConnectivityCheckCubit>.value(
            value: mockConnectivityCheckCubit,
          ),
          BlocProvider<DisplayCubit>.value(value: mockDisplayCubit),
          BlocProvider<AudioConfigurationCubit>.value(
            value: mockAudioConfigurationCubit,
          ),
          BlocProvider<OTAUpdateCubit>.value(value: mockOTAUpdateCubit),
          BlocProvider<TouchscreenCubit>.value(value: mockTouchscreenCubit),
        ],
        child: HomePage(),
      ),
    );
  }

  testWidgets('HomePage renders DisplayView when backend is accessible', (
    tester,
  ) async {
    // CubitBuilders already set up defaults: backendAccessible, DisplayStateNormal, etc.
    // Only override if we need different values

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(AudioButton), findsOneWidget);
    expect(find.byType(UpdateButton), findsOneWidget);
    expect(find.byType(SettingsButton), findsOneWidget);
    // DisplayView is stubbed in VM tests, but we can check if it's in the tree
    // The stub returns a Center with Text("DisplayView is not supported on this platform")
    expect(
      find.text("DisplayView is not supported on this platform"),
      findsOneWidget,
    );
  });

  testWidgets('HomePage renders error icon when backend is unreachable', (
    tester,
  ) async {
    when(
      mockConnectivityCheckCubit.state,
    ).thenReturn(ConnectivityState.backendUnreachable);
    when(
      mockConnectivityCheckCubit.stream,
    ).thenAnswer((_) => const Stream.empty());

    when(mockDisplayCubit.state).thenReturn(DisplayStateInitial());
    when(mockDisplayCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // pump once to rebuild

    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.byType(AudioButton), findsNothing);
  });

  testWidgets('HomePage shows display type selection dialog when triggered', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    when(
      mockConnectivityCheckCubit.state,
    ).thenReturn(ConnectivityState.backendAccessible);
    when(
      mockConnectivityCheckCubit.stream,
    ).thenAnswer((_) => const Stream.empty());

    // Start with initial state
    when(mockDisplayCubit.state).thenReturn(
      DisplayStateNormal(
        viewSize: const Size(1280, 720),
        adjustedSize: const Size(1280, 720),
        rendererType: DisplayRendererType.mjpeg,
      ),
    );

    // Create a controller to simulate stream events
    final displayStateController = StreamController<DisplayState>.broadcast();
    when(
      mockDisplayCubit.stream,
    ).thenAnswer((_) => displayStateController.stream);

    when(mockAudioConfigurationCubit.state).thenReturn(
      AudioConfigurationStateSettingsFetched(isEnabled: true, volume: 100),
    );
    when(
      mockAudioConfigurationCubit.stream,
    ).thenAnswer((_) => const Stream.empty());
    when(
      mockAudioConfigurationCubit.fetchConfiguration(),
    ).thenAnswer((_) async {});

    when(mockOTAUpdateCubit.state).thenReturn(OTAUpdateStateInitial());
    when(mockOTAUpdateCubit.stream).thenAnswer((_) => const Stream.empty());

    when(mockTouchscreenCubit.state).thenReturn(false);
    when(mockTouchscreenCubit.stream).thenAnswer((_) => const Stream.empty());

    when(mockDisplayCubit.onWindowSizeChanged(any)).thenAnswer((_) async {});

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();
    await tester.pump();

    // Emit the trigger state
    when(
      mockDisplayCubit.state,
    ).thenReturn(DisplayStateDisplayTypeSelectionTriggered());
    displayStateController.add(DisplayStateDisplayTypeSelectionTriggered());

    // Emit normal state to stop CircularProgressIndicator and allow pumpAndSettle
    when(mockDisplayCubit.state).thenReturn(
      DisplayStateNormal(
        viewSize: const Size(1280, 720),
        adjustedSize: const Size(1280, 720),
        rendererType: DisplayRendererType.mjpeg,
      ),
    );
    displayStateController.add(
      DisplayStateNormal(
        viewSize: const Size(1280, 720),
        adjustedSize: const Size(1280, 720),
        rendererType: DisplayRendererType.mjpeg,
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Display Type'), findsOneWidget);
    expect(find.text('MAIN DISPLAY'), findsOneWidget);
    expect(find.text('REAR DISPLAY'), findsOneWidget);

    await displayStateController.close();
  });

  testWidgets('HomePage dialog - MAIN DISPLAY button calls cubit correctly', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    when(
      mockConnectivityCheckCubit.state,
    ).thenReturn(ConnectivityState.backendAccessible);
    when(
      mockConnectivityCheckCubit.stream,
    ).thenAnswer((_) => const Stream.empty());

    when(mockDisplayCubit.state).thenReturn(
      DisplayStateNormal(
        viewSize: const Size(1280, 720),
        adjustedSize: const Size(1280, 720),
        rendererType: DisplayRendererType.mjpeg,
      ),
    );

    final displayStateController = StreamController<DisplayState>.broadcast();
    when(
      mockDisplayCubit.stream,
    ).thenAnswer((_) => displayStateController.stream);
    when(mockDisplayCubit.onWindowSizeChanged(any)).thenAnswer((_) async {});
    when(
      mockDisplayCubit.onDisplayTypeSelectionFinished(
        isPrimaryDisplay: anyNamed('isPrimaryDisplay'),
      ),
    ).thenAnswer((_) async {});

    when(mockAudioConfigurationCubit.state).thenReturn(
      AudioConfigurationStateSettingsFetched(isEnabled: true, volume: 100),
    );
    when(
      mockAudioConfigurationCubit.stream,
    ).thenAnswer((_) => const Stream.empty());

    when(mockOTAUpdateCubit.state).thenReturn(OTAUpdateStateInitial());
    when(mockOTAUpdateCubit.stream).thenAnswer((_) => const Stream.empty());

    when(mockTouchscreenCubit.state).thenReturn(false);
    when(mockTouchscreenCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Trigger dialog
    when(
      mockDisplayCubit.state,
    ).thenReturn(DisplayStateDisplayTypeSelectionTriggered());
    displayStateController.add(DisplayStateDisplayTypeSelectionTriggered());

    when(mockDisplayCubit.state).thenReturn(
      DisplayStateNormal(
        viewSize: const Size(1280, 720),
        adjustedSize: const Size(1280, 720),
        rendererType: DisplayRendererType.mjpeg,
      ),
    );
    displayStateController.add(
      DisplayStateNormal(
        viewSize: const Size(1280, 720),
        adjustedSize: const Size(1280, 720),
        rendererType: DisplayRendererType.mjpeg,
      ),
    );

    await tester.pumpAndSettle();

    // Tap MAIN DISPLAY button
    await tester.tap(find.text('MAIN DISPLAY'));
    await tester.pumpAndSettle();

    // Verify cubit was called with isPrimaryDisplay: true
    verify(
      mockDisplayCubit.onDisplayTypeSelectionFinished(isPrimaryDisplay: true),
    ).called(1);

    // Verify dialog closed
    expect(find.text('Display Type'), findsNothing);

    await displayStateController.close();
  });

  testWidgets('HomePage dialog - REAR DISPLAY button calls cubit correctly', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    when(
      mockConnectivityCheckCubit.state,
    ).thenReturn(ConnectivityState.backendAccessible);
    when(
      mockConnectivityCheckCubit.stream,
    ).thenAnswer((_) => const Stream.empty());

    when(mockDisplayCubit.state).thenReturn(
      DisplayStateNormal(
        viewSize: const Size(1280, 720),
        adjustedSize: const Size(1280, 720),
        rendererType: DisplayRendererType.mjpeg,
      ),
    );

    final displayStateController = StreamController<DisplayState>.broadcast();
    when(
      mockDisplayCubit.stream,
    ).thenAnswer((_) => displayStateController.stream);
    when(mockDisplayCubit.onWindowSizeChanged(any)).thenAnswer((_) async {});
    when(
      mockDisplayCubit.onDisplayTypeSelectionFinished(
        isPrimaryDisplay: anyNamed('isPrimaryDisplay'),
      ),
    ).thenAnswer((_) async {});

    when(mockAudioConfigurationCubit.state).thenReturn(
      AudioConfigurationStateSettingsFetched(isEnabled: true, volume: 100),
    );
    when(
      mockAudioConfigurationCubit.stream,
    ).thenAnswer((_) => const Stream.empty());

    when(mockOTAUpdateCubit.state).thenReturn(OTAUpdateStateInitial());
    when(mockOTAUpdateCubit.stream).thenAnswer((_) => const Stream.empty());

    when(mockTouchscreenCubit.state).thenReturn(false);
    when(mockTouchscreenCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Trigger dialog
    when(
      mockDisplayCubit.state,
    ).thenReturn(DisplayStateDisplayTypeSelectionTriggered());
    displayStateController.add(DisplayStateDisplayTypeSelectionTriggered());

    when(mockDisplayCubit.state).thenReturn(
      DisplayStateNormal(
        viewSize: const Size(1280, 720),
        adjustedSize: const Size(1280, 720),
        rendererType: DisplayRendererType.mjpeg,
      ),
    );
    displayStateController.add(
      DisplayStateNormal(
        viewSize: const Size(1280, 720),
        adjustedSize: const Size(1280, 720),
        rendererType: DisplayRendererType.mjpeg,
      ),
    );

    await tester.pumpAndSettle();

    // Tap REAR DISPLAY button
    await tester.tap(find.text('REAR DISPLAY'));
    await tester.pumpAndSettle();

    // Verify cubit was called with isPrimaryDisplay: false
    verify(
      mockDisplayCubit.onDisplayTypeSelectionFinished(isPrimaryDisplay: false),
    ).called(1);

    // Verify dialog closed
    expect(find.text('Display Type'), findsNothing);

    await displayStateController.close();
  });
}
