import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/common/di/ta_locator.dart';
import 'package:tesla_android/common/service/dialog_service.dart';
import 'package:tesla_android/common/ui/components/settings_dropdown.dart';
import 'package:tesla_android/common/ui/components/settings_switch.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:tesla_android/feature/settings/bloc/system_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/system_configuration_state.dart';
import 'package:tesla_android/feature/settings/model/softap_band_type.dart';
import 'package:tesla_android/feature/settings/view_model/hotspot_settings_view_model.dart';
import 'package:tesla_android/feature/settings/widget/settings_section.dart';
import 'package:tesla_android/feature/settings/widget/settings_tile.dart';

class HotspotSettings extends SettingsSection {
  const HotspotSettings({super.key}) : super(name: "Network", icon: Icons.wifi);

  @override
  Widget body(BuildContext context) {
    final viewModel = HotspotSettingsViewModel();

    return BlocListener<SystemConfigurationCubit, SystemConfigurationState>(
      listener: (context, state) {
        if (state is SystemConfigurationStateSettingsModified) {
          getIt<DialogService>().showMaterialBanner(
            context: context,
            banner: MaterialBanner(
              content: const Text(
                'System configuration has been updated. Would you like to apply it during the next system startup?',
              ),
              leading: const Icon(Icons.settings),
              actions: [
                IconButton(
                  onPressed: () {
                    context
                        .read<SystemConfigurationCubit>()
                        .applySystemConfiguration();
                    getIt<DialogService>().clearMaterialBanners(
                      context: context,
                    );
                  },
                  icon: const Icon(Icons.save),
                ),
              ],
            ),
          );
        }
      },
      child: BlocBuilder<SystemConfigurationCubit, SystemConfigurationState>(
        builder: (context, state) {
          if (viewModel.hasSettings(state)) {
            return _content(context, state, viewModel);
          } else if (viewModel.isFetchError(state)) {
            return const Text(
              "Failed to fetch Wi-Fi configuration from your device.",
            );
          } else if (viewModel.isSaveError(state)) {
            return const Text("Failed to save your new Wi-Fi configuration");
          } else {
            return const Padding(
              padding: EdgeInsets.all(TADimens.PADDING_L_VALUE),
              child: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }

  Widget _content(
    BuildContext context,
    SystemConfigurationState state,
    HotspotSettingsViewModel viewModel,
  ) {
    final cubit = BlocProvider.of<SystemConfigurationCubit>(context);
    final selectedBand = viewModel.getSoftApBand(state);
    final isOfflineModeEnabled = viewModel.getOfflineModeEnabled(state);
    final isOfflineModeTelemetryEnabled = viewModel
        .getOfflineModeTelemetryEnabled(state);
    final isOfflineModeTeslaFirmwareDownloadsEnabled = viewModel
        .getTeslaFirmwareDownloadsEnabled(state);

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
          dense: false,
          title: 'Frequency band and channel',
          trailing: selectedBand != null
              ? SettingsDropdown<SoftApBandType>(
                  value: selectedBand,
                  items: SoftApBandType.values,
                  onChanged: (value) {
                    if (value != null) {
                      cubit.updateSoftApBand(value);
                    }
                  },
                  itemLabel: (item) => item.name,
                  underlineColor: Theme.of(context).primaryColor,
                )
              : const SizedBox.shrink(),
        ),
        const Padding(
          padding: EdgeInsets.all(TADimens.PADDING_S_VALUE),
          child: Text(
            'The utilization of the 5 GHz operation mode enhances the performance of the Tesla Android system while effectively resolving Bluetooth-related challenges. If your car does not see the Tesla Android network please change the channel, supported channels differ by region. This mode is anticipated to be designated as the default option in a future versions.\n\nConversely, when operating on the 2.4 GHz frequency, the allocation of resources between the hotspot and Bluetooth can lead to dropped frames, particularly when utilizing AD2P audio.',
          ),
        ),
        divider,
        SettingsTile(
          icon: Icons.wifi_off,
          title: 'Offline mode',
          subtitle: 'Persistent Wi-Fi connection',
          trailing: SettingsSwitch(
            value: isOfflineModeEnabled ?? false,
            onChanged: (value) {
              cubit.updateOfflineModeState(value);
            },
          ),
        ),
        divider,
        const Padding(
          padding: EdgeInsets.all(TADimens.PADDING_S_VALUE),
          child: Text(
            'To ensure continuous internet access, your Tesla vehicle relies on Wi-Fi networks that have an active internet connection. However, if you encounter a situation where Wi-Fi connectivity is unavailable, there is a solution called "offline mode" to address this limitation. In offline mode, certain features like Tesla Mobile App access and other car-side functionalities that rely on internet connectivity will be disabled. To overcome this limitation, you can establish internet access in your Tesla Android setup by using an LTE Modem or enabling tethering.',
          ),
        ),
        divider,
        SettingsTile(
          icon: Icons.data_thresholding_sharp,
          title: 'Tesla Telemetry',
          subtitle: 'Reduces data usage, uncheck to disable',
          trailing: SettingsSwitch(
            value: isOfflineModeTelemetryEnabled ?? false,
            onChanged: (value) {
              cubit.updateOfflineModeTelemetryState(value);
            },
          ),
        ),
        divider,
        SettingsTile(
          icon: Icons.update,
          title: 'Tesla Software Updates',
          subtitle: 'Reduces data usage, uncheck to disable',
          trailing: SettingsSwitch(
            value: isOfflineModeTeslaFirmwareDownloadsEnabled ?? false,
            onChanged: (value) {
              cubit.updateOfflineModeTeslaFirmwareDownloadsState(value);
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(TADimens.PADDING_S_VALUE),
          child: Text(
            'Your car will still be able to check the availability of new updates. With this option enabled they won\'t immediately start downloading',
          ),
        ),
      ],
    );
  }
}
