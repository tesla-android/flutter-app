import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/common/di/ta_locator.dart';
import 'package:tesla_android/common/navigation/ta_navigator.dart';
import 'package:tesla_android/common/navigation/ta_page.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:tesla_android/common/ui/constants/ta_timing.dart';
import 'package:tesla_android/feature/releaseNotes/widget/release_notes_loader.dart';
import 'package:tesla_android/feature/androidViewer/display/widget/display_view.dart';
import 'package:tesla_android/feature/androidViewer/touchscreen/cubit/touchscreen_cubit.dart';
import 'package:tesla_android/feature/androidViewer/touchscreen/touchscreen_view.dart';


class AndroidViewerPage extends StatelessWidget {
  final ReleaseNotesLoader _changelogLoader;

  AndroidViewerPage({Key? key})
      : _changelogLoader = getIt<ReleaseNotesLoader>(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    _changelogLoader.onPageLoad(context);
    final bloc = BlocProvider.of<TouchscreenCubit>(context);
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: BlocListener(
              bloc: bloc,
              listener: (BuildContext context, state) {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                if (state == false) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: const Text(
                          'Virtual touchscreen is not active. Wait for Android to boot up.'),
                      duration: TATiming.snackBarDuration,
                      action: SnackBarAction(
                        label: 'Dismiss',
                        onPressed: scaffoldMessenger.hideCurrentSnackBar,
                      ),
                    ),
                  );
                } else {
                  scaffoldMessenger.hideCurrentSnackBar();
                }
              },
              child: const DisplayView(
                  touchScreenView: TouchScreenView()),
            ),
          ),
          _versionBanner(context),
        ],
      ),
    );
  }

  Widget _versionBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => TANavigator.push(
        context: context,
        page: TAPage.releaseNotes,
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Banner(
          location: BannerLocation.topStart,
          message: '2022.18.1',
          child: Container(
            width: TADimens.versionBannerTouchAreaSize,
            height: TADimens.versionBannerTouchAreaSize,
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
