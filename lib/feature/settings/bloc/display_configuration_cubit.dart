import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/utils/logger.dart';
import 'package:tesla_android/feature/display/model/remote_display_state.dart';
import 'package:tesla_android/feature/display/repository/display_repository.dart';
import 'package:tesla_android/feature/settings/bloc/display_configuration_state.dart';

@injectable
class DisplayConfigurationCubit extends Cubit<DisplayConfigurationState>
    with Logger {
  final DisplayRepository _repository;
  final GlobalKey<NavigatorState> _navigatorKey;

  RemoteDisplayState? _currentConfig;

  DisplayConfigurationCubit(this._repository, this._navigatorKey)
      : super(DisplayConfigurationStateInitial());

  void fetchConfiguration() async {
    if (!isClosed) emit(DisplayConfigurationStateLoading());
    try {
      _currentConfig = await _repository.getDisplayState();
      emit(
        DisplayConfigurationStateSettingsFetched(
          lowResModePreset: _currentConfig!.lowRes,
          renderer: _currentConfig!.renderer,
        ),
      );
    } catch (exception, stacktrace) {
      logException(
        exception: exception,
        stackTrace: stacktrace,
      );
      if (!isClosed) {
        emit(
        DisplayConfigurationStateError(),
      );
      }
    }
  }

  void setResolution(DisplayResolutionModePreset newPreset) async {
    var config = _currentConfig;
    if (config != null) {
      config = config.updateResolution(newPreset: newPreset);
      if (!isClosed) emit(DisplayConfigurationStateSettingsUpdateInProgress());
      try {
        await _repository.updateDisplayConfiguration(config);
        if (!isClosed) {
          emit(DisplayConfigurationStateSettingsFetched(
          lowResModePreset: newPreset,
          renderer: _currentConfig!.renderer,
        ));
        }
      } catch (exception, stackTrace) {
        logExceptionAndUploadToSentry(
            exception: exception, stackTrace: stackTrace);
        if (!isClosed) emit(DisplayConfigurationStateError());
      }
    } else {
      log("_currentConfig not available");
    }
  }

  void setRenderer(DisplayRendererType newType) async {
    var config = _currentConfig;
    if (config != null) {
      config = config.updateRenderer(newType: newType);
      if (!isClosed) emit(DisplayConfigurationStateSettingsUpdateInProgress());
      try {
        await _repository.updateDisplayConfiguration(config);
        if (!isClosed) {
          emit(DisplayConfigurationStateSettingsFetched(
          lowResModePreset: _currentConfig!.lowRes,
          renderer: newType,
        ));
        }
        final context = _navigatorKey.currentContext;
        if (context != null && context.mounted) {
          ScaffoldMessenger.of(context).showMaterialBanner(
            MaterialBanner(
              content: const Text(
                  'Renderer has been changed. Restarting the Flutter app is recommended'),
              leading: const Icon(Icons.settings),
              actions: [
                IconButton(
                    onPressed: () {
                      window.location.reload();
                    },
                    icon: const Icon(Icons.restart_alt)),
              ],
            ),
          );
        }
      } catch (exception, stackTrace) {
        logExceptionAndUploadToSentry(
            exception: exception, stackTrace: stackTrace);
        if (!isClosed) emit(DisplayConfigurationStateError());
      }
    } else {
      log("_currentConfig not available");
    }
  }
}
