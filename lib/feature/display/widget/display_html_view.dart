//ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui' as ui;
import 'package:uuid/uuid.dart';


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

  late String _viewId;

  @override
  void initState() {
    super.initState();
    _viewId = const Uuid().v1();
    _iframeElement.srcdoc = _getIframeContent();
    _iframeElement.style.border = 'none';
    _iframeElement.style.width = "100%";
    _iframeElement.style.height = "100%";

    //ignore: undefined_prefixed_name
    final test = ui.platformViewRegistry.registerViewFactory(
     _viewId,
      (int viewId) => _iframeElement,
    );
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(
      viewType: _viewId,
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
