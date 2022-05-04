import 'package:flutter/material.dart';
import 'package:tesla_android/common/di/ta_locator.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:tesla_android/view/splash/cubit/splash_navigation_handler.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _hideSnackBars(context);
    _delegateNavigation(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(TADimens.splashPageRadius),
              child: Image.asset(
                'images/png/tesla-android-logo.png',
                height: TADimens.splashPageLogoHeight,
              ),
            ),
            const CircularProgressIndicator()
          ],
        ),
      ),
    );
  }

  void _hideSnackBars(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  void _delegateNavigation(BuildContext context) {
    getIt<SplashNavigationHandler>().onPageLoad(context);
  }
}
