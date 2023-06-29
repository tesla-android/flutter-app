//ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:tesla_android/feature/display/model/remote_display_state.dart';
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
    _iframeElement.src = widget.type.resourcePath();
    _iframeElement.style.border = 'none';
    _iframeElement.style.width = '100%';
    _iframeElement.style.height = '100%';

    //ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      _uuid,
          (int viewId) => _iframeElement,
    );
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(
      viewType: _uuid,
    );
  }
}
