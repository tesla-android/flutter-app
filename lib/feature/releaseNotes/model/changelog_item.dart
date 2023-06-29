import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'changelog_item.g.dart';

@JsonSerializable()
class ChangelogItem extends Equatable {
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
  List<Object?> get props => [
        title,
        shortDescription,
        descriptionMarkdown,
      ];
}
