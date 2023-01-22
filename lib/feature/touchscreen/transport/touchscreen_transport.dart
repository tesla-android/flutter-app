import 'package:flavor/flavor.dart';
import 'package:injectable/injectable.dart';
import 'package:web_socket_client/web_socket_client.dart';

@injectable
class TouchscreenTransport {
  final Flavor flavor;
  final Uri webSocketUri;

  static const String tag = "TouchScreenTransport: ";

  TouchscreenTransport(this.flavor)
      : webSocketUri = Uri.parse(flavor.getString(
          "touchscreenWebSocket",
        )!);

  WebSocket? _webSocket;

  Future<bool> connectWebSocket() async {
    _webSocket = WebSocket(webSocketUri,
        timeout: const Duration(seconds: 5),
        backoff: const ConstantBackoff(Duration(seconds: 1)));

    return _webSocket!.connection
        .firstWhere((state) => state is Connected)
        .timeout(const Duration(seconds: 5),
            onTimeout: () => const Disconnected())
        .then((value) => true)
        .onError((error, stackTrace) => false);
  }

  void closeWebSocket() {
    _webSocket?.close(1000);
    _webSocket = null;
  }

  void sendMessage(String message) {
    _webSocket?.send(message);
  }
}
