import 'package:flutter/foundation.dart';

abstract class AudioService {
  void setupAudioConfig(String configJson);
  void startAudioFromGesture();
  void stopAudio();
  String getAudioState();
  VoidCallback addAudioStateListener(void Function(String state) onState);
}
