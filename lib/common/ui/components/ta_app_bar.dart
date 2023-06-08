import 'dart:html';

import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:url_launcher/url_launcher.dart';

class TaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  const TaAppBar({super.key, this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: Text(title ?? ''),
      actions: [
        if (window.location.hostname?.contains("teslaandroid.com") ?? true)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => theme.primaryColor),
              ),
              onPressed: () {
                Widget okButton = TextButton(
                  child: const Text("Understood"),
                  onPressed: () {
                    window.location.href = "http://fullscreen.app.teslaandroid.com";
                  },
                );
                Widget cancelButton = TextButton(
                  child: const Text("Dismiss"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                );
                AlertDialog alert = AlertDialog(
                  title: const Text("Are you in Park?"),
                  content:
                      const Text("Full-Screen App is not available in Drive."),
                  actions: [
                    okButton,
                    cancelButton
                  ],
                );
                // show the dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  },
                );
              },
              child: Row(
                children: const [
                  Text(
                    "Go Full-Screen",
                    style: TextStyle(
                      color: Colors.red,
                        fontWeight: FontWeight.bold,
                        height: 1.15),
                  ),
                  SizedBox(
                    width: TADimens.PADDING_S_VALUE,
                  ),
                  Icon(
                    Icons.fullscreen,
                    size: 35,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          )
      ],
    );
  }
}
