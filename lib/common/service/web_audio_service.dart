import 'dart:js_interop';
import 'package:flutter/foundation.dart';
import 'package:tesla_android/common/service/audio_service.dart';
import 'package:web/web.dart' as web;

@JS('setupAudioConfig')
external void _setupAudioConfig(String configJson);

@JS('startAudioFromGesture')
external void _startAudioFromGesture();

@JS('stopAudio')
external void _stopAudio();

@JS('getAudioState')
external String _getAudioState();

class WebAudioService implements AudioService {
  @override
  void setupAudioConfig(String configJson) {
    _setupAudioConfig(configJson);
  }

  @override
  void startAudioFromGesture() {
    _startAudioFromGesture();
  }

  @override
  void stopAudio() {
    _stopAudio();
  }

  @override
  String getAudioState() {
    return _getAudioState();
  }

  @override
  VoidCallback addAudioStateListener(void Function(String state) onState) {
    final jsListener = (web.Event e) {
      // We know 'audio-state' is a CustomEvent
      final customEvent = e as web.CustomEvent;
      final detail = customEvent.detail; // JSAny?

      if (detail != null) {
        // We expect detail to be a JSString
        final state = (detail as JSString).toDart;
        onState(state);
      }
    }.toJS;

    web.window.addEventListener('audio-state', jsListener);

    return () {
      web.window.removeEventListener('audio-state', jsListener);
    };
  }
}

AudioService createAudioService() => WebAudioService();
