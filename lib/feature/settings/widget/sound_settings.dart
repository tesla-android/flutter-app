import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:tesla_android/feature/audio/cubit/audio_cubit.dart';
import 'package:tesla_android/feature/audio/cubit/audio_state.dart';
import 'package:tesla_android/feature/settings/widget/settings_header.dart';
import 'package:tesla_android/feature/settings/widget/settings_section.dart';
import 'package:tesla_android/feature/settings/widget/settings_tile.dart';

class SoundSettings extends SettingsSection {
  const SoundSettings({super.key})
      : super(
          name: "Audio",
          icon: Icons.speaker,
        );

  @override
  Widget body(BuildContext context) {
    final cubit = BlocProvider.of<AudioCubit>(context);

    return BlocBuilder<AudioCubit, AudioState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SettingsHeader(
              title: 'Browser audio',
            ),
            SettingsTile(
                icon: Icons.speaker,
                title: 'State',
                subtitle: 'Disable if you intend to use Bluetooth audio',
                trailing: Switch(
                    value: state.isEnabled,
                    onChanged: (value) {
                      if (value) {
                        cubit.enableAudio();
                      } else {
                        cubit.disableAudio();
                      }
                    })),
            if (state.isEnabled)
              SettingsTile(
                  icon: Icons.volume_down,
                  title: 'Volume',
                  trailing: Slider(
                    divisions: 25,
                    min: 0.0,
                    max: 1.0,
                    value: state.volume,
                    onChanged: (double value) {
                      cubit.setVolume(value);
                    },
                  )),
            const Padding(
              padding: EdgeInsets.all(TADimens.PADDING_S_VALUE),
              child: Text(
                  'If you plan to use browser audio continuously in conjunction with video playback, it\'s essential to note that it can be bandwidth-intensive. To optimize your experience, you may want to consider pairing your car with the Tesla Android device over Bluetooth, particularly if your Tesla is equipped with MCU2.'),
            ),
            const Padding(
              padding: EdgeInsets.all(TADimens.PADDING_S_VALUE),
              child: Text(
                  'In case you encounter a situation where the browser in your Tesla fails to produce sound, a simple reboot of the vehicle should resolve the issue. Please note that this is a known issue with the browser itself.'),
            ),
          ],
        );
      },
    );
  }
}
