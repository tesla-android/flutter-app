import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:tesla_android/feature/releaseNotes/cubit/release_notes_cubit.dart';
import 'package:tesla_android/feature/releaseNotes/cubit/release_notes_state.dart';
import 'package:tesla_android/feature/releaseNotes/model/changelog_item.dart';
import 'package:tesla_android/feature/releaseNotes/model/release_notes.dart';
import 'package:tesla_android/feature/releaseNotes/model/version.dart';
import 'package:tesla_android/feature/releaseNotes/repository/release_notes_repository.dart';

import 'release_notes_cubit_test.mocks.dart';

@GenerateMocks([ReleaseNotesRepository])
void main() {
  late MockReleaseNotesRepository mockRepository;

  final testChangelogItem = ChangelogItem(
    title: 'Test Feature',
    shortDescription: 'Description',
    descriptionMarkdown: 'Markdown',
  );

  final testVersion = Version(
    versionName: '1.0.0',
    changelogItems: [testChangelogItem],
  );

  final testReleaseNotes = ReleaseNotes(versions: [testVersion]);

  setUp(() {
    mockRepository = MockReleaseNotesRepository();
  });

  group('ReleaseNotesCubit', () {
    test('initial state is ReleaseNotesStateInitial', () {
      final cubit = ReleaseNotesCubit(mockRepository);
      expect(cubit.state, isA<ReleaseNotesStateInitial>());
      cubit.close();
    });

    blocTest<ReleaseNotesCubit, ReleaseNotesState>(
      'loadReleaseNotes emits Loading then Loaded on success',
      build: () {
        when(
          mockRepository.getReleaseNotes(),
        ).thenAnswer((_) async => testReleaseNotes);
        return ReleaseNotesCubit(mockRepository);
      },
      act: (cubit) => cubit.loadReleaseNotes(),
      expect: () => [
        isA<ReleaseNotesStateLoading>(),
        isA<ReleaseNotesStateLoaded>().having(
          (s) => s.releaseNotes,
          'releaseNotes',
          testReleaseNotes,
        ),
      ],
      verify: (cubit) {
        verify(mockRepository.getReleaseNotes()).called(1);
      },
    );

    blocTest<ReleaseNotesCubit, ReleaseNotesState>(
      'loadReleaseNotes emits Loading then Unavailable on failure',
      build: () {
        when(
          mockRepository.getReleaseNotes(),
        ).thenThrow(Exception('Network error'));
        return ReleaseNotesCubit(mockRepository);
      },
      act: (cubit) => cubit.loadReleaseNotes(),
      expect: () => [
        isA<ReleaseNotesStateLoading>(),
        isA<ReleaseNotesStateUnavailable>(),
      ],
    );

    blocTest<ReleaseNotesCubit, ReleaseNotesState>(
      'updateSelection updates state when loaded',
      build: () {
        when(
          mockRepository.getReleaseNotes(),
        ).thenAnswer((_) async => testReleaseNotes);
        return ReleaseNotesCubit(mockRepository);
      },
      seed: () => ReleaseNotesStateLoaded(releaseNotes: testReleaseNotes),
      act: (cubit) => cubit.updateSelection(
        version: testVersion,
        changelogItem: testChangelogItem,
      ),
      expect: () => [
        isA<ReleaseNotesStateLoaded>()
            .having((s) => s.selectedVersion, 'selectedVersion', testVersion)
            .having(
              (s) => s.selectedChangelogItem,
              'selectedChangelogItem',
              testChangelogItem,
            ),
      ],
    );

    blocTest<ReleaseNotesCubit, ReleaseNotesState>(
      'updateSelection does nothing when not loaded',
      build: () => ReleaseNotesCubit(mockRepository),
      seed: () => ReleaseNotesStateInitial(),
      act: (cubit) => cubit.updateSelection(
        version: testVersion,
        changelogItem: testChangelogItem,
      ),
      expect: () => [],
    );
  });
}
