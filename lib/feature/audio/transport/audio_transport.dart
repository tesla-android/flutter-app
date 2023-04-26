import 'dart:html';
import 'dart:typed_data';

import 'package:flavor/flavor.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@singleton
class AudioTransport {
  final Flavor flavor;
  final Uri webSocketUri;
  final BehaviorSubject pcmDataSubject = BehaviorSubject();
  final BehaviorSubject<bool> connectionStateSubject =
      BehaviorSubject.seeded(false);

  static const String tag = "AudioTransport: ";

  AudioTransport(this.flavor)
      : webSocketUri = Uri.parse(flavor.getString(
          "audioWebSocket",
        )!);

  WebSocket? _webSocketChannel;

  bool _keepConnectionAlive = false;

  void maintainConnection() {
    _keepConnectionAlive = true;
    _connect();
  }

  void _connect() {
    if (_keepConnectionAlive) {
      _webSocketChannel = WebSocket(flavor.getString(
        "audioWebSocket",
      )!)
        ..binaryType = 'arraybuffer';
      _webSocketChannel?.onOpen.listen((event) {
        connectionStateSubject.add(true);
      });
      _webSocketChannel?.onMessage.listen((MessageEvent e) {
        ByteBuffer buf = e.data;
        pcmDataSubject.add(buf.asByteData());
        connectionStateSubject.add(true);
      });
      _webSocketChannel?.onClose.listen((event) {
        connectionStateSubject.add(false);
        _connect();
      });
      _webSocketChannel?.onError.listen((event) {
        connectionStateSubject.add(false);
        _connect();
      });
    }
  }

  void disconnect() {
    _keepConnectionAlive = false;
    _webSocketChannel?.close();
    _webSocketChannel = null;
  }
}
