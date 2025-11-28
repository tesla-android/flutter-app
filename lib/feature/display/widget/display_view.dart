import 'dart:convert';
import 'dart:js_interop';

import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/common/di/ta_locator.dart';
import 'package:tesla_android/feature/display/cubit/display_cubit.dart';
import 'package:tesla_android/feature/gps/cubit/gps_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/audio_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/audio_configuration_state.dart';
import 'package:web/web.dart' as web;
import 'dart:ui' as ui hide window;

class DisplayView extends StatelessWidget {
  const DisplayView({super.key});

  @override
  Widget build(BuildContext context) {
    final flavor = getIt<Flavor>();
    context.read<GpsCubit>().fetchConfiguration();

    return BlocBuilder<AudioConfigurationCubit, AudioConfigurationState>(
      builder: (context, audioState) {
        if (audioState is AudioConfigurationStateInitial) {
          final audioCubit = context.read<AudioConfigurationCubit>();
          audioCubit.fetchConfiguration();
        }
        if (audioState is AudioConfigurationStateSettingsFetched) {
          final config = <String, dynamic>{
            'audioWebsocketUrl': flavor.getString("audioWebSocket") ?? "",
            'isAudioEnabled': (audioState.isEnabled).toString(),
            'audioVolume': ((audioState.volume / 100)).toStringAsFixed(2),
          };
          final cfgJson = jsonEncode(config).toJS;
          web.window.postMessage(cfgJson, '*'.toJS);
        }
        return StreamBuilder<ui.Image>(
          stream: context.read<DisplayCubit>().frameStream,
          builder: (context, snapshot) {
            final img = snapshot.data;
            if (img == null) return const SizedBox.shrink();

            return RawImage(image: img, fit: BoxFit.contain);
          },
        );
      },
    );
    ;
  }
}

/*
class _IframeViewState extends State<DisplayView>
    with Logger {
  static const String _src = "/android.html";

  final web.HTMLIFrameElement _iframeElement = web.HTMLIFrameElement();

  web.EventListener? _onMessageJs;

  @override
  void initState() {
    super.initState();

    // Prepare the iframe element once.
    _iframeElement.src = _src;
    _iframeElement.style.border = 'none';

    ui.platformViewRegistry.registerViewFactory(
      _src,
          (int viewId) => _iframeElement,
    );
  }

  @override
  void dispose() {
    if (_onMessageJs != null) {
      web.window.removeEventListener('message', _onMessageJs!);
      _onMessageJs = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(
      viewType: _src,
      onPlatformViewCreated: (_) {
        // Wire a one-time message listener on window to catch "iframeReady"
        // from android.html and then send the config payload.
        _onMessageJs = (web.Event e) {
          if (e is web.MessageEvent) {
            final data = e.data;
            // android.html posts "iframeReady" to parent on load
            if (data is String && data == "iframeReady") {
              _sendConfigToIframe();
            }
          }
        }.toJS;

        web.window.addEventListener('message', _onMessageJs);
      },
    );
  }

  void _sendConfigToIframe() async {
    final flavor = getIt<Flavor>();

    final displayCubit = context.read<DisplayCubit>();
    final gpsCubit = context.read<GPSConfigurationCubit>();
    final audioCubit = context.read<AudioConfigurationCubit>();

    await gpsCubit.fetchConfiguration();
    await audioCubit.fetchConfiguration();

    final displayState = displayCubit.state;
    final gpsState = gpsCubit.state;
    final audioState = audioCubit.state;

    if (displayState is! DisplayStateNormal) {
      // If display state isn't ready yet, try again on next frame.
      WidgetsBinding.instance.addPostFrameCallback((_) => _sendConfigToIframe());
      return;
    }

    // Build config. (Audio values are harmless here; audio is handled in index.html.)
    final config = <String, dynamic>{
      'audioWebsocketUrl': flavor.getString("audioWebSocket") ?? "",
      'displayWebsocketUrl': flavor.getString("displayWebSocket") ?? "",
      'gpsWebsocketUrl': flavor.getString("gpsWebSocket") ?? "",
      'touchScreenWebsocketUrl': flavor.getString("touchscreenWebSocket") ?? "",
      'isGPSEnabled': (gpsState is GPSConfigurationStateLoaded
          ? gpsState.isGPSEnabled
          : false)
          .toString(),
      'isAudioEnabled': (audioState is AudioConfigurationStateSettingsFetched
          ? audioState.isEnabled
          : true)
          .toString(),
      'audioVolume': (audioState is AudioConfigurationStateSettingsFetched
          ? (audioState.volume / 100)
          : 1.0)
          .toStringAsFixed(2),
      'displayRenderer': widget.type.resourcePath(),
      'displayBinaryType': widget.type.binaryType(),
      'displayWidth': displayState.adjustedSize.width.toString(),
      'displayHeight': displayState.adjustedSize.height.toString(),
    };

    final cfgJson = jsonEncode(config).toJS;
    web.window.postMessage(cfgJson, '*'.toJS);
    _iframeElement.contentWindow?.postMessage(cfgJson, '*'.toJS);
  }
}*/
