// ignore: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
import 'package:tesla_android/common/utils/logger.dart';

class TaAppBar extends StatelessWidget
    with Logger
    implements PreferredSizeWidget {
  final String? title;

  const TaAppBar({super.key, this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: Text(title ?? ''),
    );
  }
}
