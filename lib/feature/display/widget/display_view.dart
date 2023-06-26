//ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class DisplayView extends StatefulWidget {
  final String source;

  const DisplayView({Key? key, required this.source}) : super(key: key);

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
    _iframeElement.src = widget.source;
    _iframeElement.style.border = 'none';

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
