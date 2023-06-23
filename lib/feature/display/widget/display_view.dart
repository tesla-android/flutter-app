import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:tesla_android/common/di/ta_locator.dart';
import 'package:tesla_android/feature/display/cubit/display_cubit.dart';
import 'package:tesla_android/feature/display/cubit/display_state.dart';
import 'package:tesla_android/feature/display/widget/display_html_view.dart';
import 'package:tesla_android/feature/touchscreen/touchscreen_view.dart';

class DisplayView extends StatelessWidget {
  const DisplayView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<DisplayCubit>(context);
    return LayoutBuilder(builder: (context, constraints) {
      cubit.resizeDisplay(viewConstraints: constraints);
      return Center(
        child:
            BlocBuilder<DisplayCubit, DisplayState>(builder: (context, state) {
          if (state is DisplayStateNormal) {
            return _normalBody(state);
          } else {
            return const CircularProgressIndicator();
          }
        }),
      );
    });
  }

  Widget _normalBody(DisplayStateNormal state) {
    return AspectRatio(
      aspectRatio: state.adjustedSize.width / state.adjustedSize.height,
      child: Stack(
        children: [
          const DisplayHtmlView(),
          PointerInterceptor(
              child: TouchScreenView(displaySize: state.adjustedSize))
        ],
      ),
    );
  }
}
