import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/di/ta_locator.dart';
import 'package:tesla_android/common/navigation/ta_page.dart';
import 'package:tesla_android/feature/about/about_page.dart';
import 'package:tesla_android/feature/display/cubit/display_cubit.dart';
import 'package:tesla_android/feature/donations/widget/donation_page.dart';
import 'package:tesla_android/feature/home/cubit/ota_update_cubit.dart';
import 'package:tesla_android/feature/home/home_page.dart';
import 'package:tesla_android/feature/releaseNotes/cubit/release_notes_cubit.dart';
import 'package:tesla_android/feature/releaseNotes/widget/release_notes_page.dart';
import 'package:tesla_android/feature/settings/bloc/audio_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/device_info_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/display_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/system_configuration_cubit.dart';
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
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => getIt<AudioConfigurationCubit>(),
              ),
              BlocProvider(
                create: (_) => getIt<TouchscreenCubit>(),
              ),
              BlocProvider(
                create: (_) => getIt<DisplayCubit>(),
              ),
              BlocProvider(
                create: (_) => getIt<OTAUpdateCubit>()..checkForUpdates(),
              ),
            ],
            child: const HomePage(),
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
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    getIt<AudioConfigurationCubit>()..fetchConfiguration(),
              ),
              BlocProvider(
                create: (_) =>
                    getIt<DisplayConfigurationCubit>()..fetchConfiguration(),
              ),
              BlocProvider(
                create: (_) =>
                    getIt<SystemConfigurationCubit>()..fetchConfiguration(),
              ),
              BlocProvider(
                create: (_) => getIt<DeviceInfoCubit>()..fetchConfiguration(),
              ),
            ],
            child: const SettingsPage(),
          );
        case TAPage.empty:
        default:
          return const SizedBox();
      }
    };
  }
}
