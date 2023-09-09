import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:tesla_android/feature/connectivityCheck/model/health_state.dart';
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
                trailing: Text("${state.healthState.cpuTemperature}°C",
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
                  state.healthState.deviceName,
                  style: textTheme,
                )),
            SettingsTile(
                dense: false,
                icon: Icons.developer_board_rounded,
                title: 'Serial Number',
                trailing: Text(
                  state.healthState.serialNumber,
                  style: textTheme,
                )),
          ],
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
