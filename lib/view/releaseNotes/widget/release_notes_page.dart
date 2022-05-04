import 'package:flutter/material.dart';
import 'package:tesla_android/common/navigation/ta_navigator.dart';
import 'package:tesla_android/common/navigation/ta_page.dart';
import 'package:tesla_android/common/ui/components/ta_bottom_sheet.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:tesla_android/view/releaseNotes/model/changelog_item.dart';
import 'package:tesla_android/view/releaseNotes/model/version_list_item.dart';
import 'package:tesla_android/view/releaseNotes/widget/release_notes_changelog_item_details_view.dart';
import 'package:tesla_android/view/releaseNotes/widget/release_notes_versions_list.dart';

class ReleaseNotesPage extends StatelessWidget {
  const ReleaseNotesPage({Key? key}) : super(key: key);

  //fixme move this to a json in assets
  static const List<VersionListItem> _versions = [
    VersionListItem(
      versionName: "2022.18.1",
      changelogItems: [
        ChangelogItem(
          title: "Initial release",
          shortDescription: "Hello world!",
          descriptionMarkdown:
              "## Hello world! \n ### \n ### Welcome to the first Alpha of Tesla Android!\n #### \n #### Getting to this point has been a long bumpy ride, I hope that you'll enjoy running Android Apps in your Tesla!\n ### \n ##### Best regards, \n ###### Michał Gapiński \n ###### @mikegapinski",
        ),
      ],
    )
  ];

  @override
  Widget build(BuildContext context) {
    return TABottomSheet(
        title: TAPage.releaseNotes.title,
        body: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                      child: ReleaseNotesVersionsList(
                    versions: _versions,
                  )),
                  _donationButton(context),
                ],
              ),
            ),
            Expanded(
              child: ReleaseNotesChangelogItemDetailsView(
                changelogItem: _versions.first.changelogItems.first,
              ),
            )
          ],
        ));
  }

  Widget _donationButton(BuildContext context) {
    return Padding(
      padding: TADimens.basePaddingHorizontal,
      child: MaterialButton(
        color: Colors.red.shade700,
        onPressed: () => TANavigator.push(
          context: context,
          page: TAPage.donationDialog,
        ),
        child: const SizedBox(
            width: double.infinity,
            child: Text(
              "Support the project",
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            )),
      ),
    );
  }
}
