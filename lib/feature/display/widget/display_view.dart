import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/feature/display/cubit/display_cubit.dart';

class DisplayView extends StatefulWidget {
  const DisplayView({super.key});

  @override
  State createState() => _DisplayViewState();
}

class _DisplayViewState extends State<DisplayView> {
  MemoryImage? _image;
  late DisplayCubit _cubit;
  late StreamSubscription _streamSubscription;

  @override
  void initState() {
    _cubit = context.read<DisplayCubit>();
    _streamSubscription = _cubit.jpegDataStream.listen((byteBuffer) async {
      final decodedImage = MemoryImage(byteBuffer.asUint8List());
      if (mounted) {
        await precacheImage(decodedImage, context).catchError((error) {
          debugPrint('Image precache error');
        });
      }
      if (mounted) {
        setState(() {
          _image = decodedImage;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() async {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_image != null) {
      return Image(
        image: _image!,
        fit: BoxFit.cover,
      );
    }
    return Container();
  }
}
