import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/common/di/ta_locator.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:tesla_android/feature/connectivityCheck/cubit/connectivity_check_cubit.dart';
import 'package:tesla_android/feature/connectivityCheck/model/connectivity_state.dart';
import 'package:tesla_android/feature/display/cubit/display_cubit.dart';
import 'package:tesla_android/feature/display/cubit/display_state.dart';
import 'package:tesla_android/feature/display/widget/display_view.dart';
import 'package:tesla_android/feature/home/widget/settings_button.dart';
import 'package:tesla_android/feature/home/widget/update_button.dart';
import 'package:tesla_android/feature/touchscreen/touchscreen_view.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final connectivityCheck = getIt<ConnectivityCheckCubit>();
    return BlocBuilder<ConnectivityCheckCubit, ConnectivityState>(
        bloc: connectivityCheck,
        builder: (context, state) {
          final isBackendAccessible =
              state == ConnectivityState.backendAccessible;
          if (!isBackendAccessible) {
            _onBackendConnectionLost(context);
          }
          return Scaffold(
              body: isBackendAccessible
                  ? Stack(
                      children: [
                        LayoutBuilder(builder: (context, constraints) {
                          BlocProvider.of<DisplayCubit>(context)
                              .onWindowSizeChanged(
                            Size(constraints.maxWidth, constraints.maxHeight),
                          );
                          return Center(
                            child: BlocBuilder<DisplayCubit, DisplayState>(
                                builder: (context, state) {
                              if (state is DisplayStateNormal) {
                                return AspectRatio(
                                  aspectRatio: state.adjustedSize.width /
                                      state.adjustedSize.height,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      DisplayView(type: state.rendererType),
                                      PointerInterceptor(
                                        child: TouchScreenView(
                                            displaySize: state.adjustedSize),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return const CircularProgressIndicator();
                              }
                            }),
                          );
                        }),
                        Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.8),
                                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(TADimens.ROUND_BORDER_RADIUS))
                              ),
                              child: const Row(
                                children: [
                                  UpdateButton(),
                                  SettingsButton(),
                                ],
                              ),
                            ))
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
