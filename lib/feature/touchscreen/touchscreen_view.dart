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
            event: event,
            constraints: constraints,
          );
        },
        onPointerMove: (event) {
          _handlePointerEvent(
            cubit: cubit,
            audioCubit: audioCubit,
            event: event,
            constraints: constraints,
          );
        },
        onPointerCancel: (event) {
          _handlePointerEvent(
            cubit: cubit,
            audioCubit: audioCubit,
            event: event,
            constraints: constraints,
          );
        },
        onPointerUp: (event) {
          _handlePointerEvent(
            cubit: cubit,
            audioCubit: audioCubit,
            event: event,
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
        required BoxConstraints constraints,
        required dynamic event,
      }) {
    if(event is PointerDownEvent) {
      cubit.handlePointerDownEvent(event, constraints);
    } else if(event is PointerMoveEvent) {
      cubit.handlePointerMoveEvent(event, constraints);
    } else if(event is PointerCancelEvent || event is PointerUpEvent) {
      cubit.handlePointerUpEvent(event, constraints);
    }
  }
}
