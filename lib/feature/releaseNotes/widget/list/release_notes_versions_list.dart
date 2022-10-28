import 'package:flutter/material.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:tesla_android/feature/releaseNotes/model/changelog_item.dart';
import 'package:tesla_android/feature/releaseNotes/model/version.dart';
import 'package:tesla_android/feature/releaseNotes/widget/card/release_notes_changelog_item_card.dart';

class ReleaseNotesVersionList extends StatelessWidget {
  final List<Version> versions;
  final Version selectedVersion;
  final ChangelogItem selectedChangelogItem;

  const ReleaseNotesVersionList({
    Key? key,
    required this.versions,
    required this.selectedVersion,
    required this.selectedChangelogItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: TADimens.basePaddingHorizontal,
      itemCount: versions.length,
      itemBuilder: _versionItemBuilder,
    );
  }

  Widget _versionItemBuilder(
    BuildContext context,
    int index,
  ) {
    final version = versions[index];
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: TADimens.basePaddingVertical,
          child: Text(
            version.versionName,
            style: textTheme.titleMedium,
          ),
        ),
        ...version.changelogItems.map(
          (e) => ReleaseNotesChangelogItemCard(
            changelogItem: e,
            version: version,
            isActive: e == selectedChangelogItem,
          ),
        ),
      ],
    );
  }
}
