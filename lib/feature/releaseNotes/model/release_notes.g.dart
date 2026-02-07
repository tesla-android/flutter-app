// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'release_notes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReleaseNotes _$ReleaseNotesFromJson(Map<String, dynamic> json) => ReleaseNotes(
      versions: (json['versions'] as List<dynamic>)
          .map((e) => Version.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReleaseNotesToJson(ReleaseNotes instance) =>
    <String, dynamic>{
      'versions': instance.versions,
    };
