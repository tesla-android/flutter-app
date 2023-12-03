import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:tesla_android/feature/settings/bloc/system_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/system_configuration_state.dart';
import 'package:tesla_android/feature/settings/model/softap_band_type.dart';
import 'package:tesla_android/feature/settings/widget/settings_section.dart';
import 'package:tesla_android/feature/settings/widget/settings_tile.dart';

class HotspotSettings extends SettingsSection {
  const HotspotSettings({super.key})
      : super(
          name: "Network",
          icon: Icons.wifi,
        );

  @override
  Widget body(BuildContext context) {
    return BlocBuilder<SystemConfigurationCubit, SystemConfigurationState>(
      builder: (context, state) {
        if (state is SystemConfigurationStateSettingsFetched ||
            state is SystemConfigurationStateSettingsModified) {
          return _content(context, state);
        } else if (state is SystemConfigurationStateSettingsFetchingError) {
          return const Text(
              "Failed to fetch Wi-Fi configuration from your device.");
        } else if (state is SystemConfigurationStateSettingsSavingFailedError) {
          return const Text("Failed to save your new Wi-Fi configuration");
        } else {
          return const Padding(
            padding: EdgeInsets.all(TADimens.PADDING_L_VALUE),
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget _content(BuildContext context, SystemConfigurationState state) {
    final cubit = BlocProvider.of<SystemConfigurationCubit>(context);
    final selectedBand = (state is SystemConfigurationStateSettingsFetched)
        ? state.currentConfiguration.currentSoftApBandType
        : (state as SystemConfigurationStateSettingsModified).newBandType;
    final isSoftApEnabled = (state is SystemConfigurationStateSettingsFetched)
        ? (state.currentConfiguration.isEnabledFlag == 1 ? true : false)
        : (state as SystemConfigurationStateSettingsModified).isSoftApEnabled;
    final isOfflineModeEnabled =
        (state is SystemConfigurationStateSettingsFetched)
            ? (state.currentConfiguration.isOfflineModeEnabledFlag == 1
                ? true
                : false)
            : (state as SystemConfigurationStateSettingsModified)
                .isOfflineModeEnabled;
    final isOfflineModeTelemetryEnabled =
        (state is SystemConfigurationStateSettingsFetched)
            ? (state.currentConfiguration.isOfflineModeTelemetryEnabledFlag == 1
                ? true
                : false)
            : (state as SystemConfigurationStateSettingsModified)
                .isOfflineModeTelemetryEnabled;
    final isOfflineModeTeslaFirmwareDownloadsEnabled =
        (state is SystemConfigurationStateSettingsFetched)
            ? (state.currentConfiguration
                        .isOfflineModeTeslaFirmwareDownloadsEnabledFlag ==
                    1
                ? true
                : false)
            : (state as SystemConfigurationStateSettingsModified)
                .isOfflineModeTeslaFirmwareDownloadsEnabled;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SettingsTile(
        //     icon: Icons.wifi,
        //     title: 'Wi-Fi Hotspot',
        //     subtitle:
        //         'Disable only if you use and external router and you don\'t need the Tesla Android Wi-Fi network',
        //     trailing: Switch(
        //         value: isSoftApEnabled,
        //         onChanged: (value) {
        //           cubit.updateSoftApState(value);
        //         })),
        // divider,

        SettingsTile(
            icon: Icons.wifi_channel,
            title: 'Frequency band',
            trailing: DropdownButton<SoftApBandType>(
              value: selectedBand,
              icon: const Icon(Icons.arrow_drop_down_outlined),
              underline: Container(
                height: 2,
                color: Theme.of(context).primaryColor,
              ),
              onChanged: (SoftApBandType? value) {
                if (value != null) {
                  cubit.updateSoftApBand(value);
                }
              },
              items: SoftApBandType.values
                  .map<DropdownMenuItem<SoftApBandType>>(
                      (SoftApBandType value) {
                return DropdownMenuItem<SoftApBandType>(
                  value: value,
                  child: Text(value.name),
                );
              }).toList(),
            )),
        const Padding(
          padding: EdgeInsets.all(TADimens.PADDING_S_VALUE),
          child: Text(
              'The utilization of the 5 GHz operation mode enhances the performance of the Tesla Android system while effectively resolving Bluetooth-related challenges. This mode is anticipated to be designated as the default option in a future versions.\n\nConversely, when operating on the 2.4 GHz frequency, the allocation of resources between the hotspot and Bluetooth can lead to dropped frames, particularly when utilizing AD2P audio.'),
        ),
        divider,
        SettingsTile(
            icon: Icons.wifi_off,
            title: 'Offline mode',
            subtitle: 'Persistent Wi-Fi connection',
            trailing: Switch(
                value: isOfflineModeEnabled,
                onChanged: (value) {
                  cubit.updateOfflineModeState(value);
                })),
        divider,
        const Padding(
          padding: EdgeInsets.all(TADimens.PADDING_S_VALUE),
          child: Text(
              'To ensure continuous internet access, your Tesla vehicle relies on Wi-Fi networks that have an active internet connection. However, if you encounter a situation where Wi-Fi connectivity is unavailable, there is a solution called "offline mode" to address this limitation. In offline mode, certain features like Tesla Mobile App access and other car-side functionalities that rely on internet connectivity will be disabled. To overcome this limitation, you can establish internet access in your Tesla Android setup by using an LTE Modem or enabling tethering.'),
        ),
        divider,
        SettingsTile(
            icon: Icons.data_thresholding_sharp,
            title: 'Tesla Telemetry',
            subtitle: 'Reduces data usage, uncheck to disable',
            trailing: Switch(
                value: isOfflineModeTelemetryEnabled,
                onChanged: (value) {
                  cubit.updateOfflineModeTelemetryState(value);
                })),
        divider,
        SettingsTile(
            icon: Icons.update,
            title: 'Tesla Software Updates',
            subtitle: 'Reduces data usage, uncheck to disable',
            trailing: Switch(
                value: isOfflineModeTeslaFirmwareDownloadsEnabled,
                onChanged: (value) {
                  cubit.updateOfflineModeTeslaFirmwareDownloadsState(value);
                })),
        const Padding(
          padding: EdgeInsets.all(TADimens.PADDING_S_VALUE),
          child: Text(
              'Your car will still be able to check the availability of new updates. With this option enabled they won\'t immediately start downloading'),
        ),
      ],
    );
  }
}
