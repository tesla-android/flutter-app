import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/common/ui/components/settings_slider.dart';
import 'package:tesla_android/common/ui/components/settings_switch.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:tesla_android/feature/settings/bloc/audio_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/audio_configuration_state.dart';
import 'package:tesla_android/feature/settings/view_model/sound_settings_view_model.dart';
import 'package:tesla_android/feature/settings/widget/settings_section.dart';
import 'package:tesla_android/feature/settings/widget/settings_tile.dart';

class SoundSettings extends SettingsSection {
  const SoundSettings({super.key}) : super(name: "Audio", icon: Icons.speaker);

  @override
  Widget body(BuildContext context) {
    final cubit = BlocProvider.of<AudioConfigurationCubit>(context);
    final viewModel = SoundSettingsViewModel();

    return BlocBuilder<AudioConfigurationCubit, AudioConfigurationState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsTile(
              icon: Icons.speaker,
              title: 'Browser audio',
              subtitle: 'Disable if you intend to use Bluetooth audio',
              trailing: _audioStateSwitch(context, cubit, state, viewModel),
            ),
            divider,
            SettingsTile(
              icon: Icons.volume_down,
              title: 'Volume',
              trailing: _audioStateSlider(context, cubit, state, viewModel),
              dense: false,
            ),
            const Padding(
              padding: EdgeInsets.all(TADimens.PADDING_S_VALUE),
              child: Text(
                'If you plan to use browser audio continuously in conjunction with video playback, it\'s essential to note that it can be bandwidth-intensive. To optimize your experience, you may want to consider pairing your car with the Tesla Android device over Bluetooth, particularly if your Tesla is equipped with MCU2.',
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(TADimens.PADDING_S_VALUE),
              child: Text(
                'In case you encounter a situation where the browser in your Tesla fails to produce sound, a simple reboot of the vehicle should resolve the issue. Please note that this is a known issue with the browser itself.',
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _audioStateSwitch(
    BuildContext context,
    AudioConfigurationCubit cubit,
    AudioConfigurationState state,
    SoundSettingsViewModel viewModel,
  ) {
    return viewModel.buildStateWidget(
      state: state,
      onFetched: () {
        final isEnabled = viewModel.getAudioEnabled(state);
        if (isEnabled == null) return const SizedBox.shrink();

        return SettingsSwitch(
          value: isEnabled,
          onChanged: (value) {
            cubit.setState(value);
          },
        );
      },
    );
  }

  Widget _audioStateSlider(
    BuildContext context,
    AudioConfigurationCubit cubit,
    AudioConfigurationState state,
    SoundSettingsViewModel viewModel,
  ) {
    return viewModel.buildStateWidget(
      state: state,
      onFetched: () {
        final volume = viewModel.getVolume(state);
        if (volume == null) return const SizedBox.shrink();

        return SettingsSlider(
          value: volume.toDouble(),
          min: 0,
          max: 150,
          divisions: 15,
          label: volume.toString(),
          suffix: ' %',
          onChanged: (double value) {
            cubit.setVolume(value.toInt());
          },
        );
      },
    );
  }
}
