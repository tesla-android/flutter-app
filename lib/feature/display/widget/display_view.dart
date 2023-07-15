//ignore: avoid_web_libraries_in_flutter
import 'dart:convert';
import 'dart:html';
import 'dart:ui' as ui;

import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/common/di/ta_locator.dart';
import 'package:tesla_android/feature/display/cubit/display_cubit.dart';
import 'package:tesla_android/feature/display/cubit/display_state.dart';
import 'package:tesla_android/feature/display/model/remote_display_state.dart';
import 'package:tesla_android/feature/settings/bloc/audio_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/audio_configuration_state.dart';
import 'package:uuid/uuid.dart';

class DisplayView extends StatefulWidget {
  final DisplayRendererType type;

  const DisplayView({Key? key, required this.type}) : super(key: key);

  @override
  State<DisplayView> createState() => _IframeViewState();
}

class _IframeViewState extends State<DisplayView> {
  final IFrameElement _iframeElement = IFrameElement();

  late String _uuid;

  @override
  void initState() {
    super.initState();
    _uuid = const Uuid().v1();
    _iframeElement.src = "/android.html";
    _iframeElement.style.border = 'none';

    //ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      _uuid,
      (int viewId) => _iframeElement,
    );
  }

  @override
  Widget build(BuildContext context) {
    final flavor = getIt<Flavor>();
    return BlocBuilder<AudioConfigurationCubit, AudioConfigurationState>(
      bloc: BlocProvider.of<AudioConfigurationCubit>(context)
        ..fetchConfiguration(),
      builder: (context, state) {
        if (state is AudioConfigurationStateSettingsFetched) {
          return HtmlElementView(
            viewType: _uuid,
            onPlatformViewCreated: (_) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                Future.delayed(const Duration(milliseconds: 100), () {
                  final Map<String, dynamic> config = {
                    'audioWebsocketUrl': flavor.getString("audioWebSocket"),
                    'displayWebsocketUrl': flavor.getString("displayWebSocket"),
                    'gpsWebsocketUrl': flavor.getString("gpsWebSocket"),
                    'touchScreenWebsocketUrl':
                        flavor.getString("touchscreenWebSocket"),
                    'isAudioEnabled': true,
                    'audioVolume': 1.0,
                    'displayRenderer': widget.type.resourcePath(),
                    'displayBinaryType': widget.type.binaryType(),
                  };

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
