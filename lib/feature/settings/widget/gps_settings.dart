import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:tesla_android/feature/settings/widget/settings_section.dart';
import 'package:tesla_android/feature/settings/widget/settings_tile.dart';
import 'package:web/web.dart' as web;

class GpsSettings extends SettingsSection {
  const GpsSettings({super.key})
      : super(
          name: "GPS",
          icon: Icons.gps_fixed,
        );

  @override
  Widget body(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsTile(
            icon: Icons.location_pin, title: 'GPS', trailing: GPSStateWidget()),
        Padding(
          padding: EdgeInsets.all(TADimens.PADDING_S_VALUE),
          child: Text(
              'Please be assured that your location data never leaves your car. The real-time location updates sent to your Tesla Android device are solely utilized to emulate a hardware GPS module in the Android OS.'),
        ),
      ],
    );
  }
}


class GPSStateWidget extends StatefulWidget {
  const GPSStateWidget({super.key});

  @override
  State<StatefulWidget> createState() => GPSStateWidgetState();

}

class GPSStateWidgetState extends State<GPSStateWidget> {
  bool isGPSActive = false;

  @override
  Widget build(BuildContext context) {
    if (isGPSActive) {
      return const Text("Active");
    } else {
      return const Text("Permission not granted");
    }
  }

  void checkGPSState() {
    web.window.navigator.geolocation.getCurrentPosition(() {
      setState(() {
        isGPSActive = true;
      });
    }.toJS, () {
      setState(() {
        isGPSActive = false;
      });
    }.toJS);
  }
}


