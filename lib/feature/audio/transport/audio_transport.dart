// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tesla_android/common/network/base_websocket_transport.dart';

@injectable
class AudioTransport extends BaseWebsocketTransport {
  final BehaviorSubject pcmDataSubject = BehaviorSubject();

  AudioTransport()
      : super(
          flavorUrlKey: "audioWebSocket",
          binaryType: "arraybuffer",
        );

  @override
  void onMessage(event) {
    pcmDataSubject.add(event);
    super.onMessage(event);
  }
}
