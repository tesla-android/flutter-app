import 'dart:async';
import 'dart:ui' as ui;
import 'dart:ui_web' as ui_web;
import 'dart:js_interop';

import 'webcodecs_bindings.dart';

FutureOr<ui.Image> videoFrameToUiImage(VideoFrame frame) {
  final w = frame.codedWidth ?? 0;
  final h = frame.codedHeight ?? 0;

  if (w == 0 || h == 0) {
    throw StateError('VideoFrame has no coded size');
  }

  return ui_web.createImageFromTextureSource(
    frame as JSAny,
    width: w,
    height: h,
    transferOwnership: true,
  );
}