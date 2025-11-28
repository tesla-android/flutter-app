import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/network/base_websocket_transport.dart';

@injectable
class GpsTransport extends BaseWebsocketTransport {
  GpsTransport() : super(flavorUrlKey: "gpsWebSocket");
}