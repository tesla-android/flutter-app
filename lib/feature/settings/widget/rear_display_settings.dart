import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:tesla_android/feature/settings/bloc/rear_display_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/rear_display_configuration_state.dart';
import 'package:tesla_android/feature/settings/widget/settings_section.dart';
import 'package:tesla_android/feature/settings/widget/settings_tile.dart';

class RearDisplaySettings extends SettingsSection {
  const RearDisplaySettings({super.key})
    : super(name: "Rear Display", icon: Icons.tv);

  @override
  Widget body(BuildContext context) {
    final cubit = BlocProvider.of<RearDisplayConfigurationCubit>(context);

    return BlocBuilder<
      RearDisplayConfigurationCubit,
      RearDisplayConfigurationState
    >(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsTile(
              icon: Icons.monitor,
              title: 'Rear Display Support',
              trailing: _rearDisplayStateSwitch(context, cubit, state),
            ),
            const Padding(
              padding: EdgeInsets.all(TADimens.PADDING_S_VALUE),
              child: Text(
                'Enable if your vehicle is equipped with a factory rear display.\n\n'
                'Supported models:\n\n'
                '- Model 3 (2023+ / “Highland”)\n'
                '- Model Y (2025+ / “Juniper”)\n'
                '- Model S/X (2021+)\n'
                '- Cybertruck',
              ),
            ),
            if (state is RearDisplayConfigurationStateSettingsFetched &&
                state.isRearDisplayEnabled) ...[
              divider,
              SettingsTile(
                icon: Icons.screenshot_monitor,
                title: 'Primary Display',
                trailing: _isPrimaryDisplaySwitch(context, cubit, state),
              ),
              const Padding(
                padding: EdgeInsets.all(TADimens.PADDING_S_VALUE),
                child: Text(
                  'Enable this option if you are currently using Tesla Android on your main infotainment display.',
                ),
              ),
              divider,
              SettingsTile(
                icon: Icons.aspect_ratio,
                title: 'Rear Display Priority',
                trailing: _rearDisplayPrioritySwitch(context, cubit, state),
              ),
              const Padding(
                padding: EdgeInsets.all(TADimens.PADDING_S_VALUE),
                child: Text(
                  'Enable this option to synchronize the aspect ratio of your Tesla Android display with the secondary display.',
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _rearDisplayStateSwitch(
    BuildContext context,
    RearDisplayConfigurationCubit cubit,
    RearDisplayConfigurationState state,
  ) {
    if (state is RearDisplayConfigurationStateSettingsFetched) {
      return Switch(
        value: state.isRearDisplayEnabled,
        onChanged: (bool value) {
          cubit.setRearDisplayState(value);
        },
      );
    } else if (state is RearDisplayConfigurationStateSettingsUpdateInProgress ||
        state is RearDisplayConfigurationStateLoading) {
      return const CircularProgressIndicator();
    } else if (state is RearDisplayConfigurationStateError) {
      return const Text("Service error");
    }
    return const SizedBox.shrink();
  }

  Widget _rearDisplayPrioritySwitch(
    BuildContext context,
    RearDisplayConfigurationCubit cubit,
    RearDisplayConfigurationState state,
  ) {
    if (state is RearDisplayConfigurationStateSettingsFetched) {
      return Switch(
        value: state.isRearDisplayPrioritised,
        onChanged: (bool value) {
          cubit.setRearDisplayPrioritization(value);
        },
      );
    } else if (state is RearDisplayConfigurationStateSettingsUpdateInProgress ||
        state is RearDisplayConfigurationStateLoading) {
      return const CircularProgressIndicator();
    } else if (state is RearDisplayConfigurationStateError) {
      return const Text("Service error");
    }
    return const SizedBox.shrink();
  }

  Widget _isPrimaryDisplaySwitch(
      BuildContext context,
      RearDisplayConfigurationCubit cubit,
      RearDisplayConfigurationState state,
      ) {
    if (state is RearDisplayConfigurationStateSettingsFetched) {
      return Switch(
        value: state.isCurrentDisplayPrimary,
        onChanged: (bool value) {
          cubit.setDisplayType(isCurrentDisplayPrimary: value);
        },
      );
    } else if (state is RearDisplayConfigurationStateSettingsUpdateInProgress ||
        state is RearDisplayConfigurationStateLoading) {
      return const CircularProgressIndicator();
    } else if (state is RearDisplayConfigurationStateError) {
      return const Text("Service error");
    }
    return const SizedBox.shrink();
  }
}
