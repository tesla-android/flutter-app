import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tesla_android/common/service/audio_service.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:tesla_android/common/utils/logger.dart';
import 'package:tesla_android/feature/settings/bloc/audio_configuration_cubit.dart';

import '../../settings/bloc/audio_configuration_state.dart';

class AudioButton extends StatefulWidget {
  const AudioButton({super.key});

  @override
  State<AudioButton> createState() => _AudioButtonState();
}

class _AudioButtonState extends State<AudioButton> with Logger {
  String _state = 'stopped';
  VoidCallback? _removeListener;
  final AudioService _audioService = GetIt.I<AudioService>();

  @override
  void initState() {
    super.initState();
    _readInitialState();
    _removeListener = _audioService.addAudioStateListener((s) {
      if (!mounted) return;
      setState(() => _state = s);
    });
  }

  @override
  void dispose() {
    _removeListener?.call();
    super.dispose();
  }

  void _readInitialState() {
    try {
      _state = _audioService.getAudioState();
    } catch (_) {
      _state = 'stopped';
    }
  }

  void _onPressed() {
    if (_state == 'playing') {
      _audioService.stopAudio();
      setState(() => _state = 'stopped');
    } else {
      _audioService.startAudioFromGesture();
      setState(() => _state = 'playing');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isPlaying = _state == 'playing';

    return BlocBuilder<AudioConfigurationCubit, AudioConfigurationState>(
      bloc: BlocProvider.of<AudioConfigurationCubit>(context)
        ..fetchConfiguration(),
      builder: (context, audioState) {
        if (audioState is AudioConfigurationStateSettingsFetched &&
            audioState.isEnabled) {
          return IconButton(
            color: Colors.white,
            onPressed: _onPressed,
            icon: Icon(
              isPlaying ? Icons.volume_up : Icons.volume_off,
              size: TADimens.statusBarIconSize,
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
