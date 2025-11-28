@JS()
library;

import 'dart:js_interop';

@JS()
extension type VideoFrameCopyToOptions._(JSObject _) implements JSObject {
  external factory VideoFrameCopyToOptions({
    String? format, // e.g. 'RGBA'
  });

  external String? get format;
}

@JS('VideoFrame')
extension type VideoFrame._(JSObject _) implements JSObject {
  external void close();

  external int? get codedWidth;
  external int? get codedHeight;
  external String? get format;

  external JSPromise copyTo(
    JSUint8Array destination,
    VideoFrameCopyToOptions options,
  );
}

@JS()
extension type EncodedVideoChunkInit._(JSObject _) implements JSObject {
  external factory EncodedVideoChunkInit({
    required String type, // 'key' | 'delta'
    required int timestamp,
    int? duration,
    required JSUint8Array data, // Uint8Array / BufferSource
  });

  external String get type;
  external int get timestamp;
  external int? get duration;
  external JSUint8Array get data;
}

@JS('EncodedVideoChunk')
extension type EncodedVideoChunk._(JSObject _) implements JSObject {
  external factory EncodedVideoChunk(EncodedVideoChunkInit init);

  external void close();
  external String get type;
}

@JS()
extension type VideoDecoderInit._(JSObject _) implements JSObject {
  external factory VideoDecoderInit({
    required JSFunction output,
    required JSFunction error,
  });

  external JSFunction get output;
  external JSFunction get error;
}

@JS()
extension type VideoDecoderConfig._(JSObject _) implements JSObject {
  external factory VideoDecoderConfig({
    required String codec, // e.g. 'avc1.42e01e'
    int? codedWidth,
    int? codedHeight,
    int? displayAspectWidth,
    int? displayAspectHeight,
    String? hardwareAcceleration, // 'prefer-hardware' | ...
    bool? optimizeForLatency,
  });

  external String get codec;
  external int? get codedWidth;
  external int? get codedHeight;
  external int? get displayAspectWidth;
  external int? get displayAspectHeight;
  external String? get hardwareAcceleration;
  external bool? get optimizeForLatency;
}

@JS('VideoDecoder')
extension type VideoDecoder._(JSObject _) implements JSObject {
  external factory VideoDecoder(VideoDecoderInit init);

  external void configure(VideoDecoderConfig config);
  external void decode(EncodedVideoChunk chunk);
  external JSPromise flush();
  external void close();
  external String get state; // 'unconfigured' | 'configured' | 'closed'
}
