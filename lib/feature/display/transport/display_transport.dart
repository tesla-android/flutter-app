import 'dart:html';

import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';
import 'package:tesla_android/common/network/base_websocket_transport.dart';

@lazySingleton
class DisplayTransport extends BaseWebsocketTransport {
  final BehaviorSubject jpegDataSubject = BehaviorSubject();

  DisplayTransport()
      : super(
          flavorUrlKey: "displayWebSocket",
          binaryType: "arraybuffer",
          sendKeepAlive: true,
        );

  @override
  void onMessage(MessageEvent event) {
    jpegDataSubject.add(event.data);
    super.onMessage(event);
  }
}
