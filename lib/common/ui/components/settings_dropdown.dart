import 'package:flutter/material.dart';

/// A reusable dropdown widget for settings pages
///
/// Provides consistent styling and behavior across all settings dropdowns.
/// Type-safe with generics.
class SettingsDropdown<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String Function(T) itemLabel;
  final Color? underlineColor;

  const SettingsDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.itemLabel,
    this.underlineColor,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      value: value,
      icon: const Icon(Icons.arrow_drop_down_outlined),
      underline: Container(
        height: 2,
        color: underlineColor ?? Theme.of(context).primaryColor,
      ),
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<T>>((T item) {
        return DropdownMenuItem<T>(value: item, child: Text(itemLabel(item)));
      }).toList(),
    );
  }
}

/// Extension for display enums to provide readable names
extension DisplayRendererTypeExt on Object {
  String displayName() {
    if (this is Enum) {
      final enumValue = this as Enum;
      // Check if the enum has a name() method
      try {
        return (this as dynamic).name();
      } catch (e) {
        // Fallback to enum name
        return enumValue.name;
      }
    }
    return toString();
  }
}
