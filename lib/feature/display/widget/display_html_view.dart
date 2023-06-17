//ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui' as ui;

import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:tesla_android/common/di/ta_locator.dart';

class DisplayHtmlView extends StatefulWidget {
  const DisplayHtmlView({Key? key}) : super(key: key);

  @override
  DisplayHtmlViewState createState() => DisplayHtmlViewState();
}

class DisplayHtmlViewState extends State<DisplayHtmlView> {
  final IFrameElement _iframeElement = IFrameElement();
  final Flavor _flavor = getIt<Flavor>();

  String get _streamUrl => _flavor.getString("displayStreamUrl")!;

  @override
  void initState() {
    super.initState();
    _iframeElement.srcdoc = _getIframeContent();
    _iframeElement.style.border = 'none';

    //ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      _streamUrl, //use source as registered key to ensure uniqueness
      (int viewId) => _iframeElement,
    );
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(
      viewType: _streamUrl,
    );
  }

  String _getIframeContent() {
    return """
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8"/>
      <title>Player</title>
      <style>
        html, body {
          width:  100%;
          height: 100%;
          margin: 0;
          overflow: hidden;
        }
        img {
          width: 100%;
        }
      </style>
    </head>
    <body>
      <img id="player"/>
      <script>
        var player = document.getElementById("player");
       player.src = "$_streamUrl"
      </script>
    </body>
    </html>
    """;
  }
}
