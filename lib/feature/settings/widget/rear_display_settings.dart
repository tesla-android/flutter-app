import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/common/ui/components/settings_switch.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:tesla_android/feature/settings/bloc/rear_display_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/rear_display_configuration_state.dart';
import 'package:tesla_android/feature/settings/view_model/rear_display_settings_view_model.dart';
import 'package:tesla_android/feature/settings/widget/settings_section.dart';
import 'package:tesla_android/feature/settings/widget/settings_tile.dart';

class RearDisplaySettings extends SettingsSection {
  const RearDisplaySettings({super.key})
    : super(name: "Rear Display", icon: Icons.tv);

  @override
  Widget body(BuildContext context) {
    final cubit = BlocProvider.of<RearDisplayConfigurationCubit>(context);
    final viewModel = RearDisplaySettingsViewModel();

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
              trailing: viewModel.buildStateWidget(
                state: state,
                onFetched: () {
                  final isEnabled = viewModel.getRearDisplayEnabled(state);
                  if (isEnabled == null) return const SizedBox.shrink();

                  return SettingsSwitch(
                    value: isEnabled,
                    onChanged: (value) {
                      cubit.setRearDisplayState(value);
                    },
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(TADimens.PADDING_S_VALUE),
              child: Text(
                'Enable if your vehicle is equipped with a factory rear display.\\n\\n'
                'Supported models:\\n\\n'
                '- Model 3 (2023+ / "Highland")\\n'
                '- Model Y (2025+ / "Juniper")\\n'
                '- Model S/X (2021+)\\n'
                '- Cybertruck',
              ),
            ),
            if (state is RearDisplayConfigurationStateSettingsFetched &&
                state.isRearDisplayEnabled) ...[
              divider,
              SettingsTile(
                icon: Icons.screenshot_monitor,
                title: 'Primary Display',
                trailing: viewModel.buildStateWidget(
                  state: state,
                  onFetched: () {
                    final isPrimary = viewModel.getCurrentDisplayPrimary(state);
                    if (isPrimary == null) return const SizedBox.shrink();

                    return SettingsSwitch(
                      value: isPrimary,
                      onChanged: (value) {
                        cubit.setDisplayType(isCurrentDisplayPrimary: value);
                      },
                    );
                  },
                ),
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
                trailing: viewModel.buildStateWidget(
                  state: state,
                  onFetched: () {
                    final isPrioritised = viewModel.getRearDisplayPrioritised(
                      state,
                    );
                    if (isPrioritised == null) return const SizedBox.shrink();

                    return SettingsSwitch(
                      value: isPrioritised,
                      onChanged: (value) {
                        cubit.setRearDisplayPrioritization(value);
                      },
                    );
                  },
                ),
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
}
