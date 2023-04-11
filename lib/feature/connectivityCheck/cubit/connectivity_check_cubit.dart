import 'dart:async';
import 'dart:html';

import 'package:flavor/flavor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tesla_android/feature/connectivityCheck/model/connectivity_state.dart';
import 'package:http/http.dart' as http;

@singleton
class ConnectivityCheckCubit extends Cubit<ConnectivityState> {
  final Flavor flavor;

  ConnectivityCheckCubit(this.flavor) : super(ConnectivityState.initial) {
    _observeBackendAccessibility();
  }

  static const _connectivityTimeoutDuration = Duration(seconds: 5);
  static const _requestTimeoutDuration = Duration(seconds: 10);

  void _observeBackendAccessibility() {
    _checkConnectivity();
    Timer.periodic(_connectivityTimeoutDuration, (timer) async {
      _checkConnectivity();
    });
  }

  void _checkConnectivity() async {
    final uri = Uri.parse(flavor.getString("connectivityCheck")!);

    try {
      final response = await http.get(uri).timeout(_requestTimeoutDuration);
      if (response.statusCode != 200) {
        _onRequestFailure();
      } else {
        _onRequestSuccess();
      }
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
