import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:tesla_android/feature/settings/bloc/system_configuration_state.dart';
import 'package:tesla_android/feature/settings/model/softap_band_type.dart';
import 'package:tesla_android/feature/settings/repository/system_configuration_repository.dart';

@injectable
class SystemConfigurationCubit extends Cubit<SystemConfigurationState> {
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
    } catch (exception) {
      Sentry.captureException(exception);
      emit(SystemConfigurationStateSettingsFetchingError());
    }
  }

  void updateSoftApBand(SoftApBandType newBand) {
    if (state is SystemConfigurationStateSettingsModified) {
      emit((state as SystemConfigurationStateSettingsModified)
          .copyWith(newBandType: newBand));
    }
    if (state is SystemConfigurationStateSettingsFetched) {
      emit(
        SystemConfigurationStateSettingsModified(
          currentConfiguration:
              (state as SystemConfigurationStateSettingsFetched)
                  .currentConfiguration,
          newBandType: newBand,
          isSoftApEnabled: true,
        ),
      );
    }
    showConfigurationChangedBanner();
  }

  void updateSoftApState(bool isEnabled) {
    if (state is SystemConfigurationStateSettingsModified) {
      emit((state as SystemConfigurationStateSettingsModified)
          .copyWith(isSoftApEnabled: isEnabled));
    }
    if (state is SystemConfigurationStateSettingsFetched) {
      final configuration = (state as SystemConfigurationStateSettingsFetched)
          .currentConfiguration;
      final band = configuration.currentSoftApBandType;
      emit(
        SystemConfigurationStateSettingsModified(
          currentConfiguration: configuration,
          newBandType: band,
          isSoftApEnabled: isEnabled,
        ),
      );
    }
    showConfigurationChangedBanner();
  }

  void showConfigurationChangedBanner() {
    final context = _navigatorState.currentContext!;
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: const Text(
            'Wi-Fi configuration has been updated. Would you like to apply it during the next system startup?'),
        leading: const Icon(Icons.settings),
        actions: [
          IconButton(
              onPressed: () {
                applySoftApConfiguration();
                ScaffoldMessenger.of(context).clearMaterialBanners();
              },
              icon: const Icon(Icons.save)),
        ],
      ),
    );
  }

  void applySoftApConfiguration() async {
    if (state is SystemConfigurationStateSettingsModified) {
      final configState = (state as SystemConfigurationStateSettingsModified);
      final newBand = configState.newBandType;
      final isEnabledFlag = configState.isSoftApEnabled;
      try {
        await _repository.setSoftApBand(newBand.band);
        await _repository.setSoftApChannelWidth(newBand.channelWidth);
        await _repository.setSoftApChannel(newBand.channel);
        await _repository.setSoftApState(isEnabledFlag ? 1 : 0);
      } catch (exception) {
        Sentry.captureException(exception);
        emit(SystemConfigurationStateSettingsSavingFailedError());
      }
    }
  }
}
