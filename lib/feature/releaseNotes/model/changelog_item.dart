import 'package:json_annotation/json_annotation.dart';

part 'changelog_item.g.dart';

@JsonSerializable()
class ChangelogItem {
  final String title;
  final String shortDescription;
  final String descriptionMarkdown;

  const ChangelogItem({
    required this.title,
    required this.shortDescription,
    required this.descriptionMarkdown,
  });

  factory ChangelogItem.fromJson(Map<String, dynamic> json) =>
      _$ChangelogItemFromJson(json);

  Map<String, dynamic> toJson() => _$ChangelogItemToJson(this);

  @override
  bool operator ==(Object other) {
    return (other is ChangelogItem) &&
        title == other.title &&
        shortDescription == other.shortDescription &&
        descriptionMarkdown == other.descriptionMarkdown;
  }

  @override
  int get hashCode => Object.hashAll([
        title,
        shortDescription,
        descriptionMarkdown,
      ]);
}
