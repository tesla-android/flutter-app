import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/feature/settings/bloc/audio_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/device_info_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/display_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/gps_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/rear_display_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/system_configuration_cubit.dart';

import 'package:get_it/get_it.dart';
import 'package:tesla_android/common/navigation/ta_page_factory.dart';
import 'cubit_builders.dart';

/// Test helpers for settings widgets
///
/// Provides convenient wrapper functions to reduce boilerplate in widget tests.
class SettingsTestHelpers {
  /// Creates a testable widget wrapped with MaterialApp and a single BlocProvider
  ///
  /// Example:
  /// ```dart
  /// await tester.pumpWidget(
  ///   SettingsTestHelpers.buildWithSingleProvider<DisplayConfigurationCubit>(
  ///     provider: mockDisplayCubit,
  ///     child: const DisplaySettings(),
  ///   ),
  /// );
  /// ```
  static Widget buildWithSingleProvider<
    T extends StateStreamableSource<Object?>
  >({required T provider, required Widget child}) {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<T>.value(value: provider, child: child),
      ),
    );
  }

  /// Creates a testable widget wrapped with MaterialApp and Scaffold
  ///
  /// Uses provided child directly in a Scaffold
  ///
  /// Example:
  /// ```dart
  /// await tester.pumpWidget(
  ///   SettingsTestHelpers.buildWithProvider(
  ///     child: BlocProvider<DisplayConfigurationCubit>.value(
  ///       value: mockDisplayCubit,
  ///       child: const DisplaySettings(),
  ///     ),
  ///   ),
  /// );
  /// ```
  static Widget buildWithProvider({required Widget child}) {
    return MaterialApp(home: Scaffold(body: child));
  }

  /// Creates the standard MultiBlocProvider for settings widgets
  static MultiBlocProvider _buildSettingsProviders({
    DisplayConfigurationCubit? displayCubit,
    RearDisplayConfigurationCubit? rearDisplayCubit,
    SystemConfigurationCubit? systemCubit,
    AudioConfigurationCubit? audioCubit,
    GPSConfigurationCubit? gpsCubit,
    DeviceInfoCubit? deviceInfoCubit,
    required Widget child,
  }) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DisplayConfigurationCubit>.value(
          value: displayCubit ?? CubitBuilders.buildDisplayConfigurationCubit(),
        ),
        BlocProvider<RearDisplayConfigurationCubit>.value(
          value:
              rearDisplayCubit ??
              CubitBuilders.buildRearDisplayConfigurationCubit(),
        ),
        BlocProvider<SystemConfigurationCubit>.value(
          value: systemCubit ?? CubitBuilders.buildSystemConfigurationCubit(),
        ),
        BlocProvider<AudioConfigurationCubit>.value(
          value: audioCubit ?? CubitBuilders.buildAudioConfigurationCubit(),
        ),
        BlocProvider<GPSConfigurationCubit>.value(
          value: gpsCubit ?? CubitBuilders.buildGPSConfigurationCubit(),
        ),
        BlocProvider<DeviceInfoCubit>.value(
          value: deviceInfoCubit ?? CubitBuilders.buildDeviceInfoCubit(),
        ),
      ],
      child: child,
    );
  }

  /// Creates a testable settings widget with all standard settings providers
  ///
  /// Automatically creates default cubits using CubitBuilders.
  /// Override specific cubits by passing them as parameters.
  ///
  /// Example:
  /// ```dart
  /// await tester.pumpWidget(
  ///   SettingsTestHelpers.buildSettingsWidget(
  ///     displayCubit: customMockCubit,
  ///     child: const DisplaySettings(),
  ///   ),
  /// );
  /// ```
  static Widget buildSettingsWidget({
    DisplayConfigurationCubit? displayCubit,
    RearDisplayConfigurationCubit? rearDisplayCubit,
    SystemConfigurationCubit? systemCubit,
    AudioConfigurationCubit? audioCubit,
    GPSConfigurationCubit? gpsCubit,
    DeviceInfoCubit? deviceInfoCubit,
    required Widget child,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: _buildSettingsProviders(
          displayCubit: displayCubit,
          rearDisplayCubit: rearDisplayCubit,
          systemCubit: systemCubit,
          audioCubit: audioCubit,
          gpsCubit: gpsCubit,
          deviceInfoCubit: deviceInfoCubit,
          child: child,
        ),
      ),
    );
  }

  /// Creates a simple MaterialApp wrapper for basic widget tests
  ///
  /// Use when you don't need any providers.
  ///
  /// Example:
  /// ```dart
  /// await tester.pumpWidget(
  ///   SettingsTestHelpers.buildSimpleWrapper(
  ///     child: const Text('Hello'),
  ///   ),
  /// );
  /// ```
  static Widget buildSimpleWrapper({required Widget child}) {
    return MaterialApp(home: Scaffold(body: child));
  }

  /// Creates a widget with custom theme for testing theme-dependent widgets
  static Widget buildWithTheme({required Widget child, ThemeData? theme}) {
    return MaterialApp(
      theme: theme ?? ThemeData.light(),
      home: Scaffold(body: child),
    );
  }

  /// Sets up GetIt mocks for integration tests
  ///
  /// Registers necessary mocks like TAPageFactory.
  /// Returns the registered mocks for further configuration.
  static void setupGetItMocks({required TAPageFactory mockPageFactory}) {
    final getIt = GetIt.instance;
    if (getIt.isRegistered<TAPageFactory>()) {
      getIt.unregister<TAPageFactory>();
    }
    getIt.registerSingleton<TAPageFactory>(mockPageFactory);
  }

  /// Wraps a widget with full settings page environment including GetIt
  ///
  /// Use this for testing the SettingsPage itself or widgets that rely on
  /// navigation or other GetIt services.
  static Widget buildSettingsPageWrapper({
    DisplayConfigurationCubit? displayCubit,
    RearDisplayConfigurationCubit? rearDisplayCubit,
    SystemConfigurationCubit? systemCubit,
    AudioConfigurationCubit? audioCubit,
    GPSConfigurationCubit? gpsCubit,
    DeviceInfoCubit? deviceInfoCubit,
    required Widget child,
  }) {
    return MaterialApp(
      home: _buildSettingsProviders(
        displayCubit: displayCubit,
        rearDisplayCubit: rearDisplayCubit,
        systemCubit: systemCubit,
        audioCubit: audioCubit,
        gpsCubit: gpsCubit,
        deviceInfoCubit: deviceInfoCubit,
        child: child,
      ),
    );
  }
}
