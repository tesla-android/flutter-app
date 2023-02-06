import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tesla_android/common/navigation/ta_navigator.dart';
import 'package:tesla_android/common/navigation/ta_page.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';

class VersionRibbon extends StatelessWidget {
  const VersionRibbon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GestureDetector(
              onTap: () => TANavigator.push(
                context: context,
                page: TAPage.releaseNotes,
              ),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Banner(
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
