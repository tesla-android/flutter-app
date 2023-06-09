import 'dart:html';
import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tesla_android/common/network/base_websocket_transport.dart';

@injectable
class AudioTransport extends BaseWebsocketTransport {
  final BehaviorSubject pcmDataSubject = BehaviorSubject();

  AudioTransport()
      : super(flavorUrlKey: "audioWebSocket", binaryType: "arrayBuffer");

  @override
  void onMessage(MessageEvent event) {
    ByteBuffer buf = event.data;
    pcmDataSubject.add(buf.asByteData());
    super.onMessage(event);
  }
}