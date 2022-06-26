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
          title: "Virtual display",
          shortDescription: "Performance improvements",
          descriptionMarkdown:
          "### Display component has been refactored in order to allow up to 60Hz refresh rate.\n### Tesla Android will now behave normally when loaded in Drive or Reverse.\n### Simplification of video stack improves stability of the Flutter application running in the Tesla Browser.",
        ),
        ChangelogItem(
          title: "Audio Output",
          shortDescription: "Combined audio streams",
          descriptionMarkdown:
          "### Audio from Android is routed directly to your Tesla Browser.\n### Playback is allowed even when Drive or Reverse is engaged, meaning that there is no need to pair Tesla Android with your car using Bluetooth(Bluetooth link with the car is only used by your phone for Android Auto or CarPlay).\n### Audio output from Tesla Browser does not pause media playback from Tesla OS or CarPlay. \n### In order to active this feature open Audio Capture app on your Tesla Android after installing the OS. It will automatically launch on each boot later. Audio Capture can be terminated using a button present in the status notification.\n### Not all apps support audio capture, this restriction will be removed in a feature update.",
        ),
        ChangelogItem(
          title: "Flutter Frontend",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
          "### Flutter Frontend has been updated in order to improve user experience.\n### Loading times have been improved significantly.\n### All major components of the app now have proper state management and error handling.",
        ),
        ChangelogItem(
          title: "Android Platform",
          shortDescription: "Move to Android 12.1",
          descriptionMarkdown:
          "### Tesla Android has been migrated to Android 12.1 from AOSP Master in order to improve stability.\n### Release 2022.25.1 includes Android security updates up to May 5, 2022.",
        ),
        ChangelogItem(
          title: "Orientation lock",
          shortDescription: "All apps launch in landscape",
          descriptionMarkdown:
          "### Tesla Android now includes a working orientation lock for third party apps.\n### This feature allows phone apps like Apple Music to launch in landscape.",
        ),
        ChangelogItem(
          title: "Google Play Store",
          shortDescription: "App discoverability",
          descriptionMarkdown:
          "### Google Play Store has been replaced with Aurora Store, an Open Source alternative that includes Device Spoofing(emulating Google certification).\n### Google Play Services have been replaced with microG(Open Source Google Apps).\n### FDroid(Open Source App Store that does not rely on Google Play Store) is also included.",
        ),
        ChangelogItem(
          title: "Video Streaming",
          shortDescription: "DRM support",
          descriptionMarkdown:
          "### Tesla Android now supports DRM video playback. Apps like Netflix function normally in version 2022.25.1",
        ),
        ChangelogItem(
          title: "CarPlay",
          shortDescription: "Audio/Video improvements",
          descriptionMarkdown:
          "### Default resolution of CarPlay is a perfect match for Tesla Android in this release(no content overlapping in audio apps).\n### Navigation sounds also work, however this feature is active only when Tesla Browser is active.",
        ),
        ChangelogItem(
          title: "CPU management",
          shortDescription: "Lower power consumption",
          descriptionMarkdown:
          "### Release 2022.25.1 does not use the Performance CPU governor.\n### CPU frequency is now scaled accordingly to CPU load.",
        ),
        ChangelogItem(
          title: "Setup",
          shortDescription: "Simplified device configuration",
          descriptionMarkdown:
          "### Setup process of Tesla Android has been simplified, meaning several steps are no longer needed(obtaining a device identifier for Google Services, switching CarPlay resolution etc).",
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
