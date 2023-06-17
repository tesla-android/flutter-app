import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/feature/audio/cubit/audio_cubit.dart';
import 'package:tesla_android/feature/display/cubit/display_cubit.dart';
import 'package:tesla_android/feature/display/cubit/display_state.dart';
import 'package:tesla_android/feature/touchscreen/cubit/touchscreen_cubit.dart';

class TouchScreenView extends StatelessWidget {
  const TouchScreenView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final touchScreenCubit = BlocProvider.of<TouchscreenCubit>(context);
    // FIXME Audio lifecycle
    final audioCubit = BlocProvider.of<AudioCubit>(context);
    return BlocBuilder<DisplayCubit, DisplayState>(builder: (context, state) {
      if (state is DisplayStateNormal) {
        return LayoutBuilder(builder: (context, constraints) {
          return Listener(
            onPointerDown: (event) {
              _handlePointerEvent(
                cubit: touchScreenCubit,
                event: event,
                constraints: constraints,
                touchscreenSize: state.adjustedSize,
              );
            },
            onPointerMove: (event) {
              _handlePointerEvent(
                cubit: touchScreenCubit,
                event: event,
                constraints: constraints,
                touchscreenSize: state.adjustedSize,
              );
            },
            onPointerCancel: (event) {
              _handlePointerEvent(
                cubit: touchScreenCubit,
                event: event,
                constraints: constraints,
                touchscreenSize: state.adjustedSize,
              );
            },
            onPointerUp: (event) {
              _handlePointerEvent(
                cubit: touchScreenCubit,
                event: event,
                constraints: constraints,
                touchscreenSize: state.adjustedSize,
              );
            },
            child: Container(color: Colors.transparent),
          );
        });
      }
      return const SizedBox.shrink();
    });
  }

  void _handlePointerEvent({
    required TouchscreenCubit cubit,
    required BoxConstraints constraints,
    required Size touchscreenSize,
    required dynamic event,
  }) {
    if (event is PointerDownEvent) {
      cubit.handlePointerDownEvent(event, constraints, touchscreenSize);
    } else if (event is PointerMoveEvent) {
      cubit.handlePointerMoveEvent(event, constraints, touchscreenSize);
    } else if (event is PointerCancelEvent || event is PointerUpEvent) {
      cubit.handlePointerUpEvent(event, constraints);
    }
  }
}
