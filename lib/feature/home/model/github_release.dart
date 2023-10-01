import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'github_release.g.dart';

@JsonSerializable()
class GitHubRelease extends Equatable {
  final String name;

  const GitHubRelease({
    required this.name,
  });

  factory GitHubRelease.fromJson(Map<String, dynamic> json) =>
      _$GitHubReleaseFromJson(json);

  Map<String, dynamic> toJson() => _$GitHubReleaseToJson(this);

  @override
  List<Object?> get props => [
        name,
      ];
}
