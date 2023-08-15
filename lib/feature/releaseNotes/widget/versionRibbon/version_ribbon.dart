import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tesla_android/common/di/ta_locator.dart';
import 'package:tesla_android/common/navigation/ta_navigator.dart';
import 'package:tesla_android/common/navigation/ta_page.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:tesla_android/common/utils/logger.dart';

class VersionRibbon extends StatelessWidget with Logger {
  const VersionRibbon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GestureDetector(
              onTap: () {
                dispatchAnalyticsEvent(
                  eventName: "version_ribbon_tapped",
                  props: {},
                );
                TANavigator.pushReplacement(
                  context: context,
                  page: TAPage.about,
                );
              },
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Banner(
                  color: getIt<Flavor>().color ?? Colors.red,
                  location: BannerLocation.topEnd,
                  message: snapshot.data?.version ?? "",
                  child: Container(
                    width: TADimens.versionBannerTouchAreaSize,
                    height: TADimens.versionBannerTouchAreaSize,
                    color: Colors.transparent,
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        });
  }
}
