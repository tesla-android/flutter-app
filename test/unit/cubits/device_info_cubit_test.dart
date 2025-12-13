import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:tesla_android/feature/settings/bloc/device_info_cubit.dart';
import 'package:tesla_android/feature/settings/bloc/device_info_state.dart';
import 'package:tesla_android/feature/settings/repository/device_info_repository.dart';

import '../../helpers/test_fixtures.dart';
import 'device_info_cubit_test.mocks.dart';

@GenerateMocks([DeviceInfoRepository])
void main() {
  late MockDeviceInfoRepository mockRepository;

  setUp(() {
    mockRepository = MockDeviceInfoRepository();
  });

  group('DeviceInfoCubit', () {
    test('initial state is DeviceInfoStateInitial', () {
      final cubit = DeviceInfoCubit(mockRepository);
      expect(cubit.state, isA<DeviceInfoStateInitial>());
      cubit.close();
    });

    blocTest<DeviceInfoCubit, DeviceInfoState>(
      'fetchConfiguration emits Loading then Loaded on success',
      build: () {
        when(
          mockRepository.getDeviceInfo(),
        ).thenAnswer((_) async => TestFixtures.rpi4DeviceInfo);
        return DeviceInfoCubit(mockRepository);
      },
      act: (cubit) => cubit.fetchConfiguration(),
      expect: () => [
        isA<DeviceInfoStateLoading>(),
        isA<DeviceInfoStateLoaded>().having(
          (s) => s.deviceInfo,
          'deviceInfo',
          TestFixtures.rpi4DeviceInfo,
        ),
      ],
      verify: (cubit) {
        verify(mockRepository.getDeviceInfo()).called(1);
      },
    );

    blocTest<DeviceInfoCubit, DeviceInfoState>(
      'fetchConfiguration emits Loading then Error on failure',
      build: () {
        when(
          mockRepository.getDeviceInfo(),
        ).thenThrow(Exception('Network error'));
        return DeviceInfoCubit(mockRepository);
      },
      act: (cubit) => cubit.fetchConfiguration(),
      expect: () => [
        isA<DeviceInfoStateLoading>(),
        isA<DeviceInfoStateError>(),
      ],
    );
  });
}
