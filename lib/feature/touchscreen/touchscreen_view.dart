import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/feature/audio/cubit/audio_cubit.dart';
import 'package:tesla_android/feature/touchscreen/cubit/touchscreen_cubit.dart';

class TouchScreenView extends StatelessWidget {
  const TouchScreenView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<TouchscreenCubit>(context);
    final audioCubit = BlocProvider.of<AudioCubit>(context);
    return LayoutBuilder(builder: (context, constraints) {
      return Listener(
        onPointerDown: (event) {
          _handlePointerEvent(
            cubit: cubit,
            audioCubit: audioCubit,
            index: event.pointer,
            offset: event.localPosition,
            isBeingTouched: true,
            constraints: constraints,
          );
        },
        onPointerMove: (event) {
          _handlePointerEvent(
            cubit: cubit,
            audioCubit: audioCubit,
            index: event.pointer,
            offset: event.localPosition,
            isBeingTouched: true,
            constraints: constraints,
          );
        },
        onPointerCancel: (event) {
          _handlePointerEvent(
            cubit: cubit,
            audioCubit: audioCubit,
            index: event.pointer,
            offset: event.localPosition,
            isBeingTouched: false,
            constraints: constraints,
          );
        },
        onPointerUp: (event) {
          _handlePointerEvent(
            cubit: cubit,
            audioCubit: audioCubit,
            index: event.pointer,
            offset: event.localPosition,
            isBeingTouched: false,
            constraints: constraints,
          );
        },
        child: Container(color: Colors.transparent),
      );

    });
  }

  void _handlePointerEvent(
      {required TouchscreenCubit cubit,
      required AudioCubit audioCubit,
      required int index,
      required Offset offset,
      required bool isBeingTouched,
      required BoxConstraints constraints}) {
    audioCubit.initialiseAudioPlayerIfNeeded();
    cubit.dispatchTouchEvent(index, offset, isBeingTouched, constraints);
  }
}
