// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'changelog_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangelogItem _$ChangelogItemFromJson(Map<String, dynamic> json) =>
    ChangelogItem(
      title: json['title'] as String,
      shortDescription: json['shortDescription'] as String,
      descriptionMarkdown: json['descriptionMarkdown'] as String,
    );

Map<String, dynamic> _$ChangelogItemToJson(ChangelogItem instance) =>
    <String, dynamic>{
      'title': instance.title,
      'shortDescription': instance.shortDescription,
      'descriptionMarkdown': instance.descriptionMarkdown,
    };
