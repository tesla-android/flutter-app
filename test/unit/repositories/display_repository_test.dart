import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesla_android/common/network/display_service.dart';
import 'package:tesla_android/feature/display/repository/display_repository.dart';
import '../../helpers/test_fixtures.dart';

import 'display_repository_test.mocks.dart';

@GenerateMocks([DisplayService, SharedPreferences])
void main() {
  late MockDisplayService mockService;
  late MockSharedPreferences mockPreferences;
  late DisplayRepository repository;

  setUp(() {
    mockService = MockDisplayService();
    mockPreferences = MockSharedPreferences();
    repository = DisplayRepository(mockService, mockPreferences);
  });

  group('DisplayRepository', () {
    test('getDisplayState returns display state from service', () async {
      when(
        mockService.getDisplayState(),
      ).thenAnswer((_) async => TestFixtures.defaultDisplayState);

      final result = await repository.getDisplayState();

      expect(result, equals(TestFixtures.defaultDisplayState));
      verify(mockService.getDisplayState()).called(1);
    });

    test('updateDisplayConfiguration calls service', () async {
      when(
        mockService.updateDisplayConfiguration(any),
      ).thenAnswer((_) async => {});

      await repository.updateDisplayConfiguration(
        TestFixtures.defaultDisplayState,
      );

      verify(
        mockService.updateDisplayConfiguration(
          TestFixtures.defaultDisplayState,
        ),
      ).called(1);
    });

    test('isPrimaryDisplay returns true when rear display disabled', () async {
      final stateWithoutRear = TestFixtures.defaultDisplayState.copyWith(
        isRearDisplayEnabled: 0,
      );
      when(
        mockService.getDisplayState(),
      ).thenAnswer((_) async => stateWithoutRear);

      final result = await repository.isPrimaryDisplay();

      expect(result, true);
    });

    test(
      'isPrimaryDisplay returns preference when rear display enabled',
      () async {
        final stateWithRear = TestFixtures.defaultDisplayState.copyWith(
          isRearDisplayEnabled: 1,
        );
        when(
          mockService.getDisplayState(),
        ).thenAnswer((_) async => stateWithRear);
        when(mockPreferences.getBool(any)).thenReturn(true);

        final result = await repository.isPrimaryDisplay();

        expect(result, true);
        verify(
          mockPreferences.getBool(
            'DisplayRepository_isPrimaryDisplaySharedPreferencesKey',
          ),
        ).called(1);
      },
    );

    test('isPrimaryDisplay returns null when preference not set', () async {
      final stateWithRear = TestFixtures.defaultDisplayState.copyWith(
        isRearDisplayEnabled: 1,
      );
      when(
        mockService.getDisplayState(),
      ).thenAnswer((_) async => stateWithRear);
      when(mockPreferences.getBool(any)).thenReturn(null);

      final result = await repository.isPrimaryDisplay();

      expect(result, null);
    });

    test('setDisplayType saves preference', () async {
      when(mockPreferences.setBool(any, any)).thenAnswer((_) async => true);

      await repository.setDisplayType(true);

      verify(
        mockPreferences.setBool(
          'DisplayRepository_isPrimaryDisplaySharedPreferencesKey',
          true,
        ),
      ).called(1);
    });

    test('setDisplayType can set false', () async {
      when(mockPreferences.setBool(any, any)).thenAnswer((_) async => true);

      await repository.setDisplayType(false);

      verify(
        mockPreferences.setBool(
          'DisplayRepository_isPrimaryDisplaySharedPreferencesKey',
          false,
        ),
      ).called(1);
    });

    test('handles service errors in getDisplayState', () async {
      when(mockService.getDisplayState()).thenThrow(Exception('Network error'));

      expect(() => repository.getDisplayState(), throwsException);
    });

    test('handles service errors in updateDisplayConfiguration', () async {
      when(
        mockService.updateDisplayConfiguration(any),
      ).thenThrow(Exception('Update failed'));

      expect(
        () => repository.updateDisplayConfiguration(
          TestFixtures.defaultDisplayState,
        ),
        throwsException,
      );
    });
  });
}
