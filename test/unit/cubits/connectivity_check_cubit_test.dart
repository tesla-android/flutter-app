import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tesla_android/common/network/health_service.dart';
import 'package:tesla_android/common/service/window_service.dart';
import 'package:tesla_android/feature/connectivityCheck/cubit/connectivity_check_cubit.dart';
import 'package:tesla_android/feature/connectivityCheck/model/connectivity_state.dart';

import 'connectivity_check_cubit_test.mocks.dart';

@GenerateMocks([HealthService, WindowService])
void main() {
  late MockHealthService mockHealthService;
  late MockWindowService mockWindowService;

  setUp(() {
    mockHealthService = MockHealthService();
    mockWindowService = MockWindowService();
  });

  group('ConnectivityCheckCubit', () {
    test('initial state is backendAccessible', () {
      when(mockHealthService.getHealthCheck()).thenAnswer((_) async => {});

      final cubit = ConnectivityCheckCubit(
        mockHealthService,
        mockWindowService,
      );
      cubit.onReloadOverride = () {};
      expect(cubit.state, ConnectivityState.backendAccessible);
      cubit.close();
    });

    blocTest<ConnectivityCheckCubit, ConnectivityState>(
      'checkConnectivity emits backendAccessible on success',
      build: () {
        when(mockHealthService.getHealthCheck()).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 10));
          return {};
        });
        final cubit = ConnectivityCheckCubit(
          mockHealthService,
          mockWindowService,
        );
        cubit.onReloadOverride = () {};
        return cubit;
      },
      act: (cubit) async => await cubit.checkConnectivity(),
      wait: const Duration(milliseconds: 3000),
      expect: () => [
        // Initial check in constructor already verified accessibility
        // Manual checkConnectivity maintains state
        ConnectivityState.backendAccessible,
      ],
    );

    blocTest<ConnectivityCheckCubit, ConnectivityState>(
      'checkConnectivity emits backendUnreachable on failure',
      build: () {
        when(mockHealthService.getHealthCheck()).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 10));
          throw Exception('Network error');
        });
        final cubit = ConnectivityCheckCubit(
          mockHealthService,
          mockWindowService,
        );
        cubit.onReloadOverride = () {};
        return cubit;
      },
      act: (cubit) async => await cubit.checkConnectivity(),
      wait: const Duration(milliseconds: 3000),
      expect: () => [ConnectivityState.backendUnreachable],
    );

    blocTest<ConnectivityCheckCubit, ConnectivityState>(
      'transitions from unreachable to accessible when health check succeeds',
      build: () {
        // First call fails, second succeeds
        var callCount = 0;
        when(mockHealthService.getHealthCheck()).thenAnswer((_) async {
          callCount++;
          if (callCount == 1) {
            throw Exception('Network error');
          }
          return {};
        });
        final cubit = ConnectivityCheckCubit(
          mockHealthService,
          mockWindowService,
        );
        cubit.onReloadOverride = () {};
        return cubit;
      },
      act: (cubit) async {
        await Future.delayed(const Duration(milliseconds: 3000));
        await cubit.checkConnectivity(); // This will succeed
      },
      wait: const Duration(milliseconds: 3000),
      expect: () => [
        ConnectivityState.backendUnreachable,
        // Note: In real cubit, this triggers window.location.reload()
        // which can't be tested in VM, so we just verify the state change
        ConnectivityState.backendAccessible,
      ],
    );

    blocTest<ConnectivityCheckCubit, ConnectivityState>(
      'maintains backendAccessible state on subsequent successes',
      build: () {
        when(mockHealthService.getHealthCheck()).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 10));
          return {};
        });
        final cubit = ConnectivityCheckCubit(
          mockHealthService,
          mockWindowService,
        );
        cubit.onReloadOverride = () {};
        return cubit;
      },
      act: (cubit) async {
        await Future.delayed(const Duration(milliseconds: 3000));
        await cubit.checkConnectivity();
        await Future.delayed(const Duration(milliseconds: 3000));
        await cubit.checkConnectivity();
      },
      wait: const Duration(milliseconds: 3000),
      expect: () => [ConnectivityState.backendAccessible],
    );

    blocTest<ConnectivityCheckCubit, ConnectivityState>(
      'handles intermittent failures correctly',
      build: () {
        var callCount = 0;
        when(mockHealthService.getHealthCheck()).thenAnswer((_) async {
          callCount++;
          if (callCount == 2) {
            throw Exception('Temporary network error');
          }
          return {};
        });
        final cubit = ConnectivityCheckCubit(
          mockHealthService,
          mockWindowService,
        );
        cubit.onReloadOverride = () {};
        return cubit;
      },
      act: (cubit) async {
        await Future.delayed(const Duration(milliseconds: 3000));
        await Future.delayed(const Duration(milliseconds: 3000));
        await cubit.checkConnectivity(); // Fails
        await Future.delayed(const Duration(milliseconds: 3000));
        await cubit.checkConnectivity(); // Succeeds
      },
      wait: const Duration(milliseconds: 3000),
      expect: () => [
        ConnectivityState.backendAccessible, // Initial
        ConnectivityState.backendUnreachable, // After failure
        ConnectivityState.backendAccessible, // After recovery
      ],
    );

    test('cubit can be closed properly', () async {
      when(mockHealthService.getHealthCheck()).thenAnswer((_) async => {});

      final cubit = ConnectivityCheckCubit(
        mockHealthService,
        mockWindowService,
      );
      await cubit.close();

      expect(cubit.isClosed, true);
    });

    group('Error Handling', () {
      blocTest<ConnectivityCheckCubit, ConnectivityState>(
        'handles timeout errors as unreachable',
        build: () {
          when(mockHealthService.getHealthCheck()).thenAnswer((_) async {
            await Future.delayed(const Duration(milliseconds: 10));
            throw TimeoutException('Request timeout');
          });
          final cubit = ConnectivityCheckCubit(
            mockHealthService,
            mockWindowService,
          );
          cubit.onReloadOverride = () {};
          return cubit;
        },
        act: (cubit) async => await cubit.checkConnectivity(),
        wait: const Duration(milliseconds: 3000),
        expect: () => [ConnectivityState.backendUnreachable],
      );

      blocTest<ConnectivityCheckCubit, ConnectivityState>(
        'handles HTTP errors as unreachable',
        build: () {
          when(mockHealthService.getHealthCheck()).thenAnswer((_) async {
            await Future.delayed(const Duration(milliseconds: 10));
            throw Exception('HTTP 500');
          });
          final cubit = ConnectivityCheckCubit(
            mockHealthService,
            mockWindowService,
          );
          cubit.onReloadOverride = () {};
          return cubit;
        },
        act: (cubit) async => await cubit.checkConnectivity(),
        wait: const Duration(milliseconds: 3000),
        expect: () => [ConnectivityState.backendUnreachable],
      );
    });
  });
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);

  @override
  String toString() => 'TimeoutException: $message';
}
