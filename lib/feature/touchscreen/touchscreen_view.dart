
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/feature/touchscreen/cubit/touchscreen_cubit.dart';

class TouchScreenView extends StatelessWidget {
  final Size displaySize;

  const TouchScreenView({
    Key? key,
    required this.displaySize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final touchScreenCubit = BlocProvider.of<TouchscreenCubit>(context);
    return LayoutBuilder(builder: (context, constraints) {
      return AspectRatio(
        aspectRatio: displaySize.width / displaySize.height,
        child: Listener(
          onPointerDown: (event) {
            _handlePointerEvent(
              cubit: touchScreenCubit,
              event: event,
              constraints: constraints,
              touchscreenSize: displaySize,
            );
          },
          onPointerMove: (event) {
            _handlePointerEvent(
              cubit: touchScreenCubit,
              event: event,
              constraints: constraints,
              touchscreenSize: displaySize,
            );
          },
          onPointerCancel: (event) {
            _handlePointerEvent(
              cubit: touchScreenCubit,
              event: event,
              constraints: constraints,
              touchscreenSize: displaySize,
            );
          },
          onPointerUp: (event) {
            _handlePointerEvent(
              cubit: touchScreenCubit,
              event: event,
              constraints: constraints,
              touchscreenSize: displaySize,
            );
          },
          child: Container(color: Colors.transparent,),
        ),
      );
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