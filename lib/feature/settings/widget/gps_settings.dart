import 'package:flutter/material.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsTile(
            icon: Icons.location_pin, title: 'GPS', trailing: _stateTrailing()),
        const Padding(
          padding: EdgeInsets.all(TADimens.PADDING_S_VALUE),
          child: Text(
              'Please be assured that your location data never leaves your car. The real-time location updates sent to your Tesla Android device are solely utilized to emulate a hardware GPS module in the Android OS.'),
        ),
      ],
    );
  }

  Widget _stateTrailing() {
    // final WebLocation location = getIt<WebLocation>();
    // wind
    // return FutureBuilder(
    //     future: location.getPermissionStatus(),
    //     builder: (context, snapshot) {
    //       if (snapshot.hasData) {
    //         final data = snapshot.data;
    //         if (data ?? false) {
    //           return const Text("Active");
    //         } else {
    //           return const Text("Permission not granted");
    //         }
    //       } else {
    //         return const SizedBox();
    //       }
    //     });
    return SizedBox.shrink();
  }
}
