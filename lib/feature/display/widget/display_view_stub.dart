import 'package:flutter/material.dart';
import 'package:tesla_android/feature/display/model/remote_display_state.dart';

class DisplayView extends StatelessWidget {
  final DisplayRendererType type;

  const DisplayView({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("DisplayView is not supported on this platform"),
    );
  }
}
