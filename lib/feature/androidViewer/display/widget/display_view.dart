import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:tesla_android/feature/androidViewer/display/cubit/display_cubit.dart';
import 'package:tesla_android/feature/androidViewer/display/cubit/display_state.dart';
import 'package:tesla_android/feature/androidViewer/display/model/ustreamer_state_resolution.dart';
import 'package:tesla_android/feature/androidViewer/display/widget/iframe_view.dart';

class DisplayView extends StatelessWidget {
  final Widget touchScreenView;

  const DisplayView({Key? key, required this.touchScreenView})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DisplayCubit, DisplayState>(
        builder: (context, state) {
      switch (state) {
        case DisplayState.initial:
          return _displayStateInitialFragment();
        case DisplayState.unreachable:
          return _displayStateUnreachableFragment();
        case DisplayState.waitingForBoot:
          return _displayStateWaitingForBootFragment();
        case DisplayState.normal:
          return _displayStateNormalFragment();
      }
    });
  }

  Widget _iframe() {
    return const IframeView(source: "player.html");
  }

  Widget _displayStateNormalFragment() {
    return Center(
      child: AspectRatio(
        aspectRatio: UstreamerStateResolution.normalStreamWidth /
            UstreamerStateResolution.normalStreamHeight,
        child: Stack(
          children: [
            _iframe(),
            PointerInterceptor(child: touchScreenView),
          ],
        ),
      ),
    );
  }

  Widget _displayStateWaitingForBootFragment() {
    return Center(
      child: _iframe(),
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
