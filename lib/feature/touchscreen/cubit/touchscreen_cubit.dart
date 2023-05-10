import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/ui/constants/ta_timing.dart';
import 'package:tesla_android/feature/touchscreen/model/virtual_touchscreen_slot_state.dart';
import 'package:tesla_android/feature/touchscreen/model/virtual_touchscreen_command.dart';
import 'package:tesla_android/feature/touchscreen/transport/touchscreen_transport.dart';

@singleton
class TouchscreenCubit extends Cubit<bool> {
  final List<VirtualTouchscreenSlotState> slotsState =
      VirtualTouchscreenSlotState.generateSlots();
  final TouchScreenTransport _transport;
  StreamSubscription<bool>? _streamSubscription;

  TouchscreenCubit(this._transport) : super(false) {
    _maintainWebSocketConnection();
    _reportInitialState();
  }

  @override
  Future<void> close() async {
    await _streamSubscription?.cancel();
    super.close();
  }

  Future<bool> waitForWebSocketConnection() {
    if (state) {
      return Future.value(true);
    } else {
      return Future.delayed(
          const Duration(seconds: 1), waitForWebSocketConnection);
    }
  }

  void _reportInitialState() async {
    await waitForWebSocketConnection();

    List<VirtualTouchScreenCommand> commands = [];
    for (final slot in slotsState) {
      commands.add(VirtualTouchScreenCommand(
          absMtSlot: slot.slotIndex, absMtTrackingId: slot.trackingId));
    }

    _sendCommands(commands: commands);
  }

  void handlePointerDownEvent(
      PointerDownEvent event, BoxConstraints constraints) {
    final scaledPointerPosition =
        _scalePointerPosition(event.localPosition, constraints);
    final slot = _getFirstUnusedSlot();
    if (slot == null) return;
    slot.trackingId = event.pointer;
    slot.position = scaledPointerPosition;

    debugPrint(
        "Pointer down, assigned slot ${slot.slotIndex}, trackingId ${slot.trackingId}");

    final command = VirtualTouchScreenCommand(
        absMtSlot: slot.slotIndex,
        absMtTrackingId: slot.trackingId,
        absMtPositionX: slot.position.dx.toInt(),
        absMtPositionY: slot.position.dy.toInt(),
        synReport: true);

    _transport.sendMessage(command.build());
  }

  void handlePointerMoveEvent(
      PointerMoveEvent event, BoxConstraints constraints) {
    final scaledPointerPosition =
        _scalePointerPosition(event.localPosition, constraints);
    final slot = _getSlotFromTrackingId(event.pointer);
    if (slot == null) return;
    slot.position = scaledPointerPosition;

    debugPrint(
        "Pointer move, matched slot ${slot.slotIndex}, trackingId ${slot.trackingId}");

    final command = VirtualTouchScreenCommand(
        absMtSlot: slot.slotIndex,
        absMtPositionX: slot.position.dx.toInt(),
        absMtPositionY: slot.position.dy.toInt(),
        synReport: true);

    _transport.sendMessage(command.build());
  }

  void handlePointerUpEvent(PointerEvent event, BoxConstraints constraints) {
    final slot = _getSlotFromTrackingId(event.pointer);
    if (slot == null) return;

    debugPrint(
        "Pointer up, matched slot ${slot.slotIndex}, trackingId ${slot.trackingId}");

    slot.trackingId = -1;

    final command = VirtualTouchScreenCommand(
        absMtSlot: slot.slotIndex,
        absMtTrackingId: slot.trackingId,
        synReport: true);

    _transport.sendMessage(command.build());
  }

  VirtualTouchscreenSlotState? _getFirstUnusedSlot() {
    for (final slot in slotsState) {
      if (slot.trackingId == -1) {
        return slot;
      }
    }
    return null;
  }

  VirtualTouchscreenSlotState? _getSlotFromTrackingId(int trackingId) {
    for (final slot in slotsState) {
      if (slot.trackingId == trackingId) {
        return slot;
      }
    }
    return null;
  }

  Offset _scalePointerPosition(Offset position, BoxConstraints constraints) {
    final scaleX = touchScreenMaxX / constraints.maxWidth;
    final scaleY = touchScreenMaxY / constraints.maxHeight;

    var scaledOffset = position.scale(scaleX, scaleY);

    if (scaledOffset.dx.isNegative) {
      scaledOffset = Offset(0, scaledOffset.dy);
    }

    if (scaledOffset.dy.isNegative) {
      scaledOffset = Offset(scaledOffset.dx, 0);
    }
    return scaledOffset;
  }

  void _sendCommands({required List<VirtualTouchScreenCommand> commands}) {
    commands.add(VirtualTouchScreenCommand(synReport: true));

    var message = '';
    for (final command in commands) {
      message += command.build();
    }
    debugPrint(message);
    _transport.sendMessage(message);
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
