import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/common/ui/constants/ta_timing.dart';
import 'package:tesla_android/feature/androidViewer/touchscreen/cubit/touchscreen_cubit.dart';

class TouchScreenView extends StatelessWidget {
  const TouchScreenView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<TouchscreenCubit>(context);
    return _touchScreenStateListener(
      cubit,
      LayoutBuilder(builder: (context, constraints) {
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
      }),
    );
  }

  Widget _touchScreenStateListener(Cubit cubit, Widget child) {
    return BlocListener(
      bloc: cubit,
      listener: (BuildContext context, state) {
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        if (state == false) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: const Text(
                  'Virtual touchscreen is not active. Wait for Android to boot up.'),
              duration: TATiming.snackBarDuration,
              action: SnackBarAction(
                label: 'Dismiss',
                onPressed: scaffoldMessenger.hideCurrentSnackBar,
              ),
            ),
          );
        } else {
          scaffoldMessenger.hideCurrentSnackBar();
        }
      },
      child: child,
    );
  }
}
