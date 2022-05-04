import 'package:tesla_android/view/releaseNotes/model/changelog_item.dart';

class VersionListItem {
  final String versionName;
  final List<ChangelogItem> changelogItems;

  const VersionListItem({
    required this.versionName,
    required this.changelogItems,
  });
}
