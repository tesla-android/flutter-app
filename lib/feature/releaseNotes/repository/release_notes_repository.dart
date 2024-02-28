import 'package:injectable/injectable.dart';
import 'package:tesla_android/feature/releaseNotes/model/changelog_item.dart';
import 'package:tesla_android/feature/releaseNotes/model/release_notes.dart';
import 'package:tesla_android/feature/releaseNotes/model/version.dart';

@injectable
class ReleaseNotesRepository {
  static const ReleaseNotes _releaseNotes = ReleaseNotes(versions: [
    Version(
      versionName: "2024.9.1",
      changelogItems: [
        ChangelogItem(
          title: "Android Platform",
          shortDescription: "Security improvements",
          descriptionMarkdown:
          "The platform has been updated to the latest Android 14 release",
        ),
      ],
    ),
    Version(
      versionName: "2023.48.2",
      changelogItems: [
        ChangelogItem( 
          title: "SSL certificate reneval",
          shortDescription: "Bugfix",
          descriptionMarkdown:
          "The SSL certificate for the frontend expired on 09.02.2024. It has been renewed for another 90 days",
        ),
      ],
    ),
    Version(
      versionName: "2023.48.1",
      changelogItems: [
        ChangelogItem(
          title: "Wi-Fi Hotspot",
          shortDescription: "Bugfix",
          descriptionMarkdown:
          "Some users unintentionally disabled the Hotspot without using a 3rd party router. The ability to disable the broadcasting has been removed in this version since it does not make a lot of sense with the current networking setup that does not rely on using a public IP range in the DHCP server.",
        ),
        ChangelogItem(
          title: "Android Platform",
          shortDescription: "Security improvements",
          descriptionMarkdown:
          "The platform has been updated to the latest Android 13 release",
        ),
      ],
    ),
    Version(
      versionName: "2023.45.1",
      changelogItems: [
        ChangelogItem(
          title: "SSL certificate reneval",
          shortDescription: "Bugfix",
          descriptionMarkdown:
          "The SSL certificate for the frontend expired on 11.11.2023. It has been renewed for another 90 days",
        ),
        ChangelogItem(
          title: "Offline mode",
          shortDescription: "Bugfix",
          descriptionMarkdown:
          "This version includes a fix for offline mode for cars running 2023.38.x or newer",
        ),
        ChangelogItem(
          title: "Android Platform",
          shortDescription: "Security improvements",
          descriptionMarkdown:
          "The platform has been updated to the latest Android 13 release",
        ),
      ],
    ),
    Version(
      versionName: "2023.42.1",
      changelogItems: [
        ChangelogItem(
          title: "Graphics and codecs",
          shortDescription: "Performance improvements",
          descriptionMarkdown:
          "The transition to updated GPU backend and optimised video codecs is now complete. Those changes improve the overall performance of the system",
        ),
        ChangelogItem(
          title: "Android Platform",
          shortDescription: "Security improvements",
          descriptionMarkdown:
          "The platform has been updated to the latest Android 13 release with October 2023 security patches", 
        ),
      ],
    ),
    Version(
      versionName: "2023.41.100",
      changelogItems: [
        ChangelogItem(
          title: "NVMe support",
          shortDescription: "Performance improvements",
          descriptionMarkdown:
          "NVMe drives are now supported on the Compute Module 4",
        ),
      ],
    ),
    Version(
      versionName: "2023.40.2",
      changelogItems: [
        ChangelogItem(
          title: "Virtual display",
          shortDescription: "Bugfixes",
          descriptionMarkdown:
          "This version contains a hotfix for DRM video playback",
        ),
      ],
    ),
    Version(
      versionName: "2023.40.1",
      changelogItems: [
        ChangelogItem(
          title: "Virtual display",
          shortDescription: "Performance improvements",
          descriptionMarkdown:
          "Virtual display module has been updated to take advantage of DMA buffers in the capture pipeline. The new approach lowers the CPU usage by up to 500% and improves performance. Other bugfixes and improvements have been included to enhance stability.",
        ),
        ChangelogItem(
          title: "OTA Updates",
          shortDescription: "Usability improvements",
          descriptionMarkdown:
          "Starting with version 2023.40.1 Tesla Android will notify you about new updates directly in the Flutter App. A familiar download icon will show up in the upper right corner of the screen.",
        ),
        ChangelogItem(
          title: "Video Codecs",
          shortDescription: "Performance improvements",
          descriptionMarkdown:
          "This update brings back v42l_codec2 for H264 encoding/decoding. Issues with AV1 decoding present in 2023.38.1 have been resolved.",
        ),
        ChangelogItem(
          title: "Browser Audio",
          shortDescription: "Performance improvements",
          descriptionMarkdown:
          "2023.40.1 comes with a new browser audio player that improves the reliability and reduces the audio drift that was noticible in MCU2 vehicles.",
        ),
      ],
    ),
    Version(
      versionName: "2023.38.1",
      changelogItems: [
        ChangelogItem(
          title: "Vulkan Backend for SKIA/HWUI",
          shortDescription: "Performance improvements",
          descriptionMarkdown:
          "Version 2023.38.1 adds the Vulkan Backend support for the system interface drawing. It is still considered experimental and can be enabled in the settings.",
        ),
        ChangelogItem(
          title: "Local OTA Updates",
          shortDescription: "Usability improvements",
          descriptionMarkdown:
          "You can now install OTA updates from external storage and save your data package. The builds are available on GitHub in the Tesla Android organisation (android-raspberry-pi-ota, android-compute-module-4-ota).",
        ),
        ChangelogItem(
          title: "Offline mode",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
          "Offline mode has been improved in version 2023.38.1 and it will no longer interfere with the Tesla App / vehicle telemetry collection (Teslascope, TeslaFi, TeslaMate etc) when internet is accessible.",
        ),
        ChangelogItem(
          title: "Device Settings",
          shortDescription: "Usability improvements",
          descriptionMarkdown:
          "You can now check if the LTE modem and CarPlay module is properly detected by the system.",
        ),
        ChangelogItem(
          title: "Browser Audio",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
          "Fixed an issue with disabling browser audio in the settings.",
        ),
        ChangelogItem(
          title: "Virtual Display",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
          "Miscellaneous bugfixes aimed at improving display stability.",
        ),
        ChangelogItem(
          title: "Argon I2C fan support",
          shortDescription: "Usability improvements",
          descriptionMarkdown:
          "Argon fans controlled by I2C are now fully supported on builds meant for the Raspberry Pi 4.",
        ),
      ],
    ),
    Version(
      versionName: "2023.36.1",
      changelogItems: [
        ChangelogItem(
          title: "GPS",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
              "Version 2023.36.1 improves the stability of the GPS module. Issues with the Tesla Browser crashing when the location permission is granted should be resolved now.",
        ),
        ChangelogItem(
          title: "Virtual Display",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
          "Virtual display frontend implementation issue that resulted in a blank screen after launching the app is fixed in this release.",
        ),
        ChangelogItem(
          title: "CM4 Bundle Support",
          shortDescription: "Hardware improvements",
          descriptionMarkdown:
          "A separate target has been created for the Tesla Android Compute Module 4 Hardware Bundles.",
        ),
        ChangelogItem(
          title: "Device Settings",
          shortDescription: "Usability improvements",
          descriptionMarkdown:
          "You can now check the CPU temperature, device model and serial number in the new tab on the Settings page",
        ),
        ChangelogItem(
          title: "Flutter App",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
          "Flutter Framework has been updated to 3.13.2. Miscellaneous bugfixes in the app are also included.",
        ),
        ChangelogItem(
          title: "Android Platform",
          shortDescription: "Security improvements",
          descriptionMarkdown:
          "Android has been updated to android-platform-13.0.0_r10 with the latest available security patches.",
        ),
      ],
    ),
    Version(versionName: "2023.32.2", changelogItems: [
      ChangelogItem(
          title: "Variable Refresh Rate",
          shortDescription: "Performance improvements",
          descriptionMarkdown:
              "Tesla Android can now lower the refresh rate based on what is happening on the Virtual Display. This feature reduces the browser load and bandwidth"),
      ChangelogItem(
          title: "Browser Audio",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
              "The bug that left the audio always on regardless of the configuration is now fixed"),
      ChangelogItem(
          title: "Support for Vodafone K5161h",
          shortDescription: "Connectivity improvements",
          descriptionMarkdown: "Vodafone K5161h LTE modem is now supported"),
    ]),
    Version(versionName: "2023.32.1", changelogItems: [
      ChangelogItem(
          title: "Virtual Display",
          shortDescription: "Performance and Usability Improvements",
          descriptionMarkdown:
              "The virtual display can now adjust to the size of your browser window, enhancing the full-screen mode experience. This feature is disabled by default but can be enabled in the Tesla Android Settings. Be aware that frequently resizing the window on your PC/Mac may cause instability.\n\n"
              "Tesla Android now offers resolution presets. You can choose from several settings ranging from 480p to 832p, which can boost performance on MCU2-equipped vehicles."),
      ChangelogItem(
          title: "GPS Support",
          shortDescription: "Usability Improvements",
          descriptionMarkdown:
              "Version 2023.32.1 utilizes vehicle location data to emulate GPS hardware in the Android OS. Apps like Waze or Google Maps are now supported, making CarPlay/Android Auto non-essential for navigation. Occasionally, the car's browser may close when GPS is enabled, an issue not strictly browser-related and it occurs in the Tesla OS. GPS can be turned off by revoking permission in the address bar."),
      ChangelogItem(
          title: "Browser Audio",
          shortDescription: "Stability Improvements",
          descriptionMarkdown:
              "This version introduces multiple enhancements to browser audio, resulting in better reliability."),
      ChangelogItem(
          title: "Wi-Fi Hotspot",
          shortDescription: "Performance Improvements",
          descriptionMarkdown:
              "Tesla Android now operates with AC Wi-Fi in 5GHz mode, changing the channel to prevent interference from CarPlay dongles. 5GHz is the default mode for new users."),
      ChangelogItem(
          title: "Virtual Touchscreen",
          shortDescription: "Usability Improvements",
          descriptionMarkdown:
              "The touchscreen's input accuracy has seen significant improvement. Its input surface dynamically adjusts to match the display size, eliminating client-side scaling."),
      ChangelogItem(
          title: "SSL Support",
          shortDescription: "Security Improvements",
          descriptionMarkdown:
              "Tesla Android services are now channeled through a reverse-http proxy set up by the web server. This modification was necessitated by the GPS API's secure context requirements. However, users can still opt for the http version to bypass encryption overhead."),
      ChangelogItem(
          title: "Networking",
          shortDescription: "Architectural Changes",
          descriptionMarkdown:
              "Tesla Android no longer assigns public range IP addresses to make the frontend accessible via the car's browser. Instead, a singular IP (104.248.101.213) redirects to the device with iptables. For accessing the Tesla Android app, please use https://device.teslaandroid.com."),
      ChangelogItem(
          title: "App Launcher",
          shortDescription: "Usability Improvements",
          descriptionMarkdown:
              "Users no longer have to wait for Tesla Android to boot to start the frontend. Simply access https://device.teslaandroid.com, and the launcher will automatically redirect you to the Flutter App once your car connects to the device's network."),
      ChangelogItem(
          title: "Full Screen Mode",
          shortDescription: "Stability Improvements",
          descriptionMarkdown:
              "Transitioning to full screen while parked has been refined and is more reliable."),
      ChangelogItem(
          title: "Flutter App",
          shortDescription: "Performance and Usability Improvements",
          descriptionMarkdown:
              "The Flutter app comes with several updates in this release:\n"
              "- Framework and dependencies are updated to the latest versions.\n"
              "- Full implementation of Material 3.\n"
              "- The splash screen now supports Dark Mode.\n"
              "- The settings page is now categorized into various sections.\n"
              "- The Android OS module is streamlined. All functionalities dependent on standard Web APIs are managed within the iframe hosting the virtual display, including GPS, Audio, and WebSocket-based transport."),
      ChangelogItem(
          title: "Android OS",
          shortDescription: "Stability Improvements",
          descriptionMarkdown:
              "The Android base is now updated to the latest version, incorporating the August 2023 security patches. Upstream modifications to kernel/drivers have also been merged."),
    ]),
    Version(versionName: "2023.20.1", changelogItems: [
      ChangelogItem(
          title: "Offline mode",
          shortDescription: "Data usage reduction",
          descriptionMarkdown:
              "Version 2023.20.1 includes an updated offline mode that is configurable. You can disable sending Telemetry data to Tesla(important for FSD Beta users), and the firmware updates don't have to download using the Tesla Android Wi-Fi network.\n\nThe ability to check if your car runs the latest Tesla firmware is not affected.\n\nKudos to Green and Soma for making this possible!"),
      ChangelogItem(
        title: "Full-Screen launcher",
        shortDescription: "Usability improvements",
        descriptionMarkdown:
            "An early Full-Screen frontend is now available. You can access it using a new \"Go Full-Screen\" button in the Flutter App or by navigating to fullscreen.app.teslaandroid.com. \n\nThe Virtual Display still needs to fill the entire window, and there might be some minor UI issues in the Flutter App.",
      ),
      ChangelogItem(
        title: "Networking",
        shortDescription: "Routing improvements",
        descriptionMarkdown:
            "You can access your Tesla Android by typing using app.teslaandroid.com instead of typing the IP address.\n\nThe DHCP server is no longer using a public IP range. Tesla Android switched to a Carrier-grade NAT range.",
      ),
      ChangelogItem(
          title: "Android Platform",
          shortDescription: "Boot time optimization",
          descriptionMarkdown:
              "Version 2023.20.1 takes ~10s less to boot when compared to 2023.18. This was made possible by changing the Wi-Fi network initialisation code."),
      ChangelogItem(
        title: "Wi-Fi",
        shortDescription: "Performance improvements",
        descriptionMarkdown:
            "Version 2023.20.1 add support for 5GHz Wi-Fi. The new future can be manually enabled in Settings and should improve the network speed significantly.\n\nUsers with their own routers can now disable to Tesla Android Wi-Fi network altogether.",
      ),
      ChangelogItem(
        title: "Flutter App",
        shortDescription: "Stability improvements",
        descriptionMarkdown:
            "Version 2023.20.1 improves the Connectivity Check module. The app is also fully integrated with a self-hosted instance of Sentry(Performance monitoring & Error Tracking).\n\nThe data is anonymised and no fingerprints are captured. Crash logs contain the version of firmware and display resolution. ",
      ),
    ]),
    Version(versionName: "2023.18.2", changelogItems: [
      ChangelogItem(
        title: "Virtual display",
        shortDescription: "Performance improvements",
        descriptionMarkdown:
            "Variable refresh rate mechanism introduced in 2023.18.1 is disabled due to its negative impact on the input latency and animation smoothness.",
      ),
      ChangelogItem(
          title: "Android Platform",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
              "Android has been updated to Android 13 release 43 with the latest security patches."),
      ChangelogItem(
          title: "Web server",
          shortDescription: "Usability improvements",
          descriptionMarkdown:
              "Cache settings are now less aggressive. You should not need to clear browser data after every Tesla Android update."),
    ]),
    Version(versionName: "2023.18.1", changelogItems: [
      ChangelogItem(
          title: "Virtual display",
          shortDescription: "Performance improvements",
          descriptionMarkdown:
              "The virtual display is now hardware accelerated via the V4L2 API. As a result, this solution behaves consistently regardless of CPU usage (gaming, video playback).\n\nThe capture mechanism has also been replaced. The new solution sends data to the browser less frequently if nothing is happening on the display. As a result, overall resource usage of the front end is significantly reduced in typical use.\n\nInternally the refresh rate of the headless operation mode in drm_hwcomposer is now capped at 30Hz. The SufraceFlinger is not able to provide more frames to the virtual display(buffer allocation related).\n\nSystem animation duration is now reduced to improve performance.\n\nVirtual display window scaling has been modified to slightly increase text size in system apps; it makes them more easily readable when driving."),
      ChangelogItem(
          title: "Browser audio",
          shortDescription: "Usability improvements",
          descriptionMarkdown:
              "Version 2023.18.1 adds the ability to control the sound settings in the Flutter app. The feature can be disabled if you intend to use Bluetooth Audio or other peripherals."),
      ChangelogItem(
          title: "Virtual touchscreen",
          shortDescription: "Multitouch support",
          descriptionMarkdown:
              "Multitouch support is now available in Tesla Android. The overall stability of the component has been increased."),
      ChangelogItem(
          title: "Android Platform",
          shortDescription: "Boot time optimization",
          descriptionMarkdown:
              "Version 2023.18.1 takes ~2/3x less time to boot when compared to other Android 13 releases."),
      ChangelogItem(
          title: "Android Platform",
          shortDescription: "Support for OTA updates",
          descriptionMarkdown:
              "Version 2023.18.1 adds support for OTA updates. A/B (Seamless) mechanism ensures a safe installation with a rollback to the previous build in case of failure. The process takes place in the background; you can use Tesla Android when the update is being installed.\n\nNavigate to Settings -> System -> Updater to check update availability in the future.\n\nUpdates are not incremental. You can skip a few versions and update directly to the newest build.\n\nOnly online updates are available in this release; connect your Raspberry Pi to your home router with an Ethernet cable to avoid data charges. Each update weighs around 1 GB."),
      ChangelogItem(
          title: "Single image install",
          shortDescription: "Usability improvements",
          descriptionMarkdown:
              "The bootloader has been updated to support the single-image install process better. In addition, the filesystem will now expand to take advantage of the entire SD Card on the first boot(similar to how Raspbian behaves).\n\nAny SD Card over 16GB will work with Tesla Android, but 64GB is recommended.\n\nThe download size has been significantly reduced, and the manual installation procedure has been deprecated and removed from the website. "),
      ChangelogItem(
          title: "Bluetooth",
          shortDescription: "Usability improvements",
          descriptionMarkdown:
              "Version 2023.18.1 fixes problems with Bluetooth Low Energy. You can now use wireless game controllers, OBD interfaces, and more. Bluetooth Audio stability is also improved."),
      ChangelogItem(
          title: "Android Platform",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
              "Android has been updated to Android 13 release 41 with the latest security patches. The platform is now in sync with the latest GloDroidCommunity AOSP base. All the board-related changes have been sent upstream, and Tesla Android was migrated to a new build mechanism to make future Android platform updates faster."),
      ChangelogItem(
          title: "Flutter App",
          shortDescription: "Usability improvements",
          descriptionMarkdown:
              "The has been reorganized to make room for new modules. Tapping the version ribbon takes you to the screen with multiple tabs. One of them is the new Settings module, where you can control the browser audio."),
      ChangelogItem(
          title: "Video playback",
          shortDescription: "Performance improvements",
          descriptionMarkdown:
              "Version 2023.18.1 adds AV1 decoding via ffmpeg_codec2. The new component takes advantage of multiple cores and performs better."),
      ChangelogItem(
          title: "Connectivity",
          shortDescription: "Usability improvements",
          descriptionMarkdown:
              "Version 2023.18.1 adds support for Huawei(Brovi) E3372-325. The device is available in the European market."),
      ChangelogItem(
          title: "Compute Module 4",
          shortDescription: "Hardware improvements",
          descriptionMarkdown:
              "Version 2023.18.1 adds support for the Raspberry Pi Compute Module 4 and was tested with both EMMC(32GB) and SD Card-equipped variants. The external Wi-Fi antenna is selected by default."),
      ChangelogItem(
          title: "PWM fan support",
          shortDescription: "Hardware improvements",
          descriptionMarkdown:
              "PWM is now enabled on GPIO 18. Supported coolers will only turn on if necessary. You can change the settings in config.txt on the boot partition of the SDCard."),
    ]),
    Version(versionName: "2023.7.1", changelogItems: [
      ChangelogItem(
          title: "Android Platform",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
              "Android has been updated to Android 13.0.0_r31 with the latest available security patches."),
      ChangelogItem(
          title: "H264 hardware acceleration",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
              "Version 2023.7.1 improves the stability of the playback and solves issues with artifacts present in the previous version."),
      ChangelogItem(
          title: "H265 hardware acceleration",
          shortDescription: "Usability improvements",
          descriptionMarkdown:
              "This version adds support for hardware-accelerated H265 video playback via ffmpeg_codec2."),
      ChangelogItem(
          title: "Software audio decoders",
          shortDescription: "Usability improvements",
          descriptionMarkdown:
              "2023.7.1 adds software audio decoders exposed by ffmpeg_codec2 for the following file formats: \n• aac  \n• ac3  \n• alac  \n• flac  \n• mp2  \n• mp3  \n• vorbis  \n\nMost of the formats were previously supported by software decoders included with Android. The ffmpeg-powered replacements tend to consume fewer CPU resources."),
      ChangelogItem(
          title: "Software video decoders",
          shortDescription: "Usability improvements",
          descriptionMarkdown:
              "2023.7.1 adds software video decoders exposed by ffmpeg_codec2 for the following file formats: \n• h263  \n• mpeg2  \n• mpeg4  \n• vp8  \n• vp9  \n\nMost of the formats were previously supported by software decoders included with Android. The ffmpeg-powered replacements tend to consume fewer CPU resources."),
      ChangelogItem(
          title: "Flutter App",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
              "Flutter App received various improvements in this update: \n• The framework has been updated to version 3.7. \n• Version ribbon has been repositioned to the upper right corner. \n• Reverted changes in touchscreen transport that were introduced in 2023.4.1. The previous implementation was more stable.\n• The reliability of the connectivity checker module was improved by removing the ability to cache static HTML content in Lighttpd. The browser used to cache the health check response for a while after Tesla Android services became unavailable."),
      ChangelogItem(
          title: "Audio playback",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
              "This version increases the audio playback buffer flush interval from 30 to 100 milliseconds with the hope of decreasing stuttering in cases where the MCU is not able to process the data from WebSocket transport in time."),
    ]),
    Version(versionName: "2023.4.2", changelogItems: [
      ChangelogItem(
          title: "Virtual display",
          shortDescription: "Performance improvements",
          descriptionMarkdown:
              "Version 2023.4.1 introduced a new transport layer to the virtual display. Unfortunately, it misbehaved in vehicles with Intel MCU, especially those with the Wi-Fi antenna placed outside the car. This version brings back the transport from 2022.45 and keeps other improvements like the connectivity check module."),
      ChangelogItem(
        title: "Audio playback",
        shortDescription: "Usability improvements",
        descriptionMarkdown:
            "The previous update introduced volume control in Android. However, default values were around 50%, confusing users. 2022.4.2 resolves this issue and sets the Android system volume to 100%.",
      ),
      ChangelogItem(
          title: "Flutter App",
          shortDescription: "Performance improvements",
          descriptionMarkdown:
              "Version 2023.4.2 brings several improvements in performance to the Flutter app: \n• Removed fade-in and fade-out transitions from the audio playback component on each buffer flush. This change makes the volume curve consistent.\n• After introducing a workaround for offline PWA support, the rendering engine was changed from HTML to CanvasKit.\n• Reduced the amount of ping/pong frames used by the WebSocket transport for the virtual touchscreen")
    ]),
    Version(versionName: "2023.4.1", changelogItems: [
      ChangelogItem(
          title: "Android 13",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
              "The Android version has been updated to 13, and this change improves the stability of Tesla Android. Security patches have also been merged up to October 2022. The Android base for Raspberry Pi used by Tesla Android(Glodroid Project) has also been updated to the newest release, and it comes packed with improvements around the kernel, display drivers, and much more.\n\nThe entire Tesla Android codebase has been refactored in order to make feature Android Platform updates easier; this is an essential step towards making the project more maintainable."),
      ChangelogItem(
          title: "H264 hardware acceleration",
          shortDescription: "Performance improvements",
          descriptionMarkdown:
              "Version 2022.4.1 adds support for hardware accelerated encoder and decoder for the H264 format. Playback of specific files can contain a small number of artifacts. This is a known issue that will be addressed in the future Tesla Android update. The current implementation of hardware acceleration is based on v4l2_codec2 and will be replaced with an alternative that supports more video formats."),
      ChangelogItem(
          title: "Virtual display",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
              "The virtual display has been updated to use WebSockets for transport."),
      ChangelogItem(
          title: "Virtual touchscreen",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
              "This version contains a fix for a problem with not being able to process input data after reloading the Flutter App."),
      ChangelogItem(
          title: "Audio playback",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
              "The Audio Capture app that used to provide audio from Android to the Browser has been replaced with a new low-level implementation that integrates directly with the Android framework responsible for generating the audio stream before it’s broadcasted to the actual hardware(HDMI, headphone jack, etc.). This new approach brings in a lot of other improvements:\n• Increased audio quality (stereo PCM 48kHz - Lossless Audio)\n• Support for DRM content (streaming services)\n• Support for volume control in Android (available in the Android Settings app)"),
      ChangelogItem(
          title: "Flutter app",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
              "The Flutter App has been refactored to improve stability. Here are some of the changes:\n• WebSockets handling for Tesla Android services has been improved.\n• Thanks to the new transport layer, the Virtual Display component is now powered by Flutter. This significantly improves stability when compared to the previously used Iframe-based approach.\n• The connectivity state observer component has been introduced. The app will notify you when it wouldn’t be able to access Tesla Android services. This change ensures you will not have to manually reload the app when your car returns from sleep or the hardware itself restarts.\n• Flutter Framework has been updated to version 3.3.10"),
      ChangelogItem(
          title: "USB tethering for iOS",
          shortDescription: "Connectivity improvements",
          descriptionMarkdown:
              "Version 2023.4.1 adds support for sharing the internet from iOS devices via USB. Connect your phone, enable tethering and accept the USB access permission request on your iPhone."),
      ChangelogItem(
          title: "LTE Modem support",
          shortDescription: "Connectivity improvements",
          descriptionMarkdown:
              "This update introduces a new Android system service. The Tesla Android USB Networking Initializer simplifies how USB Modems are initialized and allows the use of per-device configuration scripts. This change resolved issues with some variants of Alcatel devices and added support for more Huawei modems."),
    ]),
    Version(
      versionName: "2022.45.1",
      changelogItems: [
        ChangelogItem(
          title: "Google Apps",
          shortDescription: "Usability improvements",
          descriptionMarkdown:
              "Version 2022.45.1 brings back Google Play Store and other Google Services that were removed in 2022.25.1. Device ID registration for Google Play is not longer required. Not all apps can be installed using Google Play Store due to lack of device certification, they need to be installed manually.",
        ),
        ChangelogItem(
          title: "Android Platform",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
              "Tesla Android system services initialisation has been improved, all components(web server, touchscreen, display etc.) will automatically restart on failure. In previous versions a full system reboot would be needed in this scenario.",
        ),
        ChangelogItem(
          title: "Virtual display",
          shortDescription: "DRM playback",
          descriptionMarkdown:
              "Version 2022.45.1 fixes DRM video playback and enables access to secure layers that are usually blacked out in screen capture.",
        ),
        ChangelogItem(
          title: "CarPlay",
          shortDescription: "Visual improvements",
          descriptionMarkdown:
              "Three row layout for CarPlay is now selected as default.",
        ),
        ChangelogItem(
          title: "Virtual touchscreen",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
              "Flutter app no longer displays information about virtual touchscreen initialisation, it is irrelevant for the single board stack and should have been removed earlier.",
        ),
        ChangelogItem(
          title: "Bluetooth",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
              "Restarting the system after disabling Bluetooth is no longer required.",
        ),
        ChangelogItem(
          title: "Internet access",
          shortDescription: "USB tethering for Android",
          descriptionMarkdown:
              "USB tethering from Android phones is now supported in Tesla Android. No configuration is required to enable this feature. Your Android phone will be detected as an external ethernet interface when you enable tethering.",
        ),
        ChangelogItem(
          title: "Internet access",
          shortDescription: "LTE modem support",
          descriptionMarkdown:
              "2022.45.1 introduces support for USB network devices using the cdc_ncm driver - it has been validated and works without any additional steps from the user. Experimental changes that might enable support for cdc_mbim and rndis_host drivers are also included. Previous versions supported only the cdc_ether driver.",
        ),
        ChangelogItem(
          title: "Internet access",
          shortDescription: "Support for external routers",
          descriptionMarkdown:
              "Tesla Android webserver and other services can now be accessed externally using ethernet. This can be used to access the device in your home network or in the car with an external router.",
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
              "Tesla Android does not need the hardware HDMI capture interface anymore. Updated video layer also uses less resources.",
        ),
        ChangelogItem(
          title: "Single system image",
          shortDescription: "Setup improvements",
          descriptionMarkdown:
              "Starting with version 2022.44.1 there is a new way to install Tesla Android.\n\nNew single image setup process that does not need adb or fastboot. This change requires a 64GB(or larger) SD card.",
        ),
        ChangelogItem(
          title: "LTE",
          shortDescription: "Fixes for Huawei E3372",
          descriptionMarkdown:
              "Previous release broke support for Huawei E3372. This issue is now resolved.",
        ),
        ChangelogItem(
          title: "Android platform",
          shortDescription: "Boot time improvements",
          descriptionMarkdown:
              "Version 2022.44.1 includes multiple internal optimisations that allow for your Tesla Android to boot up faster after the car wakes from sleep.",
        ),
        ChangelogItem(
          title: "Virtual display",
          shortDescription: "Performance and quality improvements",
          descriptionMarkdown:
              "Virtual display resolution has been increased to enable high fidelity Android experience in your Tesla.\n\nThe responsiveness is also improved thanks to internal changes in the video layer.",
        ),
        ChangelogItem(
          title: "CarPlay",
          shortDescription: "Performance improvements",
          descriptionMarkdown:
              "Improvements in the video layer leave more performance for other components.\n\nDecoding video stream from CarPlay is faster in version 2022.44.1.",
        ),
        ChangelogItem(
          title: "Flutter Frontend",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
              "Flutter frameworks has been updated in order to improve user experience.",
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
              "Tesla Android does not need two Raspberry Pi boards anymore!\n\nVersion 2022.38.1 is based only on Android.\n\nThis marks a significant milestone for the project and greatly lowers the barrier of entry both in terms of cost and ease of setup.",
        ),
        ChangelogItem(
          title: "Browser Audio",
          shortDescription: "Stability and volume improvements",
          descriptionMarkdown:
              "Version 2022.38.1 brings fixes to the browser audio streaming module.\n\nThe output volume has been adjusted to match Bluetooth music playback when using CarPlay.\n\nAudio capture service on Android is now a persistent system service that doesn't need to request permissions and automatically restarts on failure.\n\nBandwidth consumption has been significantly reduced when the music is not playing.",
        ),
        ChangelogItem(
          title: "Offline Mode",
          shortDescription: "Support for the Chinese market and bugfixes",
          descriptionMarkdown:
              "Single board stack includes an updated version of the Offline mode introduced in version 2022.27.1. Connectivity is now handled directly within the Android system, Pi-hole is no longer required.\n\nThanks to the community input Tesla Android works better in China - version 2022.38.1 includes fixes for connection dropouts due to different API endpoints in this market.",
        ),
        ChangelogItem(
          title: "Wi-Fi",
          shortDescription: "Hotspot improvements",
          descriptionMarkdown:
              "With Tesla Android Single Board you can now manage your Hotspot settings directly in your Tesla.\n\nUpdating your network name and credentials is now possible in the Android Settings app.",
        ),
        ChangelogItem(
          title: "Virtual display",
          shortDescription: "Backend improvements and bugfixes",
          descriptionMarkdown:
              "Starting with version 2022.38.1 Tesla Android does not use Ustreamer for video streaming.\n\nSingle board stack uses a modified version of mjpg_streamer built with Android NDK.\n\nThe new solution is modular and was chosen with bringing direct framebuffer capture to Tesla Android in mind.\n\nResolution of the virtual display has been updated to match the Tesla Browser viewport introduced with Tesla Version 2022.24.",
        ),
        ChangelogItem(
          title: "Flutter Frontend",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
              "Flutter Frontend has been updated in order to improve user experience.\n\nFramework version has been bumped to 3.3.",
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
              "Starting with version 2022.27.1 the LTE modem is not required for Tesla Android to maintain connection with your car.\n\nKeep in mind that certain online features might not be available in your car as it expects the Wi-Fi network to replace the connectivity provided by Tesla.\n\nWhen using the Offline Mode turning off Wi-Fi on your touchscreen or powering off Tesla Android is required for accessing your car with the Tesla Mobile App while parked.\n\nTesla Android can still be used to provide internet to your car like in previous build - no extra configuration changes are required.",
        ),
        ChangelogItem(
          title: "Wi-Fi",
          shortDescription: "Persistent connection with your Tesla",
          descriptionMarkdown:
              "As a result of introducing the new Offline Mode Wi-Fi stability and connection times have been significantly improved.\n\nIf you use the (now optional) LTE modem to get a full Android experience your Wi-Fi with the car won't disconnect when there is no LTE coverage(highways, underground parking etc)",
        ),
        ChangelogItem(
          title: "Virtual display",
          shortDescription: "Quality improvements",
          descriptionMarkdown:
              "Video stream quality has been slightly improved after reducing the image compression.",
        ),
        ChangelogItem(
          title: "Flutter Frontend",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
              "Flutter Frontend has been updated in order to improve user experience.\nFramework version has been bumped to 3.0.4. Rendering engine has been switched to HTML from CanvasKit due to problems with offline loading in Flutter.",
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
              "Display component has been refactored in order to allow up to 60Hz refresh rate.\n\nTesla Android will now behave normally when loaded in Drive or Reverse.\n\nSimplification of video stack improves stability of the Flutter application running in the Tesla Browser.",
        ),
        ChangelogItem(
          title: "Audio Output",
          shortDescription: "Combined audio streams",
          descriptionMarkdown:
              "Audio from Android is routed directly to your Tesla Browser.\n\nPlayback is allowed even when Drive or Reverse is engaged, meaning that there is no need to pair Tesla Android with your car using Bluetooth(Bluetooth link with the car is only used by your phone for Android Auto or CarPlay).\n\nAudio output from Tesla Browser does not pause media playback from Tesla OS or CarPlay. \n\nIn order to active this feature open Audio Capture app on your Tesla Android after installing the OS. It will automatically launch on each boot later. Audio Capture can be terminated using a button present in the status notification.\n\nNot all apps support audio capture, this restriction will be removed in a feature update.",
        ),
        ChangelogItem(
          title: "Flutter Frontend",
          shortDescription: "Stability improvements",
          descriptionMarkdown:
              "Flutter Frontend has been updated in order to improve user experience.\n\nLoading times have been improved significantly.\n\nAll major components of the app now have proper state management and error handling.",
        ),
        ChangelogItem(
          title: "Android Platform",
          shortDescription: "Move to Android 12.1",
          descriptionMarkdown:
              "Tesla Android has been migrated to Android 12.1 from AOSP Master in order to improve stability.\nRelease 2022.25.1 includes Android security updates up to May 5, 2022.",
        ),
        ChangelogItem(
          title: "Orientation lock",
          shortDescription: "All apps launch in landscape",
          descriptionMarkdown:
              "Tesla Android now includes a working orientation lock for third party apps.\n\nThis feature allows phone apps like Apple Music to launch in landscape.",
        ),
        ChangelogItem(
          title: "Google Play Store",
          shortDescription: "App discoverability",
          descriptionMarkdown:
              "Google Play Store has been replaced with Aurora Store, an Open Source alternative that includes Device Spoofing(emulating Google certification).\n\nGoogle Play Services have been replaced with microG(Open Source Google Apps).\n\nFDroid(Open Source App Store that does not rely on Google Play Store) is also included.",
        ),
        ChangelogItem(
          title: "Video Streaming",
          shortDescription: "DRM support",
          descriptionMarkdown:
              "Tesla Android now supports DRM video playback. Apps like Netflix function normally in version 2022.25.1",
        ),
        ChangelogItem(
          title: "CarPlay",
          shortDescription: "Audio/Video improvements",
          descriptionMarkdown:
              "Default resolution of CarPlay is a perfect match for Tesla Android in this release(no content overlapping in audio apps).\n\nNavigation sounds also work, however this feature is active only when Tesla Browser is active.",
        ),
        ChangelogItem(
          title: "CPU management",
          shortDescription: "Lower power consumption",
          descriptionMarkdown:
              "Release 2022.25.1 does not use the Performance CPU governor.\n\nCPU frequency is now scaled accordingly to CPU load.",
        ),
        ChangelogItem(
          title: "Setup",
          shortDescription: "Simplified device configuration",
          descriptionMarkdown:
              "Setup process of Tesla Android has been simplified, meaning several steps are no longer needed(obtaining a device identifier for Google Services, switching CarPlay resolution etc).",
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
              "Hello world!\nWelcome to the first Alpha of Tesla Android!\nGetting to this point has been a long bumpy ride, I hope that you'll enjoy running Android Apps in your Tesla!\nBest regards, \nMichał Gapiński \n@mikegapinski",
        ),
      ],
    ),
  ]);

  Future<ReleaseNotes> getReleaseNotes() async {
    return Future.value(_releaseNotes);
  }
}
