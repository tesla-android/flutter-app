import 'package:tesla_android/feature/releaseNotes/model/changelog_item.dart';
import 'package:tesla_android/feature/releaseNotes/model/release_notes.dart';
import 'package:tesla_android/feature/releaseNotes/model/version.dart';

abstract class ReleaseNotesState {}

class ReleaseNotesStateInitial extends ReleaseNotesState {}

class ReleaseNotesStateLoading extends ReleaseNotesState {}

class ReleaseNotesStateUnavailable extends ReleaseNotesState {}

class ReleaseNotesStateLoaded extends ReleaseNotesState {
  final ReleaseNotes releaseNotes;
  final Version selectedVersion;
  final ChangelogItem selectedChangelogItem;

  ReleaseNotesStateLoaded({required this.releaseNotes})
    : selectedVersion = releaseNotes.versions.first,
      selectedChangelogItem = releaseNotes.versions.first.changelogItems.first;

  ReleaseNotesStateLoaded.withSelection({
    required this.releaseNotes,
    required this.selectedVersion,
    required this.selectedChangelogItem,
  });
}
