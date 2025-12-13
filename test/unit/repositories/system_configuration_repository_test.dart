import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tesla_android/common/network/configuration_service.dart';
import 'package:tesla_android/feature/settings/repository/system_configuration_repository.dart';
import '../../helpers/test_fixtures.dart';

import 'system_configuration_repository_test.mocks.dart';

@GenerateMocks([ConfigurationService])
void main() {
  late MockConfigurationService mockService;
  late SystemConfigurationRepository repository;

  setUp(() {
    mockService = MockConfigurationService();
    repository = SystemConfigurationRepository(mockService);
  });

  group('SystemConfigurationRepository', () {
    test('getConfiguration returns configuration from service', () async {
      when(
        mockService.getConfiguration(),
      ).thenAnswer((_) async => TestFixtures.defaultConfiguration);

      final result = await repository.getConfiguration();

      expect(result, equals(TestFixtures.defaultConfiguration));
      verify(mockService.getConfiguration()).called(1);
    });

    test('setSoftApBand calls service with correct value', () async {
      when(mockService.setSoftApBand(2)).thenAnswer((_) async => {});

      await repository.setSoftApBand(2);

      verify(mockService.setSoftApBand(2)).called(1);
    });

    test('setSoftApChannel calls service with correct value', () async {
      when(mockService.setSoftApChannel(149)).thenAnswer((_) async => {});

      await repository.setSoftApChannel(149);

      verify(mockService.setSoftApChannel(149)).called(1);
    });

    test('setSoftApChannelWidth calls service with correct value', () async {
      when(mockService.setSoftApChannelWidth(160)).thenAnswer((_) async => {});

      await repository.setSoftApChannelWidth(160);

      verify(mockService.setSoftApChannelWidth(160)).called(1);
    });

    test('setSoftApState enables soft AP', () async {
      when(mockService.setSoftApState(1)).thenAnswer((_) async => {});

      await repository.setSoftApState(1);

      verify(mockService.setSoftApState(1)).called(1);
    });

    test('setSoftApState disables soft AP', () async {
      when(mockService.setSoftApState(0)).thenAnswer((_) async => {});

      await repository.setSoftApState(0);

      verify(mockService.setSoftApState(0)).called(1);
    });

    test('setOfflineModeState enables offline mode', () async {
      when(mockService.setOfflineModeState(1)).thenAnswer((_) async => {});

      await repository.setOfflineModeState(1);

      verify(mockService.setOfflineModeState(1)).called(1);
    });

    test('setBrowserAudioState enables audio', () async {
      when(mockService.setBrowserAudioState(1)).thenAnswer((_) async => {});

      await repository.setBrowserAudioState(1);

      verify(mockService.setBrowserAudioState(1)).called(1);
    });

    test('setBrowserAudioVolume sets volume level', () async {
      when(mockService.setBrowserAudioVolume(75)).thenAnswer((_) async => {});

      await repository.setBrowserAudioVolume(75);

      verify(mockService.setBrowserAudioVolume(75)).called(1);
    });

    test('setGPSState enables GPS', () async {
      when(mockService.setGPSState(1)).thenAnswer((_) async => {});

      await repository.setGPSState(1);

      verify(mockService.setGPSState(1)).called(1);
    });

    test('setGPSState disables GPS', () async {
      when(mockService.setGPSState(0)).thenAnswer((_) async => {});

      await repository.setGPSState(0);

      verify(mockService.setGPSState(0)).called(1);
    });

    test('handles service errors in getConfiguration', () async {
      when(
        mockService.getConfiguration(),
      ).thenThrow(Exception('Network error'));

      expect(() => repository.getConfiguration(), throwsException);
    });

    test('handles service errors in setSoftApBand', () async {
      when(
        mockService.setSoftApBand(any),
      ).thenThrow(Exception('Update failed'));

      expect(() => repository.setSoftApBand(2), throwsException);
    });

    test('handles service errors in setBrowserAudioVolume', () async {
      when(
        mockService.setBrowserAudioVolume(any),
      ).thenThrow(Exception('Update failed'));

      expect(() => repository.setBrowserAudioVolume(80), throwsException);
    });

    test('handles service errors in setGPSState', () async {
      when(mockService.setGPSState(any)).thenThrow(Exception('Update failed'));

      expect(() => repository.setGPSState(1), throwsException);
    });
  });
}
