import 'package:flutter_test/flutter_test.dart';
import 'package:tesla_android/feature/home/model/github_release.dart';
import 'package:tesla_android/feature/releaseNotes/model/changelog_item.dart';
import 'package:tesla_android/feature/releaseNotes/model/release_notes.dart';
import 'package:tesla_android/feature/releaseNotes/model/version.dart';
import 'package:tesla_android/feature/settings/model/system_configuration_response_body.dart';

void main() {
  group('Model Serialization Tests', () {
    group('GitHubRelease', () {
      test('fromJson creates correct instance', () {
        final json = {'name': 'v1.0.0'};
        final release = GitHubRelease.fromJson(json);
        expect(release.name, 'v1.0.0');
      });

      test('toJson creates correct map', () {
        const release = GitHubRelease(name: 'v1.0.0');
        expect(release.toJson(), {'name': 'v1.0.0'});
      });
    });

    group('ChangelogItem', () {
      test('fromJson creates correct instance', () {
        final json = {
          'title': 'Title',
          'shortDescription': 'Short',
          'descriptionMarkdown': 'Markdown',
        };
        final item = ChangelogItem.fromJson(json);
        expect(item.title, 'Title');
        expect(item.shortDescription, 'Short');
        expect(item.descriptionMarkdown, 'Markdown');
      });

      test('toJson creates correct map', () {
        const item = ChangelogItem(
          title: 'Title',
          shortDescription: 'Short',
          descriptionMarkdown: 'Markdown',
        );
        expect(item.toJson(), {
          'title': 'Title',
          'shortDescription': 'Short',
          'descriptionMarkdown': 'Markdown',
        });
      });
    });

    group('Version', () {
      test('fromJson creates correct instance', () {
        final json = {
          'versionName': '1.0.0',
          'changelogItems': [
            {
              'title': 'Title',
              'shortDescription': 'Short',
              'descriptionMarkdown': 'Markdown',
            },
          ],
        };
        final version = Version.fromJson(json);
        expect(version.versionName, '1.0.0');
        expect(version.changelogItems.length, 1);
        expect(version.changelogItems.first.title, 'Title');
      });

      test('toJson creates correct map', () {
        const version = Version(
          versionName: '1.0.0',
          changelogItems: [
            ChangelogItem(
              title: 'Title',
              shortDescription: 'Short',
              descriptionMarkdown: 'Markdown',
            ),
          ],
        );
        final json = version.toJson();
        expect(json['versionName'], '1.0.0');
        expect((json['changelogItems'] as List).length, 1);
      });
    });

    group('ReleaseNotes', () {
      test('fromJson creates correct instance', () {
        final json = {
          'versions': [
            {'versionName': '1.0.0', 'changelogItems': []},
          ],
        };
        final notes = ReleaseNotes.fromJson(json);
        expect(notes.versions.length, 1);
        expect(notes.versions.first.versionName, '1.0.0');
      });

      test('toJson creates correct map', () {
        const notes = ReleaseNotes(
          versions: [Version(versionName: '1.0.0', changelogItems: [])],
        );
        final json = notes.toJson();
        expect((json['versions'] as List).length, 1);
      });
    });

    group('SystemConfigurationResponseBody', () {
      test('fromJson creates correct instance', () {
        final json = {
          'persist.tesla-android.softap.band_type': 1,
          'persist.tesla-android.softap.channel': 6,
          'persist.tesla-android.softap.channel_width': 2,
          'persist.tesla-android.softap.is_enabled': 1,
          'persist.tesla-android.offline-mode.is_enabled': 0,
          'persist.tesla-android.offline-mode.telemetry.is_enabled': 1,
          'persist.tesla-android.offline-mode.tesla-firmware-downloads': 0,
          'persist.tesla-android.browser_audio.is_enabled': 1,
          'persist.tesla-android.browser_audio.volume': 100,
          'persist.tesla-android.gps.is_active': 1,
        };
        final config = SystemConfigurationResponseBody.fromJson(json);
        expect(config.bandType, 1);
        expect(config.channel, 6);
        expect(config.channelWidth, 2);
        expect(config.isEnabledFlag, 1);
        expect(config.isOfflineModeEnabledFlag, 0);
        expect(config.isOfflineModeTelemetryEnabledFlag, 1);
        expect(config.isOfflineModeTeslaFirmwareDownloadsEnabledFlag, 0);
        expect(config.browserAudioIsEnabled, 1);
        expect(config.browserAudioVolume, 100);
        expect(config.isGPSEnabled, 1);
      });

      test('toJson creates correct map', () {
        final config = SystemConfigurationResponseBody(
          bandType: 1,
          channel: 6,
          channelWidth: 2,
          isEnabledFlag: 1,
          isOfflineModeEnabledFlag: 0,
          isOfflineModeTelemetryEnabledFlag: 1,
          isOfflineModeTeslaFirmwareDownloadsEnabledFlag: 0,
          browserAudioIsEnabled: 1,
          browserAudioVolume: 100,
          isGPSEnabled: 1,
        );
        final json = config.toJson();
        expect(json['persist.tesla-android.softap.band_type'], 1);
        expect(json['persist.tesla-android.softap.channel'], 6);
      });

      test('copyWith creates new instance with updated values', () {
        final config = SystemConfigurationResponseBody(
          bandType: 1,
          channel: 6,
          channelWidth: 2,
          isEnabledFlag: 1,
          isOfflineModeEnabledFlag: 0,
          isOfflineModeTelemetryEnabledFlag: 1,
          isOfflineModeTeslaFirmwareDownloadsEnabledFlag: 0,
          browserAudioIsEnabled: 1,
          browserAudioVolume: 100,
          isGPSEnabled: 1,
        );
        final newConfig = config.copyWith(bandType: 2);
        expect(newConfig.bandType, 2);
        expect(newConfig.channel, 6); // Unchanged
      });
    });
  });
}
