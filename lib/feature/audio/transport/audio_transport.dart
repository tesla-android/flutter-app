import 'dart:typed_data';

import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/html.dart';

@singleton
class AudioTransport {
  final Flavor flavor;
  final Uri webSocketUri;
  final BehaviorSubject<Uint8List> pcmDataSubject = BehaviorSubject();
  final BehaviorSubject<bool> connectionStateSubject = BehaviorSubject.seeded(false);

  static const String tag = "AudioTransport: ";

  AudioTransport(this.flavor)
      : webSocketUri = Uri.parse(flavor.getString(
    "audioWebSocket",
  )!);

  HtmlWebSocketChannel? _webSocketChannel;

  bool _keepConnectionAlive = false;

  void maintainConnection() {
    _keepConnectionAlive = true;
    _connect();
  }

  void _connect() {
    if(_keepConnectionAlive) {
        _webSocketChannel = HtmlWebSocketChannel.connect(webSocketUri);
        _webSocketChannel?.innerWebSocket.onOpen.listen((event) {
          connectionStateSubject.add(true);
        });
      _webSocketChannel?.stream.listen(
            (dynamic message) {
          pcmDataSubject.add(message);
          connectionStateSubject.add(true);
            },
        onDone: () {
          debugPrint('${tag}channel closed');
          connectionStateSubject.add(false);
          _connect();
        },
        onError: (error) {
          connectionStateSubject.add(false);
          _connect();
        },
      );

    }
  }

  void disconnect() {
    _keepConnectionAlive = false;
    _webSocketChannel?.sink.close();
    _webSocketChannel = null;
  }
}
