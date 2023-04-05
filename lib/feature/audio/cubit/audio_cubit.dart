import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tesla_android/feature/audio/transport/audio_transport.dart';
import 'package:tesla_android/feature/audio/utils/pcm_player.dart';

@injectable
class AudioCubit extends Cubit<AudioState> {
  final AudioTransport _audioTransport;
  final PcmAudioPlayer _pcmAudioPlayer;

  StreamSubscription? _audioTransportConnectionStateStreamSubscription;
  StreamSubscription? _audioTransportPcmDataStreamSubscription;

  bool get _isAudioPlayerInitialised => _pcmAudioPlayer.isContextReady;

  AudioCubit(this._audioTransport, this._pcmAudioPlayer) : super(AudioState(false, false)) {
    _listenToAudioTransportState();
    subscribeToAudioTransport();
  }

  @override
  Future<void> close() {
    _audioTransportConnectionStateStreamSubscription?.cancel();
    _audioTransportPcmDataStreamSubscription?.cancel();
    _audioTransport.disconnect();
    _pcmAudioPlayer.destroy();
    return super.close();
  }

  void _listenToAudioTransportState() {
    _audioTransportConnectionStateStreamSubscription = _audioTransport.connectionStateSubject.listen((value) {
      emit(AudioState(_isAudioPlayerInitialised, value));
    });
  }

  void subscribeToAudioTransport() {
    _audioTransport.maintainConnection();
    _audioTransportPcmDataStreamSubscription = _audioTransport.pcmDataSubject.listen((data) {
      if (_isAudioPlayerInitialised) {
        _feedAudioPlayer(data);
      }
    });
  }

  void initialiseAudioPlayerIfNeeded() async {
    if(!_isAudioPlayerInitialised) {
      await _pcmAudioPlayer.initialize();
    }
  }

  void destroyAudioPlayer() {
    _pcmAudioPlayer.destroy();
  }

  void _feedAudioPlayer(Uint8List pcmData) {
    _pcmAudioPlayer.feed(pcmData);
  }
}

class AudioState {
  final bool isAudioPlayerInitialised;
  final bool isWebSocketConnectionActive;

  AudioState(this.isAudioPlayerInitialised, this.isWebSocketConnectionActive);

}
