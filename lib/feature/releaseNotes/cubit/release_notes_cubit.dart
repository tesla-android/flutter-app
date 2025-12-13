import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tesla_android/feature/releaseNotes/cubit/release_notes_state.dart';
import 'package:tesla_android/feature/releaseNotes/model/changelog_item.dart';
import 'package:tesla_android/feature/releaseNotes/model/version.dart';
import 'package:tesla_android/feature/releaseNotes/repository/release_notes_repository.dart';

@injectable
class ReleaseNotesCubit extends Cubit<ReleaseNotesState> {
  final ReleaseNotesRepository _repository;

  ReleaseNotesCubit(this._repository) : super(ReleaseNotesStateInitial());

  void loadReleaseNotes() async {
    emit(ReleaseNotesStateLoading());
    try {
      final releaseNotes = await _repository.getReleaseNotes();
      emit(ReleaseNotesStateLoaded(releaseNotes: releaseNotes));
    } catch (error) {
      emit(ReleaseNotesStateUnavailable());
    }
  }

  void updateSelection({
    required Version version,
    required ChangelogItem changelogItem,
  }) {
    if (state is ReleaseNotesStateLoaded) {
      final releaseNotes = (state as ReleaseNotesStateLoaded).releaseNotes;
      emit(
        ReleaseNotesStateLoaded.withSelection(
          releaseNotes: releaseNotes,
          selectedVersion: version,
          selectedChangelogItem: changelogItem,
        ),
      );
    }
  }
}
