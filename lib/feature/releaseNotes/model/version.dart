import 'package:tesla_android/feature/releaseNotes/model/changelog_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'version.g.dart';

@JsonSerializable()
class Version {
  final String versionName;
  final List<ChangelogItem> changelogItems;

  const Version({required this.versionName, required this.changelogItems});

  factory Version.fromJson(Map<String, dynamic> json) =>
      _$VersionFromJson(json);

  Map<String, dynamic> toJson() => _$VersionToJson(this);
}
