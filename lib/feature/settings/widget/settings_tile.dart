import 'package:flutter/material.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget trailing;
  final bool dense;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.trailing,
    this.dense = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : const SizedBox.shrink(),
      trailing: SizedBox(
          width: dense ? TADimens.settingsTileTrailingWidthDense : TADimens
              .settingsTileTrailingWidth,
          child: Row(
            children: [
              const Spacer(),
              trailing,
            ],
          )),
    );
  }
}
