import 'dart:async';
import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

typedef CreateAudioContextFunc = dynamic Function();

@JS('createAudioContext')
external CreateAudioContextFunc _createAudioContext();

@lazySingleton
class PcmAudioPlayer {
  dynamic _audioContext;
  dynamic _sourceNode;
  dynamic _gainNode;
  bool _isContextReady = false;
  Float32List _samples = Float32List(0);

  final int _sampleRate = 48000;
  final int _numChannels = 2;
  final int _bitsPerSample = 16;
  final Duration _flushInterval = const Duration(milliseconds: 200);
  dynamic _startTime;

  // This method should be called after user interaction
  Future<void> initialize() async {
    _audioContext = _createAudioContext();
    dynamic resumeMethod = getProperty(_audioContext, 'resume');
    await promiseToFuture<void>(
        callMethod(resumeMethod, 'call', [_audioContext]));
    _isContextReady = true;

    _gainNode = callMethod(_audioContext, 'createGain', []);
    setProperty(getProperty(_gainNode, 'gain'), 'value', 1.0);
    callMethod(
        _gainNode, 'connect', [getProperty(_audioContext, 'destination')]);

    _startTime = getProperty(_audioContext, 'currentTime');

    Timer.periodic(_flushInterval, (Timer t) => _flush());
  }

  bool get isContextReady => _isContextReady;

  void feed(Uint8List data) {
    int bufferLength = data.length ~/ (_numChannels * (_bitsPerSample ~/ 8));
    Float32List tempBuffer = Float32List(bufferLength);
    int offset = 0;

    for (int i = 0; i < bufferLength; ++i) {
      int byteOffset = i * _numChannels * (_bitsPerSample ~/ 8) + offset;
      int sample = data[byteOffset] + (data[byteOffset + 1] << 8);
      tempBuffer[i] = (sample < 0x8000 ? sample : sample - 0x10000) / 0x8000;
    }

    Float32List newSamples = Float32List(_samples.length + tempBuffer.length);
    newSamples.setAll(0, _samples);
    newSamples.setAll(_samples.length, tempBuffer);
    _samples = newSamples;
  }

  void _flush() {
    if (_samples.isEmpty) return;
    if (!_isContextReady) {
      throw Exception(
          'AudioContext not initialized or not ready. Call initialize() first.');
    }

    int bufferLength = _samples.length;
    dynamic audioBuffer = callMethod(
      _audioContext,
      'createBuffer',
      [1, bufferLength, _sampleRate],
    );

    Float32List targetBuffer = callMethod(audioBuffer, 'getChannelData', [0]);
    for (int i = 0; i < bufferLength; ++i) {
      targetBuffer[i] = _samples[i];
    }

    _sourceNode = callMethod(_audioContext, 'createBufferSource', []);
    setProperty(_sourceNode, 'buffer', audioBuffer);
    callMethod(_sourceNode, 'connect', [_gainNode]);

    double duration = bufferLength / _sampleRate;
    double startTime = getProperty(_audioContext, 'currentTime');
    if (startTime < _startTime) {
      startTime = _startTime;
    }

    callMethod(_sourceNode, 'start', [startTime, 0, duration]);

    _startTime = startTime + duration;
    _samples = Float32List(0);
  }

  void setVolume(double volume) {
    if (_gainNode != null) {
      setProperty(getProperty(_gainNode, 'gain'), 'value', volume);
    }
  }
}
