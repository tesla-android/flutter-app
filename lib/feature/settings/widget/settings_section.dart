import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';

abstract class SettingsSection extends StatelessWidget {
  final String name;
  final IconData icon;

  const SettingsSection({
    super.key,
    required this.name,
    required this.icon,
  });

  @nonVirtual
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Scrollbar(
        child: Padding(
          padding: const EdgeInsets.all(
            TADimens.baseContentMargin,
          ),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: TADimens.settingsPageTableMaxWidth,
              ),
              child: body(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget body(BuildContext context);

  Widget get divider => const Padding(
        padding: EdgeInsets.symmetric(
          vertical: TADimens.baseContentMargin,
        ),
        child: Divider(),
      );
}
