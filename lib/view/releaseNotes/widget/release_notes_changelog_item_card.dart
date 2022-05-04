import 'package:flutter/material.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:tesla_android/view/releaseNotes/model/changelog_item.dart';

class ReleaseNotesChangelogItemCard extends StatelessWidget {
  final ChangelogItem changelogItem;

  const ReleaseNotesChangelogItemCard({
    Key? key,
    required this.changelogItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Container(
        margin: EdgeInsets.zero,
        padding: TADimens.halfBasePadding,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(changelogItem.title, style: textTheme.labelLarge),
            const SizedBox(
              height: 5,
            ),
            Text(changelogItem.shortDescription, style: textTheme.caption),
          ],
        ),
      ),
    );
  }
}
