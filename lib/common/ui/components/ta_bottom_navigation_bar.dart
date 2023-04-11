import 'package:flutter/material.dart';
import 'package:tesla_android/common/navigation/ta_navigator.dart';
import 'package:tesla_android/common/navigation/ta_page.dart';

class TaBottomNavigationBar extends StatelessWidget {
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
        switch (index) {
          case 0:
            TANavigator.pushReplacement(
                context: context, page: TAPage.home, animated: true);
            break;
          case 1:
            TANavigator.pushReplacement(
                context: context, page: TAPage.about, animated: false);
            break;
          case 2:
            TANavigator.pushReplacement(
                context: context, page: TAPage.releaseNotes, animated: false);
            break;
          case 3:
            TANavigator.pushReplacement(
                context: context, page: TAPage.donations, animated: false);
            break;
          case 4:
            TANavigator.pushReplacement(
                context: context, page: TAPage.settings, animated: false);
            break;
        }
      },
    );
  }
}
