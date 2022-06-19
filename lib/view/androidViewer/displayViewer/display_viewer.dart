import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:tesla_android/view/iframe/iframe_view.dart';

class DisplayViewer extends StatelessWidget {
  final Widget touchScreenView;

  const DisplayViewer({Key? key, required this.touchScreenView})
      : super(key: key);

  final double _videoAspectRatio = 896 / 700;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Center(
        child: AspectRatio(
          aspectRatio: _videoAspectRatio,
          child: Stack(
            children: [
              const IframeView(source: "player.html"),
              PointerInterceptor(child: touchScreenView),
            ],
          ),
        ),
      ),
    );
  }
}
