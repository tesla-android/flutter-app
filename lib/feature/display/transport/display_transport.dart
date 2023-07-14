// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';
import 'package:tesla_android/common/network/base_websocket_transport.dart';

@injectable
class DisplayTransportBlob extends BaseWebsocketTransport {
  final PublishSubject jpegDataSubject = PublishSubject();

  DisplayTransportBlob()
      : super(
          flavorUrlKey: "displayWebSocket",
          sendKeepAlive: true,
          binaryType: "blob"
        );

  @override
  void onMessage(event) {
    jpegDataSubject.add(event);
    super.onMessage(event);
  }
}

@lazySingleton
class DisplayTransportArrayBuffer extends BaseWebsocketTransport {
  final PublishSubject jpegDataSubject = PublishSubject();

  DisplayTransportArrayBuffer()
      : super(
      flavorUrlKey: "displayWebSocket",
      sendKeepAlive: true,
      binaryType: "arraybuffer"
  );

  @override
  void onMessage(event) {
    jpegDataSubject.add(event);
    super.onMessage(event);
  }
}
