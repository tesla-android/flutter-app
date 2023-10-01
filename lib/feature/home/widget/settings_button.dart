import 'package:flutter/material.dart';
import 'package:tesla_android/common/navigation/ta_navigator.dart';
import 'package:tesla_android/common/navigation/ta_page.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:tesla_android/common/utils/logger.dart';

class SettingsButton extends StatelessWidget with Logger {
  const SettingsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Colors.white,
      onPressed: () {
        dispatchAnalyticsEvent(
          eventName: "settings_button_tapped",
          props: {},
        );
        TANavigator.pushReplacement(
          context: context,
          page: TAPage.about,
        );
      },
      icon: const Icon(
        Icons.settings,
        size: TADimens.statusBarIconSize,
      ),
    );
  }
}
