import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tesla_android/common/network/base_websocket_transport.dart';

@injectable
class DisplayTransport extends BaseWebsocketTransport {
  final BehaviorSubject videoData = BehaviorSubject();

  DisplayTransport()
      : super(
    flavorUrlKey: "displayWebSocket",
    binaryType: "arraybuffer",
  );

  @override
  void onMessage(event) {
    videoData.add(event);
    super.onMessage(event);
  }
}