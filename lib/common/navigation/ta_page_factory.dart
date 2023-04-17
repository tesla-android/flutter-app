import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/di/ta_locator.dart';
import 'package:tesla_android/common/navigation/ta_page.dart';
import 'package:tesla_android/feature/about/about_page.dart';
import 'package:tesla_android/feature/audio/cubit/audio_cubit.dart';
import 'package:tesla_android/feature/connectivityCheck/cubit/connectivity_check_cubit.dart';
import 'package:tesla_android/feature/donations/widget/donation_page.dart';
import 'package:tesla_android/feature/gps/cubit/gps_cubit.dart';
import 'package:tesla_android/feature/home/home_page.dart';
import 'package:tesla_android/feature/releaseNotes/cubit/release_notes_cubit.dart';
import 'package:tesla_android/feature/releaseNotes/widget/release_notes_page.dart';
import 'package:tesla_android/feature/settings/widget/settings_page.dart';
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
          return _injectAndroidViewerDependencies(
            child: HomePage(),
          );
        case TAPage.releaseNotes:
          return BlocProvider(
            create: (_) => getIt<ReleaseNotesCubit>(),
            child: const ReleaseNotesPage(),
          );
        case TAPage.about:
          return const AboutPage();
        case TAPage.donations:
          return const DonationPage();
        case TAPage.settings:
          return _injectAndroidViewerDependencies(
            child: const SettingsPage(),
          );
        case TAPage.empty:
        default:
          return const SizedBox();
      }
    };
  }

  Widget _injectAndroidViewerDependencies({required Widget child}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: getIt<ConnectivityCheckCubit>(),
        ),
        BlocProvider.value(
          value: getIt<TouchscreenCubit>(),
        ),
        BlocProvider.value(
          value: getIt<AudioCubit>(),
        ),
        BlocProvider.value(
          value: getIt<GpsCubit>(),
        ),
      ],
      child: child,
    );
  }
}
