import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/utils/logger.dart';
import 'package:tesla_android/feature/audio/cubit/audio_state.dart';
import 'package:tesla_android/feature/audio/transport/audio_transport.dart';
import 'package:tesla_android/feature/audio/utils/pcm_player.dart';
import 'package:tesla_android/feature/settings/repository/system_configuration_repository.dart';

@injectable
class AudioCubit extends Cubit<AudioState> with Logger {
  final AudioTransport _audioTransport;
  final PcmAudioPlayer _pcmAudioPlayer;
  final SystemConfigurationRepository _systemConfigurationRepository;

  StreamSubscription? _audioTransportPcmDataStreamSubscription;

  AudioCubit(
    this._audioTransport,
    this._pcmAudioPlayer,
    this._systemConfigurationRepository,
  ) : super(AudioState(isEnabled: false));

  @override
  Future<void> close() {
    _audioTransportPcmDataStreamSubscription?.cancel();
    _audioTransport.disconnect();
    return super.close();
  }

  void enableIfNeeded() async {
    if (state.isEnabled == true) return;
    try {
      final configuration =
          await _systemConfigurationRepository.getConfiguration();
      final isEnabled = configuration.browserAudioIsEnabled == 1;
      final volume = configuration.browserAudioVolume;
      if (isEnabled) {
        enableAudio();
        setVolume(volume / 100);
      }
    } catch (exception, stackTrace) {
      logException(
        exception: exception,
        stackTrace: stackTrace,
      );
    }
  }

  void enableAudio() {
    _subscribeToAudioTransport();
    emit(state.copyWith(isEnabled: true));
  }

  void setVolume(double volume) {
    emit(state.copyWith(volume: volume));
    _pcmAudioPlayer.setVolume(volume);
  }

  void _subscribeToAudioTransport() {
    _audioTransport.connect();
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
