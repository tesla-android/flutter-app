import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/common/navigation/ta_page.dart';
import 'package:tesla_android/common/ui/components/ta_bottom_navigation_bar.dart';
import 'package:tesla_android/feature/releaseNotes/cubit/release_notes_cubit.dart';
import 'package:tesla_android/feature/releaseNotes/cubit/release_notes_state.dart';
import 'package:tesla_android/feature/releaseNotes/model/changelog_item.dart';
import 'package:tesla_android/feature/releaseNotes/model/release_notes.dart';
import 'package:tesla_android/feature/releaseNotes/model/version.dart';
import 'package:tesla_android/feature/releaseNotes/widget/detail/release_notes_changelog_item_details_view.dart';

import 'list/release_notes_versions_list.dart';

class ReleaseNotesPage extends StatelessWidget {
  const ReleaseNotesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ReleaseNotesCubit>(context).loadReleaseNotes();

    return Scaffold(
        appBar: AppBar(
          title: Text(TAPage.releaseNotes.title),
          automaticallyImplyLeading: false,
        ),
        bottomNavigationBar: const TaBottomNavigationBar(
          currentIndex: 2,
        ),
        body: BlocBuilder<ReleaseNotesCubit, ReleaseNotesState>(
            builder: (context, state) {
          if (state is ReleaseNotesStateLoading) {
            return _loadingStateWidget();
          } else if (state is ReleaseNotesStateUnavailable) {
            return _errorStateWidget();
          } else if (state is ReleaseNotesStateLoaded) {
            return _loadedStateWidget(context, state);
          } else {
            return Container();
          }
        }));
  }

  Widget _loadingStateWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _errorStateWidget() {
    return const Center(
        child: Text("Error loading release notes. Please try again later."));
  }

  Widget _loadedStateWidget(
      BuildContext context, ReleaseNotesStateLoaded state) {
    final ReleaseNotes releaseNotes = state.releaseNotes;
    final Version selectedVersion = state.selectedVersion;
    final ChangelogItem selectedChangelogItem = state.selectedChangelogItem;
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.30,
          child: ReleaseNotesVersionList(
            versions: releaseNotes.versions,
            selectedVersion: selectedVersion,
            selectedChangelogItem: selectedChangelogItem,
          ),
        ),
        Expanded(
          child: ReleaseNotesChangelogItemDetailsView(
              changelogItem: selectedChangelogItem),
        )
      ],
    );
  }
}
