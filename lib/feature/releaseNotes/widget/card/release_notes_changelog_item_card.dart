import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:tesla_android/feature/releaseNotes/cubit/release_notes_cubit.dart';
import 'package:tesla_android/feature/releaseNotes/model/changelog_item.dart';
import 'package:tesla_android/feature/releaseNotes/model/version.dart';

class ReleaseNotesChangelogItemCard extends StatelessWidget {
  final ChangelogItem changelogItem;
  final Version version;
  final bool isActive;

  const ReleaseNotesChangelogItemCard({
    super.key,
    required this.version,
    required this.changelogItem,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final cubit = BlocProvider.of<ReleaseNotesCubit>(context);
    return Card(
      color: _getCardColor(context),
      child: InkWell(
        onTap: () => cubit.updateSelection(
          version: version,
          changelogItem: changelogItem,
        ),
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
                height: TADimens.PADDING_XS_VALUE,
              ),
              Text(
                changelogItem.shortDescription,
                style: textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCardColor(BuildContext context) {
    final theme = Theme.of(context);
    final themeCardColor = theme.cardColor;
    final brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;
    if (isDark) {
      return isActive ? themeCardColor : Colors.transparent;
    } else {
      return isActive ? themeCardColor.withOpacity(0.75) : themeCardColor;
    }
  }
}
