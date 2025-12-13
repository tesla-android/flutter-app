import 'package:flutter/material.dart';

/// A reusable switch widget for settings pages
///
/// Provides consistent styling and behavior across all settings switches.
class SettingsSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  const SettingsSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Switch(value: value, onChanged: enabled ? onChanged : null);
  }
}
