import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:tesla_android/common/di/ta_locator.dart';
import 'package:tesla_android/feature/androidViewer/display/widget/iframe_view.dart';

class DisplayView extends StatelessWidget {
  final Widget touchScreenView;

  const DisplayView({Key? key, required this.touchScreenView})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _displayStateNormalFragment();
  }

  Widget _iframe() {
    return const IframeView(source: "player.html");
  }

  Widget _displayStateNormalFragment() {
    final flavor = getIt<Flavor>();
    return Center(
      child: AspectRatio(
        aspectRatio: (flavor.getInt("virtualDisplayWidth") ?? 1) /
            (flavor.getInt("virtualDisplayHeight") ?? 1),
        child: Stack(
          children: [
            _iframe(),
            PointerInterceptor(child: touchScreenView),
          ],
        ),
      ),
    );
  }
}
