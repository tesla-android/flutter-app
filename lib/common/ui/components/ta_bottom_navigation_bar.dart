import 'package:flutter/material.dart';
import 'package:tesla_android/common/navigation/ta_navigator.dart';
import 'package:tesla_android/common/navigation/ta_page.dart';
import 'package:tesla_android/common/utils/logger.dart';

class TaBottomNavigationBar extends StatelessWidget with Logger {
  final int currentIndex;

  const TaBottomNavigationBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.android),
          label: 'Android OS',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info_outlined),
          label: 'About',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notes),
          label: 'Release Notes',
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on), label: "Donations"),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: currentIndex,
      onTap: (index) {
        final page = _getPageForIndex(index);
        if(page == null) {
          return;
        }
        dispatchAnalyticsEvent(
          eventName: "bottom_navigation_tab_changed",
          props: {"route": page.route, "title": page.title},
        );
        TANavigator.pushReplacement(
            context: context, page: page, animated: index == 0);
      },
    );
  }

  TAPage? _getPageForIndex(int index) {
    switch (index) {
      case 0:
        return TAPage.home;
      case 1:
        return TAPage.about;
      case 2:
        return TAPage.releaseNotes;
      case 3:
        return TAPage.donations;
      case 4:
        return TAPage.settings;
      default:
        return null;
    }
  }
}
