import 'dart:convert';
import 'dart:html';

import 'package:flavor/flavor.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tesla_android/feature/gps/model/gps_data.dart';

@injectable
class GpsTransport {
  final Flavor flavor;
  final Uri webSocketUri;
  final BehaviorSubject pcmDataSubject = BehaviorSubject();
  final BehaviorSubject<bool> connectionStateSubject =
      BehaviorSubject.seeded(false);

  static const String tag = "GpsTransport: ";

  GpsTransport(this.flavor)
      : webSocketUri = Uri.parse(flavor.getString(
          "gpsWebSocket",
        )!);

  WebSocket? _webSocketChannel;

  bool _keepConnectionAlive = false;

  void maintainConnection() {
    _keepConnectionAlive = true;
    _connect();
  }

  Future<void> _connect() async {
    if (_keepConnectionAlive) {
      _webSocketChannel = WebSocket(flavor.getString(
        "gpsWebSocket",
      )!);
      _webSocketChannel?.onOpen.listen((event) {
        connectionStateSubject.add(true);
      });
      _webSocketChannel?.onMessage.listen((MessageEvent e) {
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

  void sendGpsData(GpsData gpsData) async {
    if(connectionStateSubject.valueOrNull == true) {
      final jsonString = jsonEncode(gpsData.toJson());
      _webSocketChannel?.sendString(jsonString);
    } else {
      await Future.delayed(const Duration(seconds: 1), _connect);
      await Future.delayed(const Duration(seconds: 1), () => sendGpsData(gpsData));
    }
  }
}
