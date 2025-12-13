import 'package:json_annotation/json_annotation.dart';
import 'package:tesla_android/feature/releaseNotes/model/version.dart';

part 'release_notes.g.dart';

@JsonSerializable()
class ReleaseNotes {
  final List<Version> versions;

  const ReleaseNotes({required this.versions});

  factory ReleaseNotes.fromJson(Map<String, dynamic> json) =>
      _$ReleaseNotesFromJson(json);

  Map<String, dynamic> toJson() => _$ReleaseNotesToJson(this);
}
