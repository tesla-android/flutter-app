import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/utils/logger.dart';
import 'package:tesla_android/feature/settings/bloc/system_configuration_state.dart';
import 'package:tesla_android/feature/settings/model/softap_band_type.dart';
import 'package:tesla_android/feature/settings/repository/system_configuration_repository.dart';

@injectable
class SystemConfigurationCubit extends Cubit<SystemConfigurationState>
    with Logger {
  final SystemConfigurationRepository _repository;
  final GlobalKey<NavigatorState> _navigatorState;

  SystemConfigurationCubit(this._repository, this._navigatorState)
      : super(SystemConfigurationStateInitial());

  Future<void> fetchConfiguration() async {
    emit(SystemConfigurationStateLoading());
    try {
      final configuration = await _repository.getConfiguration();
      emit(SystemConfigurationStateSettingsFetched(
          currentConfiguration: configuration));
    } catch (exception, stackTrace) {
      logException(
          exception: exception, stackTrace: stackTrace);
      if (!isClosed) emit(SystemConfigurationStateSettingsFetchingError());
    }
  }

  void updateSoftApBand(SoftApBandType newBand) {
    if (state is SystemConfigurationStateSettingsModified) {
      if (!isClosed) {
        emit((state as SystemConfigurationStateSettingsModified)
            .copyWith(newBandType: newBand));
      }
    }
    if (state is SystemConfigurationStateSettingsFetched) {
      if (!isClosed) {
        emit(
          SystemConfigurationStateSettingsModified.fromCurrentConfiguration(
            currentConfiguration:
                (state as SystemConfigurationStateSettingsFetched)
                    .currentConfiguration,
            newBandType: newBand,
            isSoftApEnabled: true,
          ),
        );
      }
    }
    showConfigurationChangedBanner();
  }

  void updateSoftApState(bool isEnabled) {
    if (state is SystemConfigurationStateSettingsModified) {
      if (!isClosed) {
        emit((state as SystemConfigurationStateSettingsModified)
            .copyWith(isSoftApEnabled: isEnabled));
      }
    }
    if (state is SystemConfigurationStateSettingsFetched) {
      final configuration = (state as SystemConfigurationStateSettingsFetched)
          .currentConfiguration;
      final band = configuration.currentSoftApBandType;
      if (!isClosed) {
        emit(
          SystemConfigurationStateSettingsModified.fromCurrentConfiguration(
            currentConfiguration: configuration,
            newBandType: band,
            isSoftApEnabled: isEnabled,
          ),
        );
      }
    }
    showConfigurationChangedBanner();
  }

  void updateOfflineModeState(bool isEnabled) {
    if (state is SystemConfigurationStateSettingsModified) {
      if (!isClosed) {
        emit((state as SystemConfigurationStateSettingsModified)
            .copyWith(isOfflineModeEnabled: isEnabled));
      }
    }
    if (state is SystemConfigurationStateSettingsFetched) {
      final configuration = (state as SystemConfigurationStateSettingsFetched)
          .currentConfiguration;
      if (!isClosed) {
        emit(
          SystemConfigurationStateSettingsModified.fromCurrentConfiguration(
            currentConfiguration: configuration,
            isOfflineModeEnabled: isEnabled,
          ),
        );
      }
    }
    showConfigurationChangedBanner();
  }

  void updateOfflineModeTelemetryState(bool isEnabled) {
    if (state is SystemConfigurationStateSettingsModified) {
      if (!isClosed) {
        emit((state as SystemConfigurationStateSettingsModified)
            .copyWith(isOfflineModeTelemetryEnabled: isEnabled));
      }
    }
    if (state is SystemConfigurationStateSettingsFetched) {
      final configuration = (state as SystemConfigurationStateSettingsFetched)
          .currentConfiguration;
      if (!isClosed) {
        emit(
          SystemConfigurationStateSettingsModified.fromCurrentConfiguration(
            currentConfiguration: configuration,
            isOfflineModeTelemetryEnabled: isEnabled,
          ),
        );
      }
    }
    showConfigurationChangedBanner();
  }

  void updateOfflineModeTeslaFirmwareDownloadsState(bool isEnabled) {
    if (state is SystemConfigurationStateSettingsModified) {
      if (!isClosed) {
        emit((state as SystemConfigurationStateSettingsModified)
            .copyWith(isOfflineModeTeslaFirmwareDownloadsEnabled: isEnabled));
      }
    }
    if (state is SystemConfigurationStateSettingsFetched) {
      final configuration = (state as SystemConfigurationStateSettingsFetched)
          .currentConfiguration;
      if (!isClosed) {
        emit(
          SystemConfigurationStateSettingsModified.fromCurrentConfiguration(
            currentConfiguration: configuration,
            isOfflineModeTeslaFirmwareDownloadsEnabled: isEnabled,
          ),
        );
      }
    }
    showConfigurationChangedBanner();
  }

  void showConfigurationChangedBanner() {
    final context = _navigatorState.currentContext!;
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: const Text(
            'System configuration has been updated. Would you like to apply it during the next system startup?'),
        leading: const Icon(Icons.settings),
        actions: [
          IconButton(
              onPressed: () {
                applySystemConfiguration();
                ScaffoldMessenger.of(context).clearMaterialBanners();
              },
              icon: const Icon(Icons.save)),
        ],
      ),
    );
  }

  void applySystemConfiguration() async {
    if (state is SystemConfigurationStateSettingsModified) {
      final configState = (state as SystemConfigurationStateSettingsModified);
      final newBand = configState.newBandType;
      final isEnabledFlag = configState.isSoftApEnabled;
      final isOfflineModeEnabledFlag = configState.isOfflineModeEnabled;
      final isOfflineModeTelemetryEnabledFlag =
          configState.isOfflineModeTelemetryEnabled;
      final isOfflineModeTeslaFirmwareDownloadsEnabledFlag =
          configState.isOfflineModeTeslaFirmwareDownloadsEnabled;
      try {
        await _repository.setSoftApBand(newBand.band);
        await _repository.setSoftApChannelWidth(newBand.channelWidth);
        await _repository.setSoftApChannel(newBand.channel);
        await _repository.setSoftApState(isEnabledFlag ? 1 : 0);
        await _repository.setOfflineModeState(isOfflineModeEnabledFlag ? 1 : 0);
        await _repository.setOfflineModeTelemetryState(
            isOfflineModeTelemetryEnabledFlag ? 1 : 0);
        await _repository.setOfflineModeTeslaFirmwareDownloads(
            isOfflineModeTeslaFirmwareDownloadsEnabledFlag ? 1 : 0);
      } catch (exception, stackTrace) {
        logException(
            exception: exception, stackTrace: stackTrace);
        if (!isClosed) {
          emit(SystemConfigurationStateSettingsSavingFailedError());
        }
      }
    }
  }
}
