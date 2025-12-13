import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/common/ui/components/settings_dropdown.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:tesla_android/feature/display/model/remote_display_state.dart';
import 'package:tesla_android/feature/settings/bloc/display_configuration_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/display_configuration_state.dart';
import 'package:tesla_android/feature/settings/view_model/display_settings_view_model.dart';
import 'package:tesla_android/feature/settings/widget/settings_section.dart';
import 'package:tesla_android/feature/settings/widget/settings_tile.dart';

class DisplaySettings extends SettingsSection {
  const DisplaySettings({super.key})
    : super(name: "Display", icon: Icons.monitor);

  @override
  Widget body(BuildContext context) {
    final cubit = BlocProvider.of<DisplayConfigurationCubit>(context);
    final viewModel = DisplaySettingsViewModel();

    return BlocBuilder<DisplayConfigurationCubit, DisplayConfigurationState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsTile(
              icon: Icons.texture,
              title: 'Renderer',
              dense: false,
              trailing: _buildDropdown<DisplayRendererType>(
                context: context,
                cubit: cubit,
                state: state,
                viewModel: viewModel,
                getValue: viewModel.getRenderer,
                items: DisplayRendererType.values,
                onChanged: (value) {
                  cubit.setRenderer(value!);
                  _showConfigurationChangedBanner(context);
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(TADimens.PADDING_S_VALUE),
              child: Text(
                'Tesla Android supports both h264 and MJPEG display compression. MJPEG has less visible compression artifacts but needs much more bandwidth.\n\nNOTE: WebCodecs may not work if your car is running Tesla Firmware older than 2025.32.',
              ),
            ),
            divider,
            SettingsTile(
              icon: Icons.display_settings,
              title: 'Resolution',
              trailing: _buildDropdown<DisplayResolutionModePreset>(
                context: context,
                cubit: cubit,
                state: state,
                viewModel: viewModel,
                getValue: viewModel.getResolutionPreset,
                items: DisplayResolutionModePreset.values,
                onChanged: (value) {
                  cubit.setResolution(value!);
                  _showConfigurationChangedBanner(context);
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(TADimens.PADDING_S_VALUE),
              child: Text(
                'Choosing a low resolution improves the display performance in Drive. It reduces the browser load, meant for cars equipped with MCU2. Resolutions lower than 720p only work with the MJPEG renderer.',
              ),
            ),
            divider,
            SettingsTile(
              icon: Icons.photo_size_select_actual_outlined,
              title: 'Image quality',
              trailing: _buildDropdown<DisplayQualityPreset>(
                context: context,
                cubit: cubit,
                state: state,
                viewModel: viewModel,
                getValue: viewModel.getQualityPreset,
                items: DisplayQualityPreset.values,
                onChanged: (value) {
                  cubit.setQuality(value!);
                  _showConfigurationChangedBanner(context);
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(TADimens.PADDING_S_VALUE),
              child: Text(
                'Reducing the image quality can significantly improve performance when a higher resolution is used.',
              ),
            ),
            divider,
            SettingsTile(
              icon: Icons.monitor,
              title: 'Refresh rate',
              trailing: _buildDropdown<DisplayRefreshRatePreset>(
                context: context,
                cubit: cubit,
                state: state,
                viewModel: viewModel,
                getValue: viewModel.getRefreshRate,
                items: DisplayRefreshRatePreset.values,
                onChanged: (value) {
                  cubit.setRefreshRate(value!);
                  _showConfigurationChangedBanner(context);
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(TADimens.PADDING_S_VALUE),
              child: Text(
                'By default Tesla Android is running in 30Hz. You can increase the frame rate with this setting. This feature is experimental.',
              ),
            ),
            divider,
            SettingsTile(
              icon: Icons.photo_size_select_large,
              title: 'Dynamic aspect ratio',
              trailing: _responsivenessSwitch(context, cubit, state, viewModel),
            ),
            const Padding(
              padding: EdgeInsets.all(TADimens.PADDING_S_VALUE),
              child: Text(
                'Advanced setting, Tesla Android can automatically resize the virtual display when the browser window size changes. If you disable this option, the display aspect will be locked on the current value.',
              ),
            ),
          ],
        );
      },
    );
  }

  /// Generic dropdown builder using view model and reusable component
  Widget _buildDropdown<T>({
    required BuildContext context,
    required DisplayConfigurationCubit cubit,
    required DisplayConfigurationState state,
    required DisplaySettingsViewModel viewModel,
    required T? Function(DisplayConfigurationState) getValue,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return viewModel.buildStateWidget(
      state: state,
      onFetched: () {
        final value = getValue(state);
        if (value == null) return const SizedBox.shrink();

        return SettingsDropdown<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          itemLabel: (item) => (item as dynamic).name(),
          underlineColor: Theme.of(context).primaryColor,
        );
      },
    );
  }

  Widget _responsivenessSwitch(
    BuildContext context,
    DisplayConfigurationCubit cubit,
    DisplayConfigurationState state,
    DisplaySettingsViewModel viewModel,
  ) {
    return viewModel.buildStateWidget(
      state: state,
      onFetched: () {
        final isResponsive = viewModel.getResponsiveness(state);
        if (isResponsive == null) return const SizedBox.shrink();

        return Switch(
          value: isResponsive,
          onChanged: (bool value) {
            cubit.setResponsiveness(value);
            _showConfigurationChangedBanner(context);
          },
        );
      },
    );
  }

  void _showConfigurationChangedBanner(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Reboot device'),
          content: const Text(
            'Display configuration has been updated. Please restart the device in case of any issues.',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Understood'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
