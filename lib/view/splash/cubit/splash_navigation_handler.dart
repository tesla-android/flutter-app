import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesla_android/common/navigation/ta_navigator.dart';
import 'package:tesla_android/common/navigation/ta_page.dart';
import 'package:tesla_android/common/ui/constants/ta_timing.dart';

@injectable
class SplashNavigationHandler {
  final SharedPreferences _sharedPreferences;

  static const _sharedPreferencesReleaseNotesKey =
      "SplashCubit_showReleaseNotes";

  SplashNavigationHandler(this._sharedPreferences) : super();

  void onPageLoad(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (_sharedPreferences.getBool(_sharedPreferencesReleaseNotesKey) ??
          true) {
        _sharedPreferences.setBool(_sharedPreferencesReleaseNotesKey, false);
        await TANavigator.push(context: context, page: TAPage.releaseNotes);
      }
      await Future.delayed(TATiming.splashPageTransitionDuration,
          () => TANavigator.push(context: context, page: TAPage.androidViewer));
    });
  }
}
