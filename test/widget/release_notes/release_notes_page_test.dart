import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tesla_android/feature/releaseNotes/cubit/release_notes_cubit.dart';
import 'package:tesla_android/feature/releaseNotes/cubit/release_notes_state.dart';
import 'package:tesla_android/feature/releaseNotes/model/changelog_item.dart';
import 'package:tesla_android/feature/releaseNotes/model/release_notes.dart';
import 'package:tesla_android/feature/releaseNotes/model/version.dart';
import 'package:tesla_android/feature/releaseNotes/widget/release_notes_page.dart';

import '../../helpers/mock_cubits.mocks.dart';

void main() {
  late MockReleaseNotesCubit mockReleaseNotesCubit;

  setUp(() {
    mockReleaseNotesCubit = MockReleaseNotesCubit();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<ReleaseNotesCubit>.value(
        value: mockReleaseNotesCubit,
        child: const ReleaseNotesPage(),
      ),
    );
  }

  testWidgets('ReleaseNotesPage shows loading indicator when loading', (
    tester,
  ) async {
    when(mockReleaseNotesCubit.state).thenReturn(ReleaseNotesStateLoading());
    when(mockReleaseNotesCubit.stream).thenAnswer((_) => const Stream.empty());
    when(mockReleaseNotesCubit.loadReleaseNotes()).thenAnswer((_) async {});

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('ReleaseNotesPage shows error message when unavailable', (
    tester,
  ) async {
    when(
      mockReleaseNotesCubit.state,
    ).thenReturn(ReleaseNotesStateUnavailable());
    when(mockReleaseNotesCubit.stream).thenAnswer((_) => const Stream.empty());
    when(mockReleaseNotesCubit.loadReleaseNotes()).thenAnswer((_) async {});

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(
      find.text('Error loading release notes. Please try again later.'),
      findsOneWidget,
    );
  });

  testWidgets('ReleaseNotesPage shows release notes when loaded', (
    tester,
  ) async {
    final testReleaseNotes = ReleaseNotes(
      versions: [
        Version(
          versionName: '1.0.0',
          changelogItems: [
            ChangelogItem(
              title: 'Features',
              shortDescription: 'Test feature',
              descriptionMarkdown: '# Test feature\n\nThis is a test feature.',
            ),
          ],
        ),
      ],
    );

    when(
      mockReleaseNotesCubit.state,
    ).thenReturn(ReleaseNotesStateLoaded(releaseNotes: testReleaseNotes));
    when(mockReleaseNotesCubit.stream).thenAnswer((_) => const Stream.empty());
    when(mockReleaseNotesCubit.loadReleaseNotes()).thenAnswer((_) async {});

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('1.0.0'), findsWidgets);
    expect(find.text('Features'), findsOneWidget);
  });
}
