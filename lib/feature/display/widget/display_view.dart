//ignore: avoid_web_libraries_in_flutter
import 'dart:convert';
import 'dart:html';
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

class DisplayView extends StatefulWidget {
  final DisplayRendererType type;

  const DisplayView({Key? key, required this.type}) : super(key: key);

  @override
  State<DisplayView> createState() => _IframeViewState();
}

class _IframeViewState extends State<DisplayView> with Logger {
  final IFrameElement _iframeElement = IFrameElement();

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
    return BlocBuilder<AudioConfigurationCubit, AudioConfigurationState>(
      bloc: BlocProvider.of<AudioConfigurationCubit>(context)
        ..fetchConfiguration(),
      builder: (context, state) {
        if (state is AudioConfigurationStateSettingsFetched) {
          return HtmlElementView(
            viewType: _src,
            onPlatformViewCreated: (_) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                Future.delayed(const Duration(milliseconds: 350), () {
                  final Map<String, dynamic> config = {
                    'audioWebsocketUrl': flavor.getString("audioWebSocket"),
                    'displayWebsocketUrl': flavor.getString("displayWebSocket"),
                    'gpsWebsocketUrl': flavor.getString("gpsWebSocket"),
                    'touchScreenWebsocketUrl':
                        flavor.getString("touchscreenWebSocket"),
                    'isAudioEnabled': state.isEnabled,
                    'audioVolume': state.volume / 100,
                    'displayRenderer': widget.type.resourcePath(),
                    'displayBinaryType': widget.type.binaryType(),
                    "displayWidth": displayState.adjustedSize.width,
                    "displayHeight": displayState.adjustedSize.height,
                  };

                  dispatchAnalyticsEvent(
                    eventName: "display_started",
                    props: config,
                  );

                  window.postMessage(jsonEncode(config), '*');
                });
              });
            },
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
