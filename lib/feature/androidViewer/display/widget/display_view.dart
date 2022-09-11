import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:tesla_android/common/di/ta_locator.dart';
import 'package:tesla_android/feature/androidViewer/display/cubit/display_cubit.dart';
import 'package:tesla_android/feature/androidViewer/display/cubit/display_state.dart';
import 'package:tesla_android/feature/androidViewer/display/widget/iframe_view.dart';

class DisplayView extends StatelessWidget {
  final Widget touchScreenView;

  const DisplayView({Key? key, required this.touchScreenView})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DisplayCubit, DisplayState>(builder: (context, state) {
      switch (state) {
        case DisplayState.initial:
          return _displayStateInitialFragment();
        case DisplayState.unreachable:
          return _displayStateUnreachableFragment();
        case DisplayState.normal:
          return _displayStateNormalFragment();
      }
    });
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

  Widget _displayStateInitialFragment() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _displayStateUnreachableFragment() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Text("Display service is unreachable, retrying..."),
        SizedBox(
          height: 15,
        ),
        CircularProgressIndicator()
      ],
    );
  }
}
