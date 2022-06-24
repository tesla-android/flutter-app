import 'package:injectable/injectable.dart';
import 'package:tesla_android/feature/releaseNotes/model/changelog_item.dart';
import 'package:tesla_android/feature/releaseNotes/model/release_notes.dart';
import 'package:tesla_android/feature/releaseNotes/model/version.dart';

@injectable
class ReleaseNotesRepository {
  static const ReleaseNotes _releaseNotes = ReleaseNotes(versions: [
    Version(
      versionName: "2022.25.1",
      changelogItems: [
        ChangelogItem(
          title: "",
          shortDescription: "",
          descriptionMarkdown:
          "",
        ),
      ],
    ),
    Version(
      versionName: "2022.18.1",
      changelogItems: [
        ChangelogItem(
          title: "Initial release",
          shortDescription: "Hello world!",
          descriptionMarkdown:
              "## Hello world!\n### Welcome to the first Alpha of Tesla Android!\n#### Getting to this point has been a long bumpy ride, I hope that you'll enjoy running Android Apps in your Tesla!\n##### Best regards, \n ###### Michał Gapiński \n ###### @mikegapinski",
        ),
      ],
    ),
  ]);

  Future<ReleaseNotes> getReleaseNotes() async {
    return Future.value(_releaseNotes);
  }
}
