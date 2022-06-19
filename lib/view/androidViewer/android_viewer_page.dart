import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/common/navigation/ta_navigator.dart';
import 'package:tesla_android/common/navigation/ta_page.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:tesla_android/common/ui/constants/ta_timing.dart';
import 'package:tesla_android/view/androidViewer/displayViewer/display_viewer.dart';
import 'package:tesla_android/view/androidViewer/virtualTouchscreen/cubit/virtual_touchscreen_cubit.dart';

import 'virtualTouchscreen/virtual_touchscreen_view.dart';

class AndroidViewerPage extends StatelessWidget {
  const AndroidViewerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<VirtualTouchscreenCubit>(context);
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
              child:
                  const DisplayViewer(touchScreenView: VirtualTouchScreenView()),
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
