import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/feature/androidViewer/touchscreen/cubit/touchscreen_cubit.dart';

class TouchScreenView extends StatelessWidget {
  const TouchScreenView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<TouchscreenCubit>(context);
    return LayoutBuilder(builder: (context, constraints) {
      return Listener(
        onPointerDown: (event) => cubit.dispatchTouchEvent(
            event.pointer, event.localPosition, true, constraints),
        onPointerMove: (event) => cubit.dispatchTouchEvent(
            event.pointer, event.localPosition, true, constraints),
        onPointerCancel: (event) => cubit.dispatchTouchEvent(
            event.pointer, event.localPosition, false, constraints),
        onPointerUp: (event) => cubit.dispatchTouchEvent(
            event.pointer, event.localPosition, false, constraints),
        child: Container(color: Colors.transparent),
      );
    });
  }
}
