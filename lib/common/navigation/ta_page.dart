import 'package:tesla_android/common/navigation/ta_page_type.dart';

class TAPage {
  final String title;
  final String route;
  final TAPageType type;

  const TAPage({
    required this.title,
    required this.route,
    required this.type,
  });

  static const empty = TAPage(
    title: "Empty",
    route: "/empty",
    type: TAPageType.standard,
  );

  static const home = TAPage(
    title: "Home",
    route: "/",
    type: TAPageType.standard,
  );

  static const releaseNotes = TAPage(
    title: "Release Notes",
    route: "/releaseNotes",
    type: TAPageType.standard,
  );

  static const donations = TAPage(
    title: "Donations",
    route: "/donate",
    type: TAPageType.standard,
  );

  static const about = TAPage(
    title: "About",
    route: "/about",
    type: TAPageType.standard,
  );

  static const settings = TAPage(
    title: "Settings",
    route: "/settings",
    type: TAPageType.standard,
  );

  static List<TAPage> get availablePages {
    return const [empty, home, releaseNotes, about, settings];
  }
}
