import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/network/health_service.dart';
import 'package:tesla_android/common/service/window_service.dart';
import 'package:tesla_android/feature/connectivityCheck/model/connectivity_state.dart';

@injectable
class ConnectivityCheckCubit extends Cubit<ConnectivityState> {
  final HealthService _healthService;
  final WindowService _windowService;

  @visibleForTesting
  void Function()? onReloadOverride;

  ConnectivityCheckCubit(this._healthService, this._windowService)
    : super(ConnectivityState.backendAccessible) {
    _observeBackendAccessibility();
  }

  static const _standardCheckInterval = Duration(seconds: 30);
  static const _offlineCheckInterval = Duration(seconds: 5);

  Timer? _standardTimer;
  Timer? _offlineTimer;

  void _observeBackendAccessibility() {
    _standardTimer = Timer.periodic(_standardCheckInterval, (timer) async {
      if (state == ConnectivityState.backendAccessible) {
        await checkConnectivity();
      }
    });
    _offlineTimer = Timer.periodic(_offlineCheckInterval, (timer) async {
      if (state != ConnectivityState.backendAccessible) {
        await checkConnectivity();
      }
    });
  }

  Future<void> checkConnectivity() async {
    try {
      await _healthService.getHealthCheck();
      _onRequestSuccess();
    } catch (_) {
      _onRequestFailure();
    }
  }

  void _onRequestFailure() async {
    if (!isClosed) emit(ConnectivityState.backendUnreachable);
  }

  void _onRequestSuccess() {
    if (state == ConnectivityState.backendUnreachable) {
      if (onReloadOverride != null) {
        onReloadOverride!();
      } else {
        _windowService.reload();
      }
    }
    if (!isClosed) {
      emit(ConnectivityState.backendAccessible);
    }
  }

  @override
  Future<void> close() {
    _standardTimer?.cancel();
    _offlineTimer?.cancel();
    return super.close();
  }
}
