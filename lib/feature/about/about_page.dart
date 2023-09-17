import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tesla_android/common/navigation/ta_page.dart';
import 'package:tesla_android/common/ui/components/ta_app_bar.dart';
import 'package:tesla_android/common/ui/components/ta_bottom_navigation_bar.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TaAppBar(
          title: TAPage.about.title,
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: TADimens.splashPageLogoHeight,
                height: TADimens.splashPageLogoHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(TADimens.splashPageRadius),
                  child: Image.asset("images/png/tesla-android-logo.png"),
                ),
              ),
              const SizedBox(
                height: TADimens.PADDING_VALUE,
              ),
              const Text("Version", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(
                height: TADimens.PADDING_S_VALUE,
              ),
              FutureBuilder<PackageInfo>(future: PackageInfo.fromPlatform(), builder: (_, snapshot){
                return Text(snapshot.data?.version ?? '');
              }),
              const SizedBox(
                height: TADimens.PADDING_XXL_VALUE,
              ),
              const Text("Tesla Android Compute Module 4 bundles are now available.\nGet yours today on https://teslaandroid.com", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
            ],
          ),
        ),
        bottomNavigationBar: const TaBottomNavigationBar(currentIndex: 1));
  }
}
