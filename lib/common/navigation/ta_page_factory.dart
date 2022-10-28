import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/di/ta_locator.dart';
import 'package:tesla_android/common/navigation/ta_page.dart';
import 'package:tesla_android/feature/androidViewer/android_viewer_page.dart';
import 'package:tesla_android/feature/androidViewer/display/cubit/display_cubit.dart';
import 'package:tesla_android/feature/androidViewer/touchscreen/cubit/touchscreen_cubit.dart';
import 'package:tesla_android/feature/donations/widget/donation_dialog.dart';
import 'package:tesla_android/feature/releaseNotes/cubit/release_notes_cubit.dart';
import 'package:tesla_android/feature/releaseNotes/widget/release_notes_page.dart';

@injectable
class TAPageFactory {
  String initialRoute = TAPage.androidViewer.route;

  Map<String, Widget Function(BuildContext context)> getRoutes() {
    return {
      for (var e in TAPage.availablePages) e.route: buildPage(e),
    };
  }

  Widget Function(BuildContext context) buildPage(TAPage page) {
    return (context) {
      switch (page) {
        case TAPage.androidViewer:
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => getIt<TouchscreenCubit>(),
              ),
              BlocProvider(
                create: (_) => getIt<DisplayCubit>(),
              ),
            ],
            child: AndroidViewerPage(),
          );
        case TAPage.releaseNotes:
          return BlocProvider(
            create: (_) => getIt<ReleaseNotesCubit>(),
            child: const ReleaseNotesPage(),
          );
        case TAPage.donationDialog:
          return const DonationDialog();
        case TAPage.empty:
        default:
          return const SizedBox();
      }
    };
  }
}
