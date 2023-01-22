import 'dart:async';
import 'dart:html';
import 'dart:typed_data';

import 'package:flavor/flavor.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart' show BehaviorSubject;
import 'package:web_socket_channel/status.dart';
import 'package:web_socket_client/web_socket_client.dart';

@injectable
class DisplayTransport {
  final Flavor flavor;
  final Uri webSocketUri;
  final BehaviorSubject<Uint8List> imageDataSubject = BehaviorSubject();
  final BehaviorSubject<ConnectionState> connectionStateSubject =
      BehaviorSubject();

  static const String tag = "DisplayTransport: ";

  DisplayTransport(this.flavor)
      : webSocketUri = Uri.parse(flavor.getString(
          "displayWebSocket",
        )!);

  WebSocket? _webSocket;

  Future<bool> connectWebSocket() async {
    _webSocket = WebSocket(webSocketUri,
        timeout: const Duration(seconds: 5),
        backoff: const ConstantBackoff(Duration(seconds: 1)));
    _webSocket?.connection.listen((state) {
      connectionStateSubject.add(state);
    });
    _webSocket?.messages.listen((message) {
      if (message is Blob) {
        final FileReader reader = FileReader();
        reader.onLoad.listen((e) {
          imageDataSubject.add(Uint8List.fromList(reader.result! as List<int>));
        });
        reader.readAsArrayBuffer(message);
      }
    });

    return _webSocket!.connection
        .firstWhere((state) => state is Connected)
        .timeout(const Duration(seconds: 5), onTimeout: () => const Disconnected())
        .then((value) => true)
        .onError((error, stackTrace) => false);
  }

  void closeWebSocket() {
    _webSocket?.close(1000);
    _webSocket = null;
  }
}
