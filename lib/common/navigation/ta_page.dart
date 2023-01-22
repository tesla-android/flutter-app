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
    route: "/home",
    type: TAPageType.standard,
  );

  static const releaseNotes = TAPage(
    title: "Release Notes",
    route: "/releaseNotes",
    type: TAPageType.standard,
  );

  static const donationDialog = TAPage(
    title: "Support the project",
    route: "/donate",
    type: TAPageType.dialog,
  );

  static List<TAPage> get availablePages {
    return const [empty, home, releaseNotes];
  }
}
