import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:tesla_android/feature/settings/bloc/gps_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/gps_configuration_state.dart';
import 'package:tesla_android/feature/settings/widget/settings_section.dart';
import 'package:tesla_android/feature/settings/widget/settings_tile.dart';

class GpsSettings extends SettingsSection {
  const GpsSettings({super.key}) : super(name: "GPS", icon: Icons.gps_fixed);

  @override
  Widget body(BuildContext context) {
    return BlocBuilder<GPSConfigurationCubit, GPSConfigurationState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsTile(
              icon: Icons.gps_fixed,
              title: 'GPS',
              subtitle: 'Disable if you don\'t use Android navigation apps',
              trailing: _gpsStateSwitch(context, state),
            ),
            const Padding(
              padding: EdgeInsets.all(TADimens.PADDING_S_VALUE),
              child: Text(
                'NOTE: GPS via Browser can cause crashes on Tesla Software 2024.14 or newer, the integration is disabled by default until this issue is solved by Tesla. Please be assured that your location data never leaves your car. The real-time location updates sent to your Tesla Android device are solely utilized to emulate a hardware GPS module in the Android OS.',
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _gpsStateSwitch(BuildContext context, GPSConfigurationState state) {
    final cubit = BlocProvider.of<GPSConfigurationCubit>(context);
    if (state is GPSConfigurationStateLoaded) {
      return Switch(
        value: state.isGPSEnabled,
        onChanged: (value) {
          cubit.setState(value);
        },
      );
    } else if (state is GPSConfigurationStateUpdateInProgress ||
        state is GPSConfigurationStateLoading) {
      return const CircularProgressIndicator();
    } else if (state is GPSConfigurationStateError) {
      return const Text("Service error");
    }
    return const SizedBox.shrink();
  }
}
