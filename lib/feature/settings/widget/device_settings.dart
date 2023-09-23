import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:tesla_android/feature/settings/model/device_info.dart';
import 'package:tesla_android/feature/settings/bloc/device_info_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/device_info_state.dart';
import 'package:tesla_android/feature/settings/widget/settings_section.dart';
import 'package:tesla_android/feature/settings/widget/settings_tile.dart';

class DeviceSettings extends SettingsSection {
  const DeviceSettings({super.key})
      : super(
          name: "Device",
          icon: Icons.developer_board,
        );

  @override
  Widget body(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.bodyLarge;
    return BlocBuilder<DeviceInfoCubit, DeviceInfoState>(
        builder: (context, state) {
      if (state is DeviceInfoStateInitial || state is DeviceInfoStateLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is DeviceInfoStateLoaded) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsTile(
                icon: Icons.device_thermostat,
                title: 'CPU Temperature',
                trailing: Text("${state.deviceInfo.cpuTemperature}°C",
                    style: textTheme)),
            const Padding(
              padding: EdgeInsets.all(TADimens.PADDING_S_VALUE),
              child: Text(
                  'CPU temperature should not exceed 80°C. Make sure the device is actively cooled and proper ventilation is provided.'),
            ),
            divider,
            SettingsTile(
                dense: false,
                icon: Icons.perm_device_info,
                title: 'Model',
                trailing: Text(
                  state.deviceInfo.deviceName,
                  style: textTheme,
                )),
            SettingsTile(
                dense: false,
                icon: Icons.developer_board_rounded,
                title: 'Serial Number',
                trailing: Text(
                  state.deviceInfo.serialNumber,
                  style: textTheme,
                )),
            SettingsTile(
                dense: false,
                icon: Icons.broadcast_on_home_sharp,
                title: 'CarPlay Module',
                trailing: Text(
                  state.deviceInfo.isCarPlayDetected == 1 ? "Connected" : "Not connected",
                  style: textTheme,
                )),
            SettingsTile(
                dense: false,
                icon: Icons.cell_tower,
                title: 'LTE Modem',
                trailing: Text(
                  state.deviceInfo.isModemDetected == 1 ? "Detected" : "Not detected",
                  style: textTheme,
                )),
            const Padding(
              padding: EdgeInsets.all(TADimens.PADDING_S_VALUE),
              child: Text(
                  'The LTE modem is considered detected when it is properly connected, and the gateway is reachable by Android. IP address 192.168.(0/8).1 is used for this check (Default for E3372 and Alcatel modems).'),
            ),
          ],
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
