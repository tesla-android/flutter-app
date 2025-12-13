import 'package:flutter/foundation.dart';
import 'package:tesla_android/common/service/audio_service.dart';

class AudioServiceStub implements AudioService {
  @override
  void setupAudioConfig(String configJson) {
    // No-op
  }

  @override
  void startAudioFromGesture() {
    // No-op
  }

  @override
  void stopAudio() {
    // No-op
  }

  @override
  String getAudioState() {
    return 'stopped';
  }

  @override
  VoidCallback addAudioStateListener(void Function(String state) onState) {
    return () {};
  }
}

AudioService createAudioService() => AudioServiceStub();
