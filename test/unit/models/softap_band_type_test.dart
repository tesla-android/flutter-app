import 'package:flutter_test/flutter_test.dart';
import 'package:tesla_android/feature/settings/model/softap_band_type.dart';

void main() {
  group('SoftApBandType', () {
    test('matchBandTypeFromConfig returns correct type for 2.4GHz', () {
      final result = SoftApBandType.matchBandTypeFromConfig(
        band: 1,
        channel: 6,
        channelWidth: 2,
      );
      expect(result, SoftApBandType.band2_4GHz);
    });

    test('matchBandTypeFromConfig returns correct type for 5GHz channel 36', () {
      final result = SoftApBandType.matchBandTypeFromConfig(
        band: 2,
        channel: 36,
        channelWidth: 3,
      );
      expect(result, SoftApBandType.band5GHz36);
    });

    test('matchBandTypeFromConfig returns correct type for 5GHz channel 44', () {
      final result = SoftApBandType.matchBandTypeFromConfig(
        band: 2,
        channel: 44,
        channelWidth: 3,
      );
      expect(result, SoftApBandType.band5GHz44);
    });

    test('matchBandTypeFromConfig returns correct type for 5GHz channel 149', () {
      final result = SoftApBandType.matchBandTypeFromConfig(
        band: 2,
        channel: 149,
        channelWidth: 3,
      );
      expect(result, SoftApBandType.band5GHz149);
    });

    test('matchBandTypeFromConfig returns correct type for 5GHz channel 157', () {
      final result = SoftApBandType.matchBandTypeFromConfig(
        band: 2,
        channel: 157,
        channelWidth: 3,
      );
      expect(result, SoftApBandType.band5GHz157);
    });

    test('matchBandTypeFromConfig defaults to band5GHz36 for unknown channel', () {
      final result = SoftApBandType.matchBandTypeFromConfig(
        band: 2,
        channel: 999,
        channelWidth: 3,
      );
      expect(result, SoftApBandType.band5GHz36);
    });

    test('enum values have correct properties', () {
      expect(SoftApBandType.band2_4GHz.name, "2.4 GHz");
      expect(SoftApBandType.band2_4GHz.band, 1);
      
      expect(SoftApBandType.band5GHz36.name, "5 GHZ - Channel 36");
      expect(SoftApBandType.band5GHz36.band, 2);
    });
  });
}
