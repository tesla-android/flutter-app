import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:tesla_android/feature/connectivityCheck/cubit/connectivity_check_cubit.dart';
import 'package:tesla_android/feature/connectivityCheck/model/connectivity_state.dart';
import 'package:tesla_android/feature/display/widget/display_view.dart';
import 'package:tesla_android/feature/gps/cubit/gps_cubit.dart';
import 'package:tesla_android/feature/gps/cubit/gps_state.dart';
import 'package:tesla_android/feature/home/dino/chrome_dino_game.dart';
import 'package:tesla_android/feature/releaseNotes/widget/versionRibbon/version_ribbon.dart';
import 'package:tesla_android/feature/touchscreen/touchscreen_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  children: [
                    const Center(
                        child: DisplayView()),
                    const Positioned(right: 0, top: 0, child: VersionRibbon()),
                    Positioned(
                      left: 15,
                      top: 15,
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        child: BlocBuilder<GpsCubit, GpsState>(
                          builder: (context, state) {
                            if(state is GpsStateActive) {
                              return Column(
                                children: [
                                  Text("Latitude ${state.currentLocation.latitude}"),
                                  Text("Longitude ${state.currentLocation.longitude}"),
                                  Text("Approximated bearing ${state.currentLocation.approximatedBearing}"),
                                  Text("Approximated speed ${state.currentLocation.approximatedSpeed}"),
                                  Text("Update interval per second ${state.averageUpdateIntervalInSeconds}")
                                ],
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      ),
                    )
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
    return const ChromeDinoGame();
  }
}
