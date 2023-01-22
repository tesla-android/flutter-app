import 'package:injectable/injectable.dart';
import 'package:tesla_android/feature/releaseNotes/model/changelog_item.dart';
import 'package:tesla_android/feature/releaseNotes/model/release_notes.dart';
import 'package:tesla_android/feature/releaseNotes/model/version.dart';

@injectable
class ReleaseNotesRepository {
  static const ReleaseNotes _releaseNotes = ReleaseNotes(versions: [
    Version(versionName: "2022.45.1", changelogItems: [
      ChangelogItem(
          title: "Android 13",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
              "### The Android version has been updated to 13, and this change improves the stability of Tesla Android. Security patches have also been merged up to October 2022. The Android base for Raspberry Pi used by Tesla Android(Glodroid Project) has also been updated to the newest release, and it comes packed with improvements around the kernel, display drivers, and much more.\n### The entire Tesla Android codebase has been refactored in order to make feature Android Platform updates easier; this is an essential step towards making the project more maintainable."),
      ChangelogItem(
          title: "H264 hardware acceleration",
          shortDescription: "Performance improvements",
          descriptionMarkdown:
              "### Version 2022.4.1 adds support for hardware accelerated encoder and decoder for the H264 format. Playback of specific files can contain a small number of artifacts. This is a known issue that will be addressed in the future Tesla Android update. The current implementation of hardware acceleration is based on v4l2_codec2 and will be replaced with an alternative that supports more video formats."),
      ChangelogItem(
          title: "Virtual display",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
              "### The virtual display has been updated to use WebSockets for transport."),
      ChangelogItem(
          title: "Virtual touchscreen",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
              "### This version contains a fix for a problem with not being able to process input data after reloading the Flutter App."),
      ChangelogItem(
          title: "Audio playback",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
              "### The Audio Capture app that used to provide audio from Android to the Browser has been replaced with a new low-level implementation that integrates directly with the Android framework responsible for generating the audio stream before it’s broadcasted to the actual hardware(HDMI, headphone jack, etc.). This new approach brings in a lot of other improvements:\n### * Increased audio quality (stereo PCM 48kHz - Lossless Audio)\n### * Support for DRM content (streaming services)\n### * Support for volume control in Android (available in the Android Settings app)"),
      ChangelogItem(title: "Flutter app", shortDescription: "Stability improvements", descriptionMarkdown: "### The Flutter App has been refactored to improve stability. Here are some of the changes:\n### * WebSockets handling for Tesla Android services has been improved.\n### * Thanks to the new transport layer, the Virtual Display component is now powered by Flutter. This significantly improves stability when compared to the previously used Iframe-based approach.\n### * The connectivity state observer component has been introduced. The app will notify you when it wouldn’t be able to access Tesla Android services. This change ensures you will not have to manually reload the app when your car returns from sleep or the hardware itself restarts.\n### * Flutter Framework has been updated to version 3.3.10"),
      ChangelogItem(title: "USB tethering for iOS", shortDescription: "Connectivity improvements", descriptionMarkdown: "### Version 2023.4.1 adds support for sharing the internet from iOS devices via USB. Connect your phone, enable tethering and accept the USB access permission request on your iPhone."),
      ChangelogItem(title: "LTE Modem support", shortDescription: "Connectivity improvements", descriptionMarkdown: "### This update introduces a new Android system service. The Tesla Android USB Networking Initializer simplifies how USB Modems are initialized and allows the use of per-device configuration scripts. This change resolved issues with some variants of Alcatel devices and added support for more Huawei modems."),
    ]),
    Version(
      versionName: "2022.45.1",
      changelogItems: [
        ChangelogItem(
          title: "Google Apps",
          shortDescription: "Usability improvements",
          descriptionMarkdown:
              "### Version 2022.45.1 brings back Google Play Store and other Google Services that were removed in 2022.25.1. Device ID registration for Google Play is not longer required. Not all apps can be installed using Google Play Store due to lack of device certification, they need to be installed manually.",
        ),
        ChangelogItem(
          title: "Android Platform",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
              "### Tesla Android system services initialisation has been improved, all components(web server, touchscreen, display etc.) will automatically restart on failure. In previous versions a full system reboot would be needed in this scenario.",
        ),
        ChangelogItem(
          title: "Virtual display",
          shortDescription: "DRM playback",
          descriptionMarkdown:
              "### Version 2022.45.1 fixes DRM video playback and enables access to secure layers that are usually blacked out in screen capture.",
        ),
        ChangelogItem(
          title: "CarPlay",
          shortDescription: "Visual improvements",
          descriptionMarkdown:
              "### Three row layout for CarPlay is now selected as default.",
        ),
        ChangelogItem(
          title: "Virtual touchscreen",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
              "### Flutter app no longer displays information about virtual touchscreen initialisation, it is irrelevant for the single board stack and should have been removed earlier.",
        ),
        ChangelogItem(
          title: "Bluetooth",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
              "### Restarting the system after disabling Bluetooth is no longer required.",
        ),
        ChangelogItem(
          title: "Internet access",
          shortDescription: "USB tethering for Android",
          descriptionMarkdown:
              "### USB tethering from Android phones is now supported in Tesla Android. No configuration is required to enable this feature. Your Android phone will be detected as an external ethernet interface when you enable tethering.",
        ),
        ChangelogItem(
          title: "Internet access",
          shortDescription: "LTE modem support",
          descriptionMarkdown:
              "### 2022.45.1 introduces support for USB network devices using the cdc_ncm driver - it has been validated and works without any additional steps from the user. Experimental changes that might enable support for cdc_mbim and rndis_host drivers are also included. Previous versions supported only the cdc_ether driver.",
        ),
        ChangelogItem(
          title: "Internet access",
          shortDescription: "Support for external routers",
          descriptionMarkdown:
              "### Tesla Android webserver and other services can now be accessed externally using ethernet. This can be used to access the device in your home network or in the car with an external router.",
        ),
      ],
    ),
    Version(
      versionName: "2022.44.1",
      changelogItems: [
        ChangelogItem(
          title: "Single Board stack",
          shortDescription: "Hardware and setup improvements",
          descriptionMarkdown:
              "### Tesla Android does not need the hardware HDMI capture interface anymore. Updated video layer also uses less resources.",
        ),
        ChangelogItem(
          title: "Single system image",
          shortDescription: "Setup improvements",
          descriptionMarkdown:
              "### Starting with version 2022.44.1 there is a new way to install Tesla Android.\n### New single image setup process that does not need adb or fastboot. This change requires a 64GB(or larger) SD card.",
        ),
        ChangelogItem(
          title: "LTE",
          shortDescription: "Fixes for Huawei E3372",
          descriptionMarkdown:
              "### Previous release broke support for Huawei E3372. This issue is now resolved.",
        ),
        ChangelogItem(
          title: "Android platform",
          shortDescription: "Boot time improvements",
          descriptionMarkdown:
              "### Version 2022.44.1 includes multiple internal optimisations that allow for your Tesla Android to boot up faster after the car wakes from sleep.",
        ),
        ChangelogItem(
          title: "Virtual display",
          shortDescription: "Performance and quality improvements",
          descriptionMarkdown:
              "### Virtual display resolution has been increased to enable high fidelity Android experience in your Tesla.\n### The responsiveness is also improved thanks to internal changes in the video layer.",
        ),
        ChangelogItem(
          title: "CarPlay",
          shortDescription: "Performance improvements",
          descriptionMarkdown:
              "### Improvements in the video layer leave more performance for other components.\n### Decoding video stream from CarPlay is faster in version 2022.44.1.",
        ),
        ChangelogItem(
          title: "Flutter Frontend",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
              "### Flutter frameworks has been updated in order to improve user experience.",
        ),
      ],
    ),
    Version(
      versionName: "2022.38.1",
      changelogItems: [
        ChangelogItem(
          title: "Single Board stack",
          shortDescription: "Hardware and setup improvements",
          descriptionMarkdown:
              "### Tesla Android does not need two Raspberry Pi boards anymore!\n### Version 2022.38.1 is based only on Android.\n### This marks a significant milestone for the project and greatly lowers the barrier of entry both in terms of cost and ease of setup.",
        ),
        ChangelogItem(
          title: "Browser Audio",
          shortDescription: "Stability and volume improvements",
          descriptionMarkdown:
              "### Version 2022.38.1 brings fixes to the browser audio streaming module.\n### The output volume has been adjusted to match Bluetooth music playback when using CarPlay.\n### Audio capture service on Android is now a persistent system service that doesn't need to request permissions and automatically restarts on failure.\n### Bandwidth consumption has been significantly reduced when the music is not playing.",
        ),
        ChangelogItem(
          title: "Offline Mode",
          shortDescription: "Support for the Chinese market and bugfixes",
          descriptionMarkdown:
              "### Single board stack includes an updated version of the Offline mode introduced in version 2022.27.1. Connectivity is now handled directly within the Android system, Pi-hole is no longer required.\n### Thanks to the community input Tesla Android works better in China - version 2022.38.1 includes fixes for connection dropouts due to different API endpoints in this market.",
        ),
        ChangelogItem(
          title: "Wi-Fi",
          shortDescription: "Hotspot improvements",
          descriptionMarkdown:
              "### With Tesla Android Single Board you can now manage your Hotspot settings directly in your Tesla.\n### Updating your network name and credentials is now possible in the Android Settings app.",
        ),
        ChangelogItem(
          title: "Virtual display",
          shortDescription: "Backend improvements and bugfixes",
          descriptionMarkdown:
              "### Starting with version 2022.38.1 Tesla Android does not use Ustreamer for video streaming.\n### Single board stack uses a modified version of mjpg_streamer built with Android NDK.\n### The new solution is modular and was chosen with bringing direct framebuffer capture to Tesla Android in mind.\n### Resolution of the virtual display has been updated to match the Tesla Browser viewport introduced with Tesla Version 2022.24.",
        ),
        ChangelogItem(
          title: "Flutter Frontend",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
              "### Flutter Frontend has been updated in order to improve user experience.\n### Framework version has been bumped to 3.3.",
        ),
      ],
    ),
    Version(
      versionName: "2022.27.1",
      changelogItems: [
        ChangelogItem(
          title: "Offline Mode",
          shortDescription: "LTE modem is now optional",
          descriptionMarkdown:
              "### Starting with version 2022.27.1 the LTE modem is not required for Tesla Android to maintain connection with your car.\n### Keep in mind that certain online features might not be available in your car as it expects the Wi-Fi network to replace the connectivity provided by Tesla.\n### When using the Offline Mode turning off Wi-Fi on your touchscreen or powering off Tesla Android is required for accessing your car with the Tesla Mobile App while parked.\n### Tesla Android can still be used to provide internet to your car like in previous build - no extra configuration changes are required.",
        ),
        ChangelogItem(
          title: "Wi-Fi",
          shortDescription: "Persistent connection with your Tesla",
          descriptionMarkdown:
              "### As a result of introducing the new Offline Mode Wi-Fi stability and connection times have been significantly improved.\n### If you use the (now optional) LTE modem to get a full Android experience your Wi-Fi with the car won't disconnect when there is no LTE coverage(highways, underground parking etc)",
        ),
        ChangelogItem(
          title: "Virtual display",
          shortDescription: "Quality improvements",
          descriptionMarkdown:
              "### Video stream quality has been slightly improved after reducing the image compression.",
        ),
        ChangelogItem(
          title: "Flutter Frontend",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
              "### Flutter Frontend has been updated in order to improve user experience.\n### Framework version has been bumped to 3.0.4. Rendering engine has been switched to HTML from CanvasKit due to problems with offline loading in Flutter.",
        ),
      ],
    ),
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
