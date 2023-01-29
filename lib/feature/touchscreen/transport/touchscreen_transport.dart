import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/html.dart';

@injectable
class TouchScreenTransport {
  final Flavor flavor;
  final Uri webSocketUri;
  final BehaviorSubject<bool> connectionStateSubject =
      BehaviorSubject.seeded(false);

  static const String tag = "TouchScreenTransport: ";

  TouchScreenTransport(this.flavor)
      : webSocketUri = Uri.parse(flavor.getString(
          "touchscreenWebSocket",
        )!);

  HtmlWebSocketChannel? _webSocketChannel;

  var isConnecting = false;

  void connectWebSocket() {
    if (!isConnecting) {
      isConnecting = true;
      _webSocketChannel = HtmlWebSocketChannel.connect(webSocketUri);
      _webSocketChannel?.innerWebSocket.onOpen.listen((event) {
        connectionStateSubject.add(true);
        isConnecting = false;
      });
      _webSocketChannel?.stream.listen(
        (dynamic message) {
          debugPrint(tag + '$message');
          connectionStateSubject.add(true);
          isConnecting = false;
        },
        onDone: () {
          debugPrint(tag + 'channel closed');
          connectionStateSubject.add(false);
          isConnecting = false;
        },
        onError: (error) {
          debugPrint(tag + '$error');
          connectionStateSubject.add(false);
          isConnecting = false;
        },
      );
    }
  }

  void sendMessage(String message) {
    _webSocketChannel?.sink.add(message);
  }
}
