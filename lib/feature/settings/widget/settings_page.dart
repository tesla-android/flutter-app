import 'package:flutter/material.dart';
import 'package:tesla_android/common/navigation/ta_page.dart';
import 'package:tesla_android/common/ui/components/ta_app_bar.dart';
import 'package:tesla_android/common/ui/components/ta_bottom_navigation_bar.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:tesla_android/feature/settings/widget/display_settings.dart';
import 'package:tesla_android/feature/settings/widget/gps_settings.dart';
import 'package:tesla_android/feature/settings/widget/hotspot_settings.dart';
import 'package:tesla_android/feature/settings/widget/settings_section.dart';
import 'package:tesla_android/feature/settings/widget/sound_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _activeIndex = 0;

  late List<SettingsSection> _sections;

  @override
  void initState() {
    _sections = [
      const DisplaySettings(),
      const HotspotSettings(),
      const SoundSettings(),
      const GpsSettings(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TaAppBar(
        title: TAPage.settings.title,
      ),
      bottomNavigationBar: const TaBottomNavigationBar(
        currentIndex: 4,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NavigationDrawer(
            selectedIndex: _activeIndex,
            onDestinationSelected: (index) {
              setState(() {
                _activeIndex = index;
              });
            },
            children: [
              const SizedBox(
                height: TADimens.baseContentMargin,
              ),
              ..._sections
                  .map(
                    (section) => NavigationDrawerDestination(
                      icon: Icon(
                        section.icon,
                      ),
                      label: Text(
                        section.name,
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
          Expanded(
            child: IndexedStack(
              index: _activeIndex,
              children: _sections
            ),
          ),
        ],
      ),
    );
  }
}
