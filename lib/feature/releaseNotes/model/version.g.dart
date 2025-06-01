// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Version _$VersionFromJson(Map<String, dynamic> json) => Version(
  versionName: json['versionName'] as String,
  changelogItems: (json['changelogItems'] as List<dynamic>)
      .map((e) => ChangelogItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$VersionToJson(Version instance) => <String, dynamic>{
  'versionName': instance.versionName,
  'changelogItems': instance.changelogItems,
};
