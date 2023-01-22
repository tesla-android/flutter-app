import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart' show BehaviorSubject;
import 'package:tesla_android/feature/display/cubit/display_state.dart';
import 'package:tesla_android/feature/display/transport/display_transport.dart';
import 'package:web_socket_client/web_socket_client.dart';

@singleton
class DisplayCubit extends Cubit<DisplayState> {
  final DisplayTransport _transport;
  final BehaviorSubject<Uint8List> imageSubject = BehaviorSubject();

  StreamSubscription? _imageDataStreamSubscription;
  StreamSubscription? _webSocketConnectionStateStreamSubscription;

  DisplayCubit(this._transport) : super(DisplayState.initial) {
    _subscribeToImageDataSubject();
    _observeConnectionState();
  }

  @override
  Future<void> close() async {
    await _imageDataStreamSubscription?.cancel();
    await _webSocketConnectionStateStreamSubscription?.cancel();
    _transport.closeWebSocket();
    return super.close();
  }

  void _observeConnectionState() async {
    await _transport.connectWebSocket();
    _webSocketConnectionStateStreamSubscription =
        _transport.connectionStateSubject.listen((connectionState) {
      if (connectionState is Connected || connectionState is Reconnected) {
        return;
      }
      if (!isClosed) {
        emit(DisplayState.unreachable);
      }
    });
  }

  void _subscribeToImageDataSubject() {
    _imageDataStreamSubscription =
        _transport.imageDataSubject.listen((bytes) async {
      imageSubject.add(bytes);
      if (state != DisplayState.normal) {
        emit(DisplayState.normal);
      }
    });
  }
}
