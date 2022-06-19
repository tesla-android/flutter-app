import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/di/ta_locator.dart';
import 'package:tesla_android/common/navigation/ta_page.dart';
import 'package:tesla_android/view/androidViewer/android_viewer_page.dart';
import 'package:tesla_android/view/androidViewer/virtualTouchscreen/cubit/virtual_touchscreen_cubit.dart';
import 'package:tesla_android/view/donationDialog/widget/donation_dialog.dart';
import 'package:tesla_android/view/releaseNotes/widget/release_notes_page.dart';
import 'package:tesla_android/view/splash/widget/splash_page.dart';

@injectable
class TAPageFactory {
  String initialRoute = TAPage.splash.route;

  Map<String, Widget Function(BuildContext context)> getRoutes() {
    return {
      for (var e in TAPage.availablePages) e.route: buildPage(e),
    };
  }

  Widget Function(BuildContext context) buildPage(TAPage page) {
    return (context) {
      switch (page) {
        case TAPage.splash:
          return const SplashPage();
        case TAPage.androidViewer:
          return BlocProvider.value(
            value: getIt<VirtualTouchscreenCubit>(),
            child: const AndroidViewerPage(),
          );
        case TAPage.releaseNotes:
          return const ReleaseNotesPage();
        case TAPage.donationDialog:
          return const DonationDialog();
        case TAPage.empty:
        default:
          return const SizedBox();
      }
    };
  }
}
