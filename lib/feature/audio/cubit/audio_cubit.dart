import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesla_android/feature/audio/cubit/audio_state.dart';
import 'package:tesla_android/feature/audio/transport/audio_transport.dart';
import 'package:tesla_android/feature/audio/utils/pcm_player.dart';

@singleton
class AudioCubit extends Cubit<AudioState> {
  final AudioTransport _audioTransport;
  final PcmAudioPlayer _pcmAudioPlayer;
  final SharedPreferences _sharedPreferences;

  StreamSubscription? _audioTransportConnectionStateStreamSubscription;
  StreamSubscription? _audioTransportPcmDataStreamSubscription;

  static const _sharedPreferencesKey = 'AudioCubit_isEnabled';

  AudioCubit(
    this._audioTransport,
    this._pcmAudioPlayer,
    this._sharedPreferences,
  ) : super(AudioState(isEnabled: false, isWebSocketConnectionActive: false)) {
    _listenToAudioTransportState();
    _setInitialState();
  }

  void enableAudio() {
    _subscribeToAudioTransport();
    _sharedPreferences.setBool(
      _sharedPreferencesKey,
      true,
    );
    emit(state.copyWith(isEnabled: true));
  }

  void disableAudio() {
    _audioTransport.disconnect();
    _audioTransportPcmDataStreamSubscription?.cancel();
    _sharedPreferences.setBool(
      _sharedPreferencesKey,
      false,
    );
    emit(state.copyWith(isEnabled: false));
  }

  void setVolume(double volume) {
    emit(state.copyWith(volume: volume));
    _pcmAudioPlayer.setVolume(volume);
  }

  void _setInitialState() {
    final shouldEnable =
        _sharedPreferences.getBool(_sharedPreferencesKey) ?? true;
    if (shouldEnable) {
      enableAudio();
    } else {
      disableAudio();
    }
  }

  void _listenToAudioTransportState() {
    _audioTransportConnectionStateStreamSubscription =
        _audioTransport.connectionStateSubject.listen((value) {
      emit(state.copyWith(isWebSocketConnectionActive: value));
    });
  }

  void _subscribeToAudioTransport() {
    _audioTransport.maintainConnection();
    _audioTransportPcmDataStreamSubscription =
        _audioTransport.pcmDataSubject.listen((data) {
      _feedAudioPlayer(data);
      emit(state.copyWith(isWebSocketConnectionActive: true));
    });
  }

  void _feedAudioPlayer(pcmData) {
    _pcmAudioPlayer.feed(pcmData);
  }
}
