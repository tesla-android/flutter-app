import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:tesla_android/feature/gps/cubit/gps_cubit.dart';
import 'package:tesla_android/feature/gps/cubit/gps_state.dart';
import 'package:tesla_android/feature/settings/widget/settings_section.dart';
import 'package:tesla_android/feature/settings/widget/settings_tile.dart';

class GpsSettings extends SettingsSection {
  const GpsSettings({super.key})
      : super(
          name: "GPS",
          icon: Icons.gps_fixed,
        );

  @override
  Widget body(BuildContext context) {
    final cubit = BlocProvider.of<GpsCubit>(context);

    return BlocBuilder<GpsCubit, GpsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsTile(
                icon: Icons.location_pin,
                title: 'GPS',
                trailing: _stateTrailing(cubit, state)),
            const Padding(
              padding: EdgeInsets.all(TADimens.PADDING_S_VALUE),
              child: Text(
                  'Please be assured that your location data never leaves your car. The real-time location updates sent to your Tesla Android device are solely utilized to emulate a hardware GPS module in the Android OS.'),
            ),
          ],
        );
      },
    );
  }

  Widget _stateTrailing(GpsCubit cubit, GpsState state) {
    if (state is GpsStateActive) {
      return const Text("Active");
    } else if (state is GpsStatePermissionNotGranted || state is GpsStateManuallyDisabled) {
      return const Text("Permission not granted");
    } else if (state is GpsStateInitialisationError) {
      return const Text("Initialisation error");
    }
    return const SizedBox.shrink();
  }
}
