import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:tesla_android/common/di/ta_locator.dart';
import 'package:tesla_android/feature/display/cubit/display_cubit.dart';
import 'package:tesla_android/feature/display/cubit/display_state.dart';
import 'package:tesla_android/feature/display/widget/display_html_view.dart';

class DisplayView extends StatelessWidget {
  final Widget touchScreenView;

  const DisplayView({Key? key, required this.touchScreenView})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<DisplayCubit>(context);
    return LayoutBuilder(
        builder: (context, constraints) {
          cubit.resizeDisplay(viewConstraints: constraints);
          return Center(
            child: BlocBuilder<DisplayCubit, DisplayState>(builder: (context, state) {
              if (state is DisplayStateNormal) {
                return _normalBody(state);
              }
              return const CircularProgressIndicator();
            }),
          );
        }
    );
  }

  Widget _normalBody(DisplayStateNormal state) {
    return AspectRatio(
      aspectRatio: state.adjustedSize.width/state.adjustedSize.height,
      child: Stack(
        children: [
          const DisplayHtmlView(),
          PointerInterceptor(child: touchScreenView),
        ],
      ),
    );
  }
}
