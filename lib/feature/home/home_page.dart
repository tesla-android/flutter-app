import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/common/di/ta_locator.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:tesla_android/feature/connectivityCheck/cubit/connectivity_check_cubit.dart';
import 'package:tesla_android/feature/connectivityCheck/model/connectivity_state.dart';
import 'package:tesla_android/feature/display/cubit/display_cubit.dart';
import 'package:tesla_android/feature/display/cubit/display_state.dart';
import 'package:tesla_android/feature/display/widget/display_view.dart';
import 'package:tesla_android/feature/home/widget/audio_button.dart';
import 'package:tesla_android/feature/home/widget/display_size_watcher.dart';
import 'package:tesla_android/feature/home/widget/settings_button.dart';
import 'package:tesla_android/feature/home/widget/update_button.dart';
import 'package:tesla_android/feature/touchscreen/touchscreen_view.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final connectivityCheck = getIt<ConnectivityCheckCubit>();
    return BlocListener<DisplayCubit, DisplayState>(
      listener: (BuildContext context, DisplayState state) {
        if (state is DisplayStateDisplayTypeSelectionTriggered) {
          _presentDisplayTypeSelectionDialog(context);
        }
      },
      child: BlocBuilder<ConnectivityCheckCubit, ConnectivityState>(
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
                      DisplaySizeWatcher(
                        builder: (size) {
                          return Center(
                            child: BlocBuilder<DisplayCubit, DisplayState>(
                              builder: (context, state) {
                                if (state is DisplayStateNormal) {
                                  return AspectRatio(
                                    aspectRatio:
                                        state.adjustedSize.width /
                                        state.adjustedSize.height,
                                    child: TouchScreenView(
                                      displaySize: state.adjustedSize,
                                      child: DisplayView(
                                      ),
                                    ),
                                  );
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              },
                            ),
                          );
                        },
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.8),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(
                                TADimens.ROUND_BORDER_RADIUS,
                              ),
                            ),
                          ),
                          child: const Row(
                            children: [
                              AudioButton(),
                              UpdateButton(),
                              SettingsButton(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : _backendConnectionLostWidget(),
          );
        },
      ),
    );
  }

  void _onBackendConnectionLost(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showMaterialBanner(
        const MaterialBanner(
          content: Text(
            'Connection with Tesla Android services lost. The app will restart when it comes back',
          ),
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

  void _presentDisplayTypeSelectionDialog(BuildContext presentingContext) {
    showDialog<void>(
      context: presentingContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Display Type'),
          content: const Text(
            'Are you using a rear display?\n'
            'Certain features won\'t function on the main screen in motion.\n'
            'You can change the selection in Tesla Android Settings.',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('MAIN DISPLAY'),
              onPressed: () => _onDisplayTypeSelectionFinished(
                context: context,
                presentingContext: presentingContext,
                isPrimaryDisplay: true,
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('REAR DISPLAY'),
              onPressed: () => _onDisplayTypeSelectionFinished(
                context: context,
                presentingContext: presentingContext,
                isPrimaryDisplay: false,
              ),
            ),
          ],
        );
      },
    );
  }

  void _onDisplayTypeSelectionFinished({
    required BuildContext context,
    required BuildContext presentingContext,
    required bool isPrimaryDisplay,
  }) {
    BlocProvider.of<DisplayCubit>(
      presentingContext,
    ).onDisplayTypeSelectionFinished(isPrimaryDisplay: isPrimaryDisplay);
    Navigator.of(context).pop();
  }
}
