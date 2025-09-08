@JS()
library;

import 'dart:js_interop';
import 'package:web/web.dart' as web;

@JS('setupAudioConfig')
external void setupAudioConfig(String configJson);

@JS('startAudioFromGesture')
external void startAudioFromGesture();

@JS('stopAudio')
external void stopAudio();

@JS('getAudioState')
external String getAudioState();

VoidCallback addAudioStateListener(void Function(String state) onState) {
  final jsListener = (web.Event e) {
    String? state;
    if (e is web.CustomEvent) {
      final detail = e.detail; // JSAny?
      if (detail is JSString) {
        state = detail.toDart;
      }
    }
    if (state != null) {
      onState(state!);
    }
  }.toJS;

  web.window.addEventListener('audio-state', jsListener);

  return () {
    web.window.removeEventListener('audio-state', jsListener);
  };
}

typedef VoidCallback = void Function();