import 'dart:convert';
import 'dart:js_interop';
import 'dart:ui_web' as ui;

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
import 'package:web/web.dart' as web;

// Guard so we register the factory only once for this viewType.
bool _displayViewFactoryRegistered = false;

class DisplayView extends StatefulWidget {
  final DisplayRendererType type;

  const DisplayView({super.key, required this.type});

  @override
  State<DisplayView> createState() => _IframeViewState();
}

class _IframeViewState extends State<DisplayView>
    with Logger, AutomaticKeepAliveClientMixin<DisplayView> {
  static const String _src = "/android.html";

  // The underlying DOM element and a cached platform view widget.
  final web.HTMLIFrameElement _iframeElement = web.HTMLIFrameElement();
  late final Widget _cachedView;

  // Keep a reference to the JS listener so we can remove it in dispose.
  web.EventListener? _onMessageJs;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    // Prepare the iframe element once.
    _iframeElement.src = _src;
    _iframeElement.style.border = 'none';

    // Register the view factory only once for this viewType.
    if (!_displayViewFactoryRegistered) {
      ui.platformViewRegistry.registerViewFactory(
        _src,
            (int viewId) => _iframeElement,
      );
      _displayViewFactoryRegistered = true;
    }

    // Cache the HtmlElementView so it won’t be recreated on rebuilds.
    _cachedView = HtmlElementView(
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
    super.build(context); // for AutomaticKeepAliveClientMixin
    return _cachedView;
  }

  void _sendConfigToIframe() {
    final flavor = getIt<Flavor>();

    // Read the latest states without rebuilding this widget.
    final displayState = context.read<DisplayCubit>().state;
    final gpsState = context.read<GPSConfigurationCubit>().state;
    final audioState = context.read<AudioConfigurationCubit>().state;

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
}