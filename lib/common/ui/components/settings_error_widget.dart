import 'package:flutter/material.dart';
import 'package:tesla_android/common/ui/constants/ta_colors.dart';

/// Standardized error widget for settings pages
///
/// Provides consistent error display across all settings widgets
/// with optional retry functionality.
class SettingsErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  const SettingsErrorWidget({
    super.key,
    this.message = 'Service error',
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  /// Factory constructor for common "fetch error" scenario
  factory SettingsErrorWidget.fetchError({VoidCallback? onRetry}) {
    return SettingsErrorWidget(
      message: 'Failed to load settings',
      onRetry: onRetry,
      icon: Icons.cloud_off,
    );
  }

  /// Factory constructor for common "save error" scenario
  factory SettingsErrorWidget.saveError({VoidCallback? onRetry}) {
    return SettingsErrorWidget(
      message: 'Failed to save settings',
      onRetry: onRetry,
      icon: Icons.save_outlined,
    );
  }

  /// Factory constructor for common "connection error" scenario
  factory SettingsErrorWidget.connectionError({VoidCallback? onRetry}) {
    return SettingsErrorWidget(
      message: 'Connection lost',
      onRetry: onRetry,
      icon: Icons.wifi_off,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (onRetry == null) {
      // Simple inline error text (backward compatible)
      return Text(message, style: TextStyle(color: TAColors.errorColor));
    }

    // Full error widget with retry button
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: TAColors.errorColor),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: TAColors.errorColor, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
