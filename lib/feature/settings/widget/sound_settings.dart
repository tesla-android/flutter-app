import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/feature/audio/cubit/audio_cubit.dart';
import 'package:tesla_android/feature/audio/cubit/audio_state.dart';
import 'package:tesla_android/feature/settings/widget/settings_tile.dart';

class SoundSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<AudioCubit>(context);

    return BlocBuilder<AudioCubit, AudioState>(
      builder: (context, state) {
        return Column(
          children: [
            SettingsTile(
                icon: Icons.speaker,
                title: 'Browser audio',
                subtitle:
                'Disable browser audio if you intend to use Bluetooth, HDMI or the headphone jack',
                trailing: Switch(
                    value: state.isEnabled,
                    onChanged: (value) {
                      if(value) {
                        cubit.enableAudio();
                      } else {
                        cubit.disableAudio();
                      }
                    })),
            if(state.isEnabled) SettingsTile(
                icon: Icons.volume_down,
                title: 'Volume',
                trailing: Slider(
                  divisions: 25,
                  min: 0.0,
                  max: 1.0,
                  value: state.volume,
                  onChanged: (double value) {
                    cubit.setVolume(
                        value);
                  },
                )),
          ],
        );
      },
    );
  }
}