import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flavor/flavor.dart';
import 'package:tesla_android/common/di/ta_locator.dart';
import 'package:tesla_android/common/utils/logger.dart';
import 'package:web_socket_client/web_socket_client.dart';

abstract class BaseWebsocketTransport with Logger {
  final String flavorUrlKey;
  final bool sendKeepAlive;
  String? binaryType;

  Flavor get _flavor => getIt<Flavor>();

  WebSocket? _webSocketChannel;

  BaseWebsocketTransport({
    required this.flavorUrlKey,
    this.binaryType,
    this.sendKeepAlive = false,
  });

  bool get _isConnected =>
      _webSocketChannel?.connection.state is Connected ||
      _webSocketChannel?.connection.state is Reconnected;

  void connect() {
    if (_isConnected) {
      return;
    }
    _connect();
  }

  void disconnect() {
    _webSocketChannel?.close();
    _webSocketChannel = null;
  }

  Future<void> _connect() async {
    _webSocketChannel = WebSocket(
      Uri.parse(_flavor.getString(
        flavorUrlKey,
      )!),
      binaryType: binaryType ?? "blob",
      pingInterval: const Duration(seconds: 30),
      timeout: const Duration(seconds: 10),
      backoff: BinaryExponentialBackoff(
        initial: const Duration(seconds: 1),
        maximumStep: 10,
      ),
    );
    _webSocketChannel?.messages.listen((message) {
      onMessage(message);
    });
    _webSocketChannel?.connection.listen(
      (event) {
        if (event is Connected) {
          log("Connected");
        } else if (event is Connecting) {
          log("Connecting");
        } else if (event is Reconnected) {
          log("Reconnected");
        } else if (event is Reconnecting) {
          log("Reconnecting");
        } else if (event is Disconnected) {
          log("Disconnected");
        } else if (event is Disconnecting) {
          log("Disconnecting");
        }
      },
    );
  }

  void onMessage(event) {
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
    _webSocketChannel?.send(string);
  }

  void sendJson(object) {
    if (!_isConnected) return;
    final jsonString = jsonEncode(object);
    sendString(jsonString);
  }

  void sendBlob(blob) {
    if (!_isConnected) return;
    _webSocketChannel?.send(blob);
  }

  void sendByteBuffer(ByteBuffer byteBuffer) {
    if (!_isConnected) return;
    _webSocketChannel?.send(byteBuffer);
  }

  void sendTypedData(TypedData typedData) {
    if (!_isConnected) return;
    _webSocketChannel?.send(typedData);
  }
}
