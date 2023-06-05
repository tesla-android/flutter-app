# Tesla Android

Flutter app for Tesla Android.

Please refer to https://teslaandroid.com for release notes, hardware requirements and the install guide.

## Getting Started

### What you need
- Raspberry Pi 4
- SD Card

### Setup
- [Install Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Install Android Studio](https://developer.android.com/studio/install)
- [Install Flutter and Dart plugins in Android Studio](https://flutter.dev/docs/get-started/editor?tab=androidstudio)
<br><br>
- [Install the latest Tesla Android release on your Raspberry Pi 4](https://teslaandroid.com/install-guide)

## Run the app for development

In order to build this project for debugging connect to Tesla Android Wi-Fi network

You need to enable the setting ```_enableIpOverride``` inside ```lib/common/di/app_module.dart``` 
<br><br>
You also need to set the ```hostname``` inside ```web/player.html``` to the IP of your Tesla Android device (probably ```100.64.255.1```)

and run the following commands:

```
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter build web
```

After that you can run the app in a browser.

#### Please consider supporting the project: 

[Donations](https://teslaandroid.eu/donations)

