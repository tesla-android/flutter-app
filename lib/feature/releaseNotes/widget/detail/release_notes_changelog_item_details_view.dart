import 'package:flutter/material.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:tesla_android/feature/releaseNotes/model/changelog_item.dart';

class ReleaseNotesChangelogItemDetailsView extends StatelessWidget {
  final ChangelogItem changelogItem;

  const ReleaseNotesChangelogItemDetailsView({
    Key? key,
    required,
    required this.changelogItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: TADimens.basePadding,
      child: Text(
        changelogItem.descriptionMarkdown,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
