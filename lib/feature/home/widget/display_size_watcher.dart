import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/feature/display/cubit/display_cubit.dart';

class DisplaySizeWatcher extends StatefulWidget {
  final Widget Function(Size size) builder;
  const DisplaySizeWatcher({super.key, required this.builder});

  @override
  State<DisplaySizeWatcher> createState() => _DisplaySizeWatcherState();
}

class _DisplaySizeWatcherState extends State<DisplaySizeWatcher> {
  Size? _lastSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);

        if (_lastSize != size) {
          _lastSize = size;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            context.read<DisplayCubit>().onWindowSizeChanged(size);
          });
        }

        return widget.builder(size);
      },
    );
  }
}
