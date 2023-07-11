// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';
import 'package:tesla_android/common/network/base_websocket_transport.dart';

@injectable
class DisplayTransport extends BaseWebsocketTransport {
  final PublishSubject jpegDataSubject = PublishSubject();

  DisplayTransport()
      : super(
          flavorUrlKey: "displayWebSocket",
          sendKeepAlive: true,
        );

  @override
  void onMessage(MessageEvent event) {
    jpegDataSubject.add(event.data);
    super.onMessage(event);
  }
}
