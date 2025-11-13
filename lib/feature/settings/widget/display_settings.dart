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
    : super(name: "Display", icon: Icons.monitor);

  @override
  Widget body(BuildContext context) {
    final cubit = BlocProvider.of<DisplayConfigurationCubit>(context);

    return BlocBuilder<DisplayConfigurationCubit, DisplayConfigurationState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsTile(
              icon: Icons.texture,
              title: 'Renderer',
              dense: false,
              trailing: _rendererDropdown(context, cubit, state),
            ),
            const Padding(
              padding: EdgeInsets.all(TADimens.PADDING_S_VALUE),
              child: Text(
                'Tesla Android supports both h264 and MJPEG display compression. MJPEG has less visible compression artifacts but needs much more bandwidth.\n\nNOTE: H264 may not work if your car is running Tesla Firmware older than 2025.32.',
              ),
            ),
            divider,
            SettingsTile(
              icon: Icons.display_settings,
              title: 'Resolution',
              trailing: _resolutionDropdown(context, cubit, state),
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
              trailing: _qualityDropdown(context, cubit, state),
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
              trailing: _refreshRateDropdown(context, cubit, state),
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
              trailing: _responsivenessSwitch(context, cubit, state),
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

  Widget _responsivenessSwitch(
    BuildContext context,
    DisplayConfigurationCubit cubit,
    DisplayConfigurationState state,
  ) {
    if (state is DisplayConfigurationStateSettingsFetched) {
      return Switch(
        value: state.isResponsive,
        onChanged: (bool value) {
          cubit.setResponsiveness(value);
          _showConfigurationChangedBanner(context);
        },
      );
    } else if (state is DisplayConfigurationStateSettingsUpdateInProgress ||
        state is DisplayConfigurationStateLoading) {
      return const CircularProgressIndicator();
    } else if (state is DisplayConfigurationStateError) {
      return const Text("Service error");
    }
    return const SizedBox.shrink();
  }

  Widget _resolutionDropdown(
    BuildContext context,
    DisplayConfigurationCubit cubit,
    DisplayConfigurationState state,
  ) {
    if (state is DisplayConfigurationStateSettingsFetched) {
      return DropdownButton<DisplayResolutionModePreset>(
        value: state.resolutionPreset,
        icon: const Icon(Icons.arrow_drop_down_outlined),
        underline: Container(height: 2, color: Theme.of(context).primaryColor),
        onChanged: (DisplayResolutionModePreset? value) {
          if (value != null) {
            cubit.setResolution(value);
            _showConfigurationChangedBanner(context);
          }
        },
        items: DisplayResolutionModePreset.values
            .map<DropdownMenuItem<DisplayResolutionModePreset>>((
              DisplayResolutionModePreset value,
            ) {
              return DropdownMenuItem<DisplayResolutionModePreset>(
                value: value,
                child: Text(value.name()),
              );
            })
            .toList(),
      );
    } else if (state is DisplayConfigurationStateSettingsUpdateInProgress ||
        state is DisplayConfigurationStateLoading) {
      return const CircularProgressIndicator();
    } else if (state is DisplayConfigurationStateError) {
      return const Text("Service error");
    }
    return const SizedBox.shrink();
  }

  Widget _qualityDropdown(
    BuildContext context,
    DisplayConfigurationCubit cubit,
    DisplayConfigurationState state,
  ) {
    if (state is DisplayConfigurationStateSettingsFetched) {
      return DropdownButton<DisplayQualityPreset>(
        value: state.quality,
        icon: const Icon(Icons.arrow_drop_down_outlined),
        underline: Container(height: 2, color: Theme.of(context).primaryColor),
        onChanged: (DisplayQualityPreset? value) {
          if (value != null) {
            cubit.setQuality(value);
            _showConfigurationChangedBanner(context);
          }
        },
        items: DisplayQualityPreset.values.map((value) {
          return DropdownMenuItem<DisplayQualityPreset>(
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

  Widget _refreshRateDropdown(
    BuildContext context,
    DisplayConfigurationCubit cubit,
    DisplayConfigurationState state,
  ) {
    if (state is DisplayConfigurationStateSettingsFetched) {
      return DropdownButton<DisplayRefreshRatePreset>(
        value: state.refreshRate,
        icon: const Icon(Icons.arrow_drop_down_outlined),
        underline: Container(height: 2, color: Theme.of(context).primaryColor),
        onChanged: (DisplayRefreshRatePreset? value) {
          if (value != null) {
            cubit.setRefreshRate(value);
            _showConfigurationChangedBanner(context);
          }
        },
        items: DisplayRefreshRatePreset.values.map((value) {
          return DropdownMenuItem<DisplayRefreshRatePreset>(
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

  Widget _rendererDropdown(
    BuildContext context,
    DisplayConfigurationCubit cubit,
    DisplayConfigurationState state,
  ) {
    if (state is DisplayConfigurationStateSettingsFetched) {
      return DropdownButton<bool>(
        value: state.isH264,
        icon: const Icon(Icons.arrow_drop_down_outlined),
        underline: Container(height: 2, color: Theme.of(context).primaryColor),
        onChanged: (bool? value) {
          if (value != null) {
            cubit.setRenderer(value);
            _showConfigurationChangedBanner(context);
          }
        },
        items: [true, false]
            .map<DropdownMenuItem<bool>>((
              bool value,
            ) {
              return DropdownMenuItem<bool>(
                value: value,
                child: Text(value == true ? "h264" : "MJPEG"),
              );
            })
            .toList(),
      );
    } else if (state is DisplayConfigurationStateSettingsUpdateInProgress ||
        state is DisplayConfigurationStateLoading) {
      return const CircularProgressIndicator();
    } else if (state is DisplayConfigurationStateError) {
      return const Text("Service error");
    }
    return const SizedBox.shrink();
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
