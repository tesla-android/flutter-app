import 'dart:async';
import 'dart:html';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/network/health_service.dart';
import 'package:tesla_android/feature/connectivityCheck/model/connectivity_state.dart';

@singleton
class ConnectivityCheckCubit extends Cubit<ConnectivityState> {
  final HealthService _healthService;

  ConnectivityCheckCubit(this._healthService)
      : super(ConnectivityState.initial) {
    _observeBackendAccessibility();
  }

  static const _connectivityTimeoutDuration = Duration(seconds: 30);

  void _observeBackendAccessibility() {
    _checkConnectivity();
    Timer.periodic(_connectivityTimeoutDuration, (timer) async {
      _checkConnectivity();
    });
  }

  void _checkConnectivity() async {
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
