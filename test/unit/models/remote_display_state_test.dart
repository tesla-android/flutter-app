import 'package:flutter_test/flutter_test.dart';
import 'package:tesla_android/feature/display/model/remote_display_state.dart';
import '../../helpers/test_fixtures.dart';

void main() {
  group('RemoteDisplayState', () {
    test('creates instance with required fields', () {
      final state = TestFixtures.defaultDisplayState;

      expect(state.width, 1920);
      expect(state.height, 1080);
      expect(state.density, 200);
      expect(state.resolutionPreset, DisplayResolutionModePreset.res832p);
      expect(state.renderer, DisplayRendererType.h264WebCodecs);
      expect(state.isH264, 1);
    });

    test('fromJson deserializes correctly', () {
      final state = RemoteDisplayState.fromJson(TestFixtures.displayStateJson);

      expect(state.width, 1920);
      expect(state.height, 1080);
      expect(state.density, 200);
      expect(state.resolutionPreset, DisplayResolutionModePreset.res832p);
      expect(state.renderer, DisplayRendererType.h264WebCodecs);
      expect(state.refreshRate, DisplayRefreshRatePreset.refresh30hz);
      expect(state.quality, DisplayQualityPreset.quality90);
    });

    test('toJson serializes correctly', () {
      final state = TestFixtures.defaultDisplayState;
      final json = state.toJson();

      expect(json['width'], 1920);
      expect(json['height'], 1080);
      expect(json['density'], 200);
      expect(json['resolutionPreset'], 0);
      expect(json['renderer'], 1);
      expect(json['isH264'], 1);
      expect(json['refreshRate'], 30);
      expect(json['quality'], 90);
    });

    test('equality works correctly', () {
      final state1 = TestFixtures.defaultDisplayState;
      final state2 = RemoteDisplayState(
        width: 1920,
        height: 1080,
        density: 200,
        resolutionPreset: DisplayResolutionModePreset.res832p,
        renderer: DisplayRendererType.h264WebCodecs,
        isResponsive: 1,
        isH264: 1,
        refreshRate: DisplayRefreshRatePreset.refresh30hz,
        quality: DisplayQualityPreset.quality90,
        isRearDisplayEnabled: 0,
        isRearDisplayPrioritised: 0,
        isHeadless: 0,
      );

      expect(state1, equals(state2));
    });

    test('copyWith creates new instance with updated fields', () {
      final original = TestFixtures.defaultDisplayState;
      final updated = original.copyWith(width: 1280, height: 720);

      expect(updated.width, 1280);
      expect(updated.height, 720);
      expect(updated.density, original.density); // unchanged
      expect(updated.renderer, original.renderer); // unchanged
    });

    test('updateResolution changes resolution preset and density', () {
      final original = TestFixtures.defaultDisplayState;
      final updated = original.updateResolution(
        newPreset: DisplayResolutionModePreset.res720p,
      );

      expect(updated.resolutionPreset, DisplayResolutionModePreset.res720p);
      expect(updated.density, 175); // h264 density for 720p
      expect(updated.width, original.width); // unchanged
      expect(updated.height, original.height); // unchanged
    });

    test('updateRenderer switches to MJPEG', () {
      final original = TestFixtures.defaultDisplayState;
      final updated = original.updateRenderer(
        newType: DisplayRendererType.mjpeg,
      );

      expect(updated.renderer, DisplayRendererType.mjpeg);
      expect(updated.isH264, 0);
    });

    test('updateRenderer switches to h264', () {
      final original = TestFixtures.mjpegDisplayState;
      final updated = original.updateRenderer(
        newType: DisplayRendererType.h264WebCodecs,
      );

      expect(updated.renderer, DisplayRendererType.h264WebCodecs);
      expect(updated.isH264, 1);
    });

    test('updateQuality changes quality preset', () {
      final original = TestFixtures.defaultDisplayState;
      final updated = original.updateQuality(
        newQuality: DisplayQualityPreset.quality70,
      );

      expect(updated.quality, DisplayQualityPreset.quality70);
    });

    test('updateRefreshRate changes refresh rate preset', () {
      final original = TestFixtures.defaultDisplayState;
      final updated = original.updateRefreshRate(
        newRefreshRate: DisplayRefreshRatePreset.refresh60hz,
      );

      expect(updated.refreshRate, DisplayRefreshRatePreset.refresh60hz);
    });
  });

  group('DisplayResolutionModePreset', () {
    test('maxHeight returns correct values', () {
      expect(DisplayResolutionModePreset.res832p.maxHeight(), 832);
      expect(DisplayResolutionModePreset.res720p.maxHeight(), 720);
      expect(DisplayResolutionModePreset.res640p.maxHeight(), 640);
      expect(DisplayResolutionModePreset.res544p.maxHeight(), 544);
      expect(DisplayResolutionModePreset.res480p.maxHeight(), 480);
    });

    test('density returns correct values for h264', () {
      expect(DisplayResolutionModePreset.res832p.density(isH264: true), 200);
      expect(DisplayResolutionModePreset.res720p.density(isH264: true), 175);
    });

    test('density returns correct values for MJPEG', () {
      expect(DisplayResolutionModePreset.res832p.density(isH264: false), 200);
      expect(DisplayResolutionModePreset.res720p.density(isH264: false), 175);
      expect(DisplayResolutionModePreset.res640p.density(isH264: false), 155);
      expect(DisplayResolutionModePreset.res544p.density(isH264: false), 130);
      expect(DisplayResolutionModePreset.res480p.density(isH264: false), 115);
    });

    test('name returns correct strings', () {
      expect(DisplayResolutionModePreset.res832p.name(), "832p");
      expect(DisplayResolutionModePreset.res720p.name(), "720p");
      expect(DisplayResolutionModePreset.res640p.name(), "640p");
      expect(DisplayResolutionModePreset.res544p.name(), "544p");
      expect(DisplayResolutionModePreset.res480p.name(), "480p");
    });
  });

  group('DisplayRendererType', () {
    test('name returns correct strings', () {
      expect(DisplayRendererType.mjpeg.name(), "Motion JPEG");
      expect(DisplayRendererType.h264WebCodecs.name(), "h264 (WebCodecs)");
      expect(DisplayRendererType.h264Brodway.name(), "h264 (legacy)");
    });

    test('resourcePath returns correct paths', () {
      expect(DisplayRendererType.mjpeg.resourcePath(), "mjpeg");
      expect(DisplayRendererType.h264WebCodecs.resourcePath(), "h264WebCodecs");
      expect(DisplayRendererType.h264Brodway.resourcePath(), "h264Brodway");
    });

    test('binaryType returns correct types', () {
      expect(DisplayRendererType.mjpeg.binaryType(), "blob");
      expect(DisplayRendererType.h264WebCodecs.binaryType(), "arraybuffer");
      expect(DisplayRendererType.h264Brodway.binaryType(), "arraybuffer");
    });
  });

  group('DisplayQualityPreset', () {
    test('value returns correct integers', () {
      expect(DisplayQualityPreset.quality40.value(), 40);
      expect(DisplayQualityPreset.quality50.value(), 50);
      expect(DisplayQualityPreset.quality90.value(), 90);
    });
  });

  group('DisplayRefreshRatePreset', () {
    test('value returns correct integers', () {
      expect(DisplayRefreshRatePreset.refresh30hz.value(), 30);
      expect(DisplayRefreshRatePreset.refresh45hz.value(), 45);
      expect(DisplayRefreshRatePreset.refresh60hz.value(), 60);
    });

    test('name returns correct strings', () {
      expect(DisplayRefreshRatePreset.refresh30hz.name(), "30 Hz");
      expect(DisplayRefreshRatePreset.refresh45hz.name(), "45 Hz");
      expect(DisplayRefreshRatePreset.refresh60hz.name(), "60 Hz");
    });
  });
}
