import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/di/ta_locator.dart';
import 'package:tesla_android/common/navigation/ta_page.dart';
import 'package:tesla_android/feature/connectivityCheck/cubit/connectivity_check_cubit.dart';
import 'package:tesla_android/feature/donations/widget/donation_dialog.dart';
import 'package:tesla_android/feature/home/android_viewer_page.dart';
import 'package:tesla_android/feature/releaseNotes/cubit/release_notes_cubit.dart';
import 'package:tesla_android/feature/releaseNotes/widget/release_notes_page.dart';
import 'package:tesla_android/feature/touchscreen/cubit/touchscreen_cubit.dart';

@injectable
class TAPageFactory {
  String initialRoute = TAPage.home.route;

  Map<String, Widget Function(BuildContext context)> getRoutes() {
    return {
      for (var e in TAPage.availablePages) e.route: buildPage(e),
    };
  }

  Widget Function(BuildContext context) buildPage(TAPage page) {
    return (context) {
      switch (page) {
        case TAPage.home:
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: getIt<ConnectivityCheckCubit>(),
              ),
              BlocProvider(
                create: (_) => getIt<TouchscreenCubit>(),
              ),
            ],
            child: HomePage(),
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
