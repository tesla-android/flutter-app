import 'package:flutter/material.dart';
import 'package:tesla_android/common/ui/constants/ta_colors.dart';

/// A reusable slider widget for settings pages
///
/// Provides consistent styling and behavior across all settings sliders.
/// Includes a text label showing the current value.
class SettingsSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final int? divisions;
  final String label;
  final String suffix;

  const SettingsSlider({
    super.key,
    required this.value,
    required this.onChanged,
    required this.min,
    required this.max,
    this.divisions,
    required this.label,
    this.suffix = '',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          "$label$suffix",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: TAColors.settingsPrimaryColor,
          ),
        ),
        Slider(
          divisions: divisions,
          min: min,
          max: max,
          value: value,
          onChanged: onChanged,
          label: label,
        ),
      ],
    );
  }
}
