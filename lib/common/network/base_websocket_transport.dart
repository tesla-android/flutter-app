import 'dart:async';
import 'dart:convert';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:math' show min;
import 'dart:typed_data';

import 'package:flavor/flavor.dart';
import 'package:tesla_android/common/di/ta_locator.dart';
import 'package:tesla_android/common/utils/logger.dart';
import 'package:tesla_android/feature/connectivityCheck/cubit/connectivity_check_cubit.dart';
import 'package:tesla_android/feature/connectivityCheck/model/connectivity_state.dart';

abstract class BaseWebsocketTransport with Logger {
  final String flavorUrlKey;
  final bool sendKeepAlive;
  String? binaryType;

  static const _disposeCloseCode = 3000;
  int _reconnectDelay = 1;

  Flavor get _flavor => getIt<Flavor>();

  ConnectivityCheckCubit get _connectivityCheckCubit =>
      getIt<ConnectivityCheckCubit>();

  ConnectivityState _connectivityState = ConnectivityState.backendAccessible;
  WebSocket? _webSocketChannel;
  Timer? _keepAliveTimer;
  bool _keepConnectionAlive = false;
  bool _waitingForConnectivityToRestore = false;

  bool get _isConnected => _webSocketChannel?.readyState == WebSocket.OPEN;

  BaseWebsocketTransport({
    required this.flavorUrlKey,
    this.binaryType,
    this.sendKeepAlive = false,
  });

  void connect() {
    _observeConnectivityState();
    _maintainConnection();
    _sendKeepAliveMessages();
  }

  void disconnect() {
    _keepConnectionAlive = false;
    _keepAliveTimer?.cancel();
    _webSocketChannel?.close(_disposeCloseCode);
    _webSocketChannel = null;
  }

  void changeBinaryType(String newBinaryType) {
    binaryType = newBinaryType;
    _webSocketChannel?.binaryType = newBinaryType;
  }

  void _observeConnectivityState() {
    _connectivityCheckCubit.stream.listen((newState) {
      _connectivityState = newState;
      if (_waitingForConnectivityToRestore &&
          _connectivityState == ConnectivityState.backendAccessible) {
        _maintainConnection();
        _waitingForConnectivityToRestore = false;
      } else if (_connectivityState == ConnectivityState.backendUnreachable &&
          _isConnected) {
        log("backendUnreachable");
        disconnect();
      }
    });
  }

  void _maintainConnection() {
    _keepConnectionAlive = true;
    _connect();
  }

  Future<void> _sendKeepAliveMessages() async {
    _keepAliveTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_keepConnectionAlive && sendKeepAlive && _isConnected) {
        sendString("ping");
      }
    });
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
        log("open");
        onOpen();
      });
      _webSocketChannel?.onMessage.listen((MessageEvent e) {
        onMessage(e);
      });
      _webSocketChannel?.onClose.listen((event) {
        if (event.code == _disposeCloseCode) {
          log("terminating");
        } else {
          _reconnect();
        }
      });
      _webSocketChannel?.onError.listen((event) {
        _reconnect();
      });
    }
  }

  void _reconnect() async {
    if (_connectivityState == ConnectivityState.backendAccessible) {
      log("reconnecting");
      Future.delayed(Duration(seconds: _reconnectDelay), _connect);
      _reconnectDelay = min(_reconnectDelay * 2, 60);
    } else {
      log("disconnecting, waiting for connectivity to restore");
      _keepConnectionAlive = false;
      _webSocketChannel?.close();
      _webSocketChannel = null;
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
    if (!_isConnected) return;
    _webSocketChannel?.send(message);
  }

  void sendString(String string) {
    if (!_isConnected) return;
    _webSocketChannel?.sendString(string);
  }

  void sendJson(object) {
    if (!_isConnected) return;
    final jsonString = jsonEncode(object);
    sendString(jsonString);
  }

  void sendBlob(Blob blob) {
    if (!_isConnected) return;
    _webSocketChannel?.sendBlob(blob);
  }

  void sendByteBuffer(ByteBuffer byteBuffer) {
    if (!_isConnected) return;
    _webSocketChannel?.sendByteBuffer(byteBuffer);
  }

  void sendTypedData(TypedData typedData) {
    if (!_isConnected) return;
    _webSocketChannel?.sendTypedData(typedData);
  }
}
