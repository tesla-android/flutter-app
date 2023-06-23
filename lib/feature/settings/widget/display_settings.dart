import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:tesla_android/feature/settings/bloc/display_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/display_configuration_state.dart';
import 'package:tesla_android/feature/settings/widget/settings_header.dart';
import 'package:tesla_android/feature/settings/widget/settings_tile.dart';

class DisplaySettings extends StatelessWidget {
  const DisplaySettings({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<DisplayConfigurationCubit>(context);

    return BlocBuilder<DisplayConfigurationCubit, DisplayConfigurationState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SettingsHeader(
              title: 'Display',
            ),
            SettingsTile(
                icon: Icons.display_settings,
                title: 'Low resolution mode',
                trailing: _stateTrailing(cubit, state)),
            const Padding(
              padding: EdgeInsets.all(TADimens.PADDING_S_VALUE),
              child: Text(
                  'Enabling low resolution mode decreases the Virtual Display size by around 20%. It reduces the browser load, meant for cars equipped with MCU2.'),
            ),
          ],
        );
      },
    );
  }

  Widget _stateTrailing(
      DisplayConfigurationCubit cubit, DisplayConfigurationState state) {
    if (state is DisplayConfigurationStateSettingsFetched) {
      return Switch(
          value: state.isLowResActive, onChanged: cubit.setLowResMode);
    } else if (state is DisplayConfigurationStateSettingsUpdateInProgress || state is DisplayConfigurationStateLoading) {
      return const CircularProgressIndicator();
    } else if (state is DisplayConfigurationStateError) {
      return const Text("Service error");
    }
    return const SizedBox.shrink();
  }
}
