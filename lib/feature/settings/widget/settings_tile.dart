import 'package:flutter/material.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool dense;
  final Widget trailing;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.dense = true,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : const SizedBox.shrink(),
      trailing: SizedBox(
          width: dense ? TADimens.settingsTileTrailingTightWidth : TADimens.settingsTileTrailingWidth,
          child: Row(
            children: [
              const Spacer(),
              trailing,
            ],
          )),
    );
  }
}
