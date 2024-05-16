import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/network/health_service.dart';
import 'package:tesla_android/feature/connectivityCheck/model/connectivity_state.dart';
import 'package:web/web.dart';

@injectable
class ConnectivityCheckCubit extends Cubit<ConnectivityState> {
  final HealthService _healthService;

  ConnectivityCheckCubit(this._healthService)
      : super(ConnectivityState.backendAccessible) {
    _observeBackendAccessibility();
  }

  static const _standardCheckInterval = Duration(seconds: 30);
  static const _offlineCheckInterval = Duration(seconds: 5);

  void _observeBackendAccessibility() {
    checkConnectivity();
    Timer.periodic(_standardCheckInterval, (timer) async {
      if (state == ConnectivityState.backendAccessible) checkConnectivity();
    });
    Timer.periodic(_offlineCheckInterval, (timer) async {
      if (state != ConnectivityState.backendAccessible) checkConnectivity();
    });
  }

  void checkConnectivity() async {
    try {
      await _healthService.getHealthCheck();
      _onRequestSuccess();
    } catch (_) {
      _onRequestFailure();
    }
  }

  void _onRequestFailure() async {
    emit(ConnectivityState.backendUnreachable);
  }

  void _onRequestSuccess() {
    if (state == ConnectivityState.backendUnreachable) {
      window.location.reload();
    }
    emit(ConnectivityState.backendAccessible);
  }
}