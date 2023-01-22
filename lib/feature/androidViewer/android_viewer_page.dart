import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/common/di/ta_locator.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:tesla_android/feature/connectivityCheck/cubit/connectivity_check_cubit.dart';
import 'package:tesla_android/feature/connectivityCheck/model/connectivity_state.dart';
import 'package:tesla_android/feature/releaseNotes/widget/release_notes_loader.dart';
import 'package:tesla_android/feature/androidViewer/display/widget/display_view.dart';
import 'package:tesla_android/feature/androidViewer/touchscreen/cubit/touchscreen_cubit.dart';
import 'package:tesla_android/feature/androidViewer/touchscreen/touchscreen_view.dart';
import 'package:tesla_android/feature/releaseNotes/widget/versionRibbon/version_ribbon.dart';

class AndroidViewerPage extends StatelessWidget {
  final ReleaseNotesLoader _changelogLoader;

  AndroidViewerPage({Key? key})
      : _changelogLoader = getIt<ReleaseNotesLoader>(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    _changelogLoader.onPageLoad(context);
    final bloc = BlocProvider.of<TouchscreenCubit>(context);
    final cubit = BlocProvider.of<ConnectivityCheckCubit>(context);
    return BlocBuilder<ConnectivityCheckCubit, ConnectivityState>(
        builder: (context, state) {
      if (state == ConnectivityState.initial) {
        return Container();
      }
      final isBackendAccessible = state == ConnectivityState.backendAccessible;
      if (!isBackendAccessible) {
        _onBackendConnectionLost(context);
      }
      return Scaffold(
          body: isBackendAccessible
              ? Stack(
                  children: const [
                    Center(
                        child: DisplayView(touchScreenView: TouchScreenView())),
                    VersionRibbon()
                  ],
                )
              : _backendConnectionLostWidget());
    });
  }

  void _onBackendConnectionLost(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showMaterialBanner(
        const MaterialBanner(
          content: Text(
              'Connection with Tesla Android services lost. The app will restart when it comes back'),
          leading: Icon(Icons.wifi_off),
          actions: [SizedBox.shrink()],
        ),
      );
    });
  }

  Widget _backendConnectionLostWidget() {
    return const Center(
      child: Icon(
        Icons.error_outline,
        color: Colors.red,
        size: TADimens.backendErrorIconSize,
      ),
    );
  }
}
