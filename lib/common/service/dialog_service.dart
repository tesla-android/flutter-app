import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

/// Service for handling dialogs and banners
///
/// Wraps Flutter's dialog and scaffold messenger methods to allow for mocking in tests.
@singleton
class DialogService {
  /// Shows a material banner
  void showMaterialBanner({
    required BuildContext context,
    required MaterialBanner banner,
  }) {
    ScaffoldMessenger.of(context).showMaterialBanner(banner);
  }

  /// Clears all material banners
  void clearMaterialBanners({required BuildContext context}) {
    ScaffoldMessenger.of(context).clearMaterialBanners();
  }

  /// Shows a general dialog
  Future<T?> showDialog<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      builder: builder,
      barrierDismissible: barrierDismissible,
    );
  }
}
