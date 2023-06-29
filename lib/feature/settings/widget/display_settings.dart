import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:tesla_android/feature/display/model/remote_display_state.dart';
import 'package:tesla_android/feature/settings/bloc/display_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/display_configuration_state.dart';
import 'package:tesla_android/feature/settings/widget/settings_section.dart';
import 'package:tesla_android/feature/settings/widget/settings_tile.dart';

class DisplaySettings extends SettingsSection {
  const DisplaySettings({super.key})
      : super(
          name: "Display",
          icon: Icons.display_settings,
        );

  @override
  Widget body(BuildContext context) {
    final cubit = BlocProvider.of<DisplayConfigurationCubit>(context);

    return BlocBuilder<DisplayConfigurationCubit, DisplayConfigurationState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsTile(
                icon: Icons.display_settings,
                title: 'Resolution',
                trailing: _lowResDropdown(context, cubit, state)),
            const Padding(
              padding: EdgeInsets.all(TADimens.PADDING_S_VALUE),
              child: Text(
                  'Choosing a low resolution improves the display performance in Drive. It reduces the browser load, meant for cars equipped with MCU2.'),
            ),
            divider,
            SettingsTile(
                icon: Icons.texture,
                title: 'Renderer',
                dense: false,
                trailing: _rendererDropdown(context, cubit, state)),
            const Padding(
              padding: EdgeInsets.all(TADimens.PADDING_S_VALUE),
              child: Text(
                  'Advanced setting, Tesla Android supports multiple renderers for different operating environments. Some of them are slower in Drive and faster in Park. There are also differences in CPU/GPU usage. May the best one win!'),
            ),
          ],
        );
      },
    );
  }

  Widget _lowResDropdown(BuildContext context, DisplayConfigurationCubit cubit,
      DisplayConfigurationState state) {
    if (state is DisplayConfigurationStateSettingsFetched) {
      return DropdownButton<DisplayLowResModePreset>(
        value: state.lowResModePreset,
        icon: const Icon(Icons.arrow_drop_down_outlined),
        underline: Container(
          height: 2,
          color: Theme.of(context).primaryColor,
        ),
        onChanged: (DisplayLowResModePreset? value) {
          if (value != null) {
            cubit.setLowResMode(value);
          }
        },
        items: DisplayLowResModePreset.values
            .map<DropdownMenuItem<DisplayLowResModePreset>>(
                (DisplayLowResModePreset value) {
          return DropdownMenuItem<DisplayLowResModePreset>(
            value: value,
            child: Text(value.name()),
          );
        }).toList(),
      );
    } else if (state is DisplayConfigurationStateSettingsUpdateInProgress ||
        state is DisplayConfigurationStateLoading) {
      return const CircularProgressIndicator();
    } else if (state is DisplayConfigurationStateError) {
      return const Text("Service error");
    }
    return const SizedBox.shrink();
  }

  Widget _rendererDropdown(BuildContext context,
      DisplayConfigurationCubit cubit, DisplayConfigurationState state) {
    if (state is DisplayConfigurationStateSettingsFetched) {
      return DropdownButton<DisplayRendererType>(
        value: state.renderer,
        icon: const Icon(Icons.arrow_drop_down_outlined),
        underline: Container(
          height: 2,
          color: Theme.of(context).primaryColor,
        ),
        onChanged: (DisplayRendererType? value) {
          if (value != null) {
            cubit.setRenderer(value);
          }
        },
        items: DisplayRendererType.values
            .map<DropdownMenuItem<DisplayRendererType>>(
                (DisplayRendererType value) {
          return DropdownMenuItem<DisplayRendererType>(
            value: value,
            child: Text(value.name()),
          );
        }).toList(),
      );
    } else if (state is DisplayConfigurationStateSettingsUpdateInProgress ||
        state is DisplayConfigurationStateLoading) {
      return const CircularProgressIndicator();
    } else if (state is DisplayConfigurationStateError) {
      return const Text("Service error");
    }
    return const SizedBox.shrink();
  }
}
