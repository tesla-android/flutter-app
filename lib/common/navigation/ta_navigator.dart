import 'package:flutter/material.dart';
import 'package:tesla_android/common/di/ta_locator.dart';
import 'package:tesla_android/common/navigation/ta_page.dart';
import 'package:tesla_android/common/navigation/ta_page_factory.dart';
import 'package:tesla_android/common/navigation/ta_page_type.dart';

class TANavigator {
  static TAPageFactory get _pageFactory => getIt<TAPageFactory>();

  static Future push({
    required BuildContext context,
    required TAPage page,
  }) {
    switch (page.type) {
      case TAPageType.standard:
        return Navigator.of(context).pushNamed(page.route);
      case TAPageType.dialog:
        return _pushDialog(context: context, page: page);
    }
  }

  static Future _pushDialog({
    required BuildContext context,
    required TAPage page,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return _pageFactory.buildPage(page).call(context);
      },
    );
  }

  static void pushReplacement({
    required BuildContext context,
    required TAPage page,
  }) {
    if (page.type != TAPageType.standard) {
      throw UnsupportedError("only regular pages can be used in pushReplacement");
    }
    Navigator.of(context).pushReplacementNamed(page.route);
  }

  static void pop({
    required BuildContext context,
  }) {
    Navigator.of(context).pop();
  }
}
