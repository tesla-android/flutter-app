import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'h264_webcodecs_decoder.dart';
import 'video_frame_to_image.dart';

abstract class DisplayDecoder {
  FutureOr<void> handleMessage(Uint8List frame);
  void dispose();
}

class H264DisplayDecoder implements DisplayDecoder {
  final H264WebCodecsDecoder _inner;

  H264DisplayDecoder({
    required int codedWidth,
    required int codedHeight,
    required int displayWidth,
    required int displayHeight,
    required void Function(Image image) onImage,
    required void Function(Object error, StackTrace stackTrace) onError,
    bool debug = false,
  }) : _inner = H264WebCodecsDecoder(
    codedWidth: codedWidth,
    codedHeight: codedHeight,
    displayWidth: displayWidth,
    displayHeight: displayHeight,
    debug: debug,
    onFrame: (videoFrame) async {
      try {
        final image = await videoFrameToUiImage(videoFrame);
        onImage(image);
      } catch (e, st) {
        onError(e, st);
      }
    },
  );

  @override
  void dispose() => _inner.dispose();

  @override
  void handleMessage(Uint8List frame) {
    _inner.handleMessage(frame);
  }
}

/// MJPEG decoder that takes full JPEG frames as Uint8List and converts to Image.
class JpegDisplayDecoder implements DisplayDecoder {
  final void Function(Image image) _onImage;
  final void Function(Object error, StackTrace stackTrace) _onError;

  JpegDisplayDecoder({
    required void Function(Image image) onImage,
    required void Function(Object error, StackTrace stackTrace) onError,
  })  : _onImage = onImage,
        _onError = onError;

  @override
  void dispose() {}

  @override
  Future<void> handleMessage(Uint8List frame) async {
    try {
      final codec = await instantiateImageCodec(frame);
      final fi = await codec.getNextFrame();
      _onImage(fi.image);
    } catch (e, st) {
      _onError(e, st);
    }
  }
}