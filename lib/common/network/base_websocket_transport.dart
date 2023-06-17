import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:flavor/flavor.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tesla_android/common/di/ta_locator.dart';
import 'package:tesla_android/common/utils/logger.dart';
import 'package:tesla_android/feature/connectivityCheck/cubit/connectivity_check_cubit.dart';
import 'package:tesla_android/feature/connectivityCheck/model/connectivity_state.dart';

abstract class BaseWebsocketTransport with Logger {
  final String flavorUrlKey;
  final String? binaryType;

  Flavor get _flavor => getIt<Flavor>();

  ConnectivityCheckCubit get _connectivityCheckCubit =>
      getIt<ConnectivityCheckCubit>();
  final BehaviorSubject<bool> connectionStateSubject =
      BehaviorSubject.seeded(false);

  ConnectivityState _connectivityState = ConnectivityState.initial;
  WebSocket? _webSocketChannel;
  bool _keepConnectionAlive = false;
  bool _waitingForConnectivityToRestore = false;

  BaseWebsocketTransport({required this.flavorUrlKey, this.binaryType}) {
    _observeConnectivityState();
    _maintainConnection();
  }

  void _observeConnectivityState() {
    _connectivityCheckCubit.stream.listen((newState) {
      _connectivityState = newState;
      if (_waitingForConnectivityToRestore &&
          _connectivityState == ConnectivityState.backendAccessible) {
        _maintainConnection();
        _waitingForConnectivityToRestore = false;
      } else if (_connectivityState == ConnectivityState.backendUnreachable &&
          connectionStateSubject.valueOrNull == true) {
        log("backendUnreachable");
        disconnect();
      }
    });
  }

  void _maintainConnection() {
    _keepConnectionAlive = true;
    _connect();
  }

  Future<void> _connect() async {
    if (_keepConnectionAlive) {
      _webSocketChannel = WebSocket(_flavor.getString(
        flavorUrlKey,
      )!);
      if (binaryType != null) {
        _webSocketChannel?.binaryType = binaryType;
      }
      _webSocketChannel?.onOpen.listen((event) {
        connectionStateSubject.add(true);
        log("open");
        onOpen();
      });
      _webSocketChannel?.onMessage.listen((MessageEvent e) {
        connectionStateSubject.add(true);
      });
      _webSocketChannel?.onClose.listen((event) {
        _reconnect();
      });
      _webSocketChannel?.onError.listen((event) {
        _reconnect();
      });
    }
  }

  void _reconnect() async {
    connectionStateSubject.add(false);
    if (_connectivityState == ConnectivityState.backendAccessible) {
      log("reconnecting");
      Future.delayed(const Duration(seconds: 1), _connect);
    } else {
      log("disconnecting, waiting for connectivity to restore");
      disconnect();
      _waitingForConnectivityToRestore = true;
    }
  }

  void onMessage(MessageEvent event) {
    // optional
  }

  void onOpen() {
    //optional
  }

  void send(dynamic message) {
    _webSocketChannel?.send(message);
  }

  void sendString(String string) {
    _webSocketChannel?.sendString(string);
  }

  void sendJson(object) {
    final jsonString = jsonEncode(object);
    sendString(jsonString);
  }

  void sendBlob(Blob blob) {
    _webSocketChannel?.sendBlob(blob);
  }

  void sendByteBuffer(ByteBuffer byteBuffer) {
    _webSocketChannel?.sendByteBuffer(byteBuffer);
  }

  void sendTypedData(TypedData typedData) {
    _webSocketChannel?.sendTypedData(typedData);
  }

  void disconnect() {
    _keepConnectionAlive = false;
    _webSocketChannel?.close();
    _webSocketChannel = null;
  }
}
