//ignore: avoid_web_libraries_in_flutter
import 'dart:convert';
import 'dart:js_interop';
import 'dart:ui' as ui;

import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/common/di/ta_locator.dart';
import 'package:tesla_android/common/utils/logger.dart';
import 'package:tesla_android/feature/display/cubit/display_cubit.dart';
import 'package:tesla_android/feature/display/cubit/display_state.dart';
import 'package:tesla_android/feature/display/model/remote_display_state.dart';
import 'package:tesla_android/feature/settings/bloc/audio_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/audio_configuration_state.dart';
import 'package:tesla_android/feature/settings/bloc/gps_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/gps_configuration_state.dart';
import 'package:web/helpers.dart';

class DisplayView extends StatefulWidget {
  final DisplayRendererType type;

  const DisplayView({Key? key, required this.type}) : super(key: key);

  @override
  State<DisplayView> createState() => _IframeViewState();
}

class _IframeViewState extends State<DisplayView> with Logger {
  final HTMLIFrameElement _iframeElement = HTMLIFrameElement();

  static const String _src = "/android.html";

  @override
  void initState() {
    super.initState();
    _iframeElement.src = _src;
    _iframeElement.style.border = 'none';

    //ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      _src,
      (int viewId) => _iframeElement,
    );
  }

  @override
  Widget build(BuildContext context) {
    final flavor = getIt<Flavor>();
    final displayState =
        BlocProvider.of<DisplayCubit>(context).state as DisplayStateNormal;
    return BlocBuilder<GPSConfigurationCubit, GPSConfigurationState>(
        bloc: BlocProvider.of<GPSConfigurationCubit>(context)
          ..fetchConfiguration(),
        builder: (context, gpsState) {
          return BlocBuilder<AudioConfigurationCubit, AudioConfigurationState>(
            bloc: BlocProvider.of<AudioConfigurationCubit>(context)
              ..fetchConfiguration(),
            builder: (context, audioState) {
              if (audioState is AudioConfigurationStateSettingsFetched &&
                  gpsState is GPSConfigurationStateLoaded) {
                return HtmlElementView(
                  viewType: _src,
                  onPlatformViewCreated: (_) {
                    final Map<String, dynamic> config = {
                      'audioWebsocketUrl': flavor.getString("audioWebSocket")!,
                      'displayWebsocketUrl':
                          flavor.getString("displayWebSocket")!,
                      'gpsWebsocketUrl': flavor.getString("gpsWebSocket")!,
                      'touchScreenWebsocketUrl':
                          flavor.getString("touchscreenWebSocket")!,
                      'isGPSEnabled': gpsState.isGPSEnabled.toString(),
                      'isAudioEnabled': audioState.isEnabled.toString(),
                      'audioVolume': (audioState.volume / 100).toString(),
                      'displayRenderer': widget.type.resourcePath(),
                      'displayBinaryType': widget.type.binaryType(),
                      "displayWidth":
                          displayState.adjustedSize.width.toString(),
                      "displayHeight":
                          displayState.adjustedSize.height.toString(),
                    };

                    window.addEventListener(
                        'message',
                        (JSAny event) {
                          if (event is MessageEvent &&
                              event.data == "iframeReady".toJS) {
                            window.postMessage(
                                jsonEncode(config).toJS, '*'.toJS);
                          }
                        }.toJS);
                  },
                );
              } else {
                return const SizedBox();
              }
            },
          );
        });
  }
}
