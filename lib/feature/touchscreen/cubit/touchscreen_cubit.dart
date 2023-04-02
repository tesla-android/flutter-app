import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/ui/constants/ta_timing.dart';
import 'package:tesla_android/feature/touchscreen/model/pointer_state.dart';
import 'package:tesla_android/feature/touchscreen/transport/touchscreen_transport.dart';

@injectable
class TouchscreenCubit extends Cubit<bool> {
  final TouchScreenTransport _transport;
  StreamSubscription<bool>? _streamSubscription;

  TouchscreenCubit(this._transport) : super(false) {
    _maintainWebSocketConnection();
  }

  @override
  Future<void> close() async {
    await _streamSubscription?.cancel();
    super.close();
  }

  final Map<int, PointerState> _activePointers = {};
  static const int _maxSlots = 10;
  int _slotCounter = -1;

  void dispatchTouchEvent(int index, Offset offset, bool isBeingTouched,
      BoxConstraints constraints) {
    if (isBeingTouched) {
      if (!_activePointers.containsKey(index)) {
        _slotCounter = (_slotCounter + 1) % _maxSlots;
        final newPointerState = PointerState(
          trackingId: _slotCounter,
          position: offset,
          isBeingTouched: isBeingTouched,
          multiTouchSlot: _slotCounter,
        );
        _activePointers[index] = newPointerState;
      }

      final scaleX = touchScreenMaxX / constraints.maxWidth;
      final scaleY = touchScreenMaxY / constraints.maxHeight;

      var scaledOffset = offset.scale(scaleX, scaleY);

      if (scaledOffset.dx.isNegative) {
        scaledOffset = Offset(0, scaledOffset.dy);
      }

      if (scaledOffset.dy.isNegative) {
        scaledOffset = Offset(scaledOffset.dx, 0);
      }

      _activePointers[index] = _activePointers[index]!.copyWith(
        position: scaledOffset,
      );
    } else {
      final pointerState = _activePointers.remove(index);
      if (pointerState != null) {
        final deactivatedPointerState = pointerState.copyWith(
          isBeingTouched: false,
          position: pointerState.position,
        );
        _transport
            .sendMessage(deactivatedPointerState.toVirtualTouchScreenEvent());
      }
    }
    _sendActivePointers(index, isBeingTouched);
  }

  void _sendActivePointers([int? index, bool? isBeingTouched]) {
    if (index != null) {
      final pointerState = _activePointers[index];
      if (pointerState != null) {
        _transport.sendMessage(pointerState.toVirtualTouchScreenEvent());
      }
    } else {
      for (var pointerState in _activePointers.values) {
        _transport.sendMessage(pointerState.toVirtualTouchScreenEvent());
      }
    }

    if (index != null && isBeingTouched != null && !isBeingTouched) {
      final deactivatedPointerState = PointerState(
        trackingId: _activePointers[index]?.trackingId ?? 0,
        position: Offset.zero,
        isBeingTouched: false,
        multiTouchSlot: _activePointers[index]?.multiTouchSlot ?? 0,
      );
      _transport
          .sendMessage(deactivatedPointerState.toVirtualTouchScreenEvent());
    }
  }

  void _maintainWebSocketConnection() {
    _transport.connectWebSocket();
    _streamSubscription =
        _transport.connectionStateSubject.stream.listen((connectionState) {
      if (!isClosed) {
        emit(connectionState);
      }
      if (!connectionState) {
        Future.delayed(TATiming.timeoutDuration, _maintainWebSocketConnection);
      }
    });
  }
}
