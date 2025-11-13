import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/utils/logger.dart';
import 'package:tesla_android/feature/touchscreen/model/virtual_touchscreen_slot_state.dart';
import 'package:tesla_android/feature/touchscreen/model/virtual_touchscreen_command.dart';
import 'package:tesla_android/feature/touchscreen/transport/touchscreen_transport.dart';

@injectable
class TouchscreenCubit extends Cubit<bool> with Logger {
  final List<VirtualTouchscreenSlotState> slotsState =
      VirtualTouchscreenSlotState.generateSlots();
  final TouchScreenTransport _transport;

  TouchscreenCubit(this._transport) : super(false) {
    _transport.connect();
  }
  @override
  Future<void> close() {
    _transport.disconnect();
    log("close");
    return super.close();
  }

  void handlePointerDownEvent(
      PointerDownEvent event, BoxConstraints constraints, Size touchscreenSize) {
    final scaledPointerPosition =
        _scalePointerPosition(event.localPosition, constraints, touchscreenSize);
    final slot = _getFirstUnusedSlot();
    if (slot == null) return;
    slot.trackingId = event.pointer;
    slot.position = scaledPointerPosition;

    log("Pointer down, assigned slot ${slot.slotIndex}, trackingId ${slot.trackingId}");

    final command = VirtualTouchScreenCommand(
        absMtSlot: slot.slotIndex,
        absMtTrackingId: slot.trackingId,
        absMtPositionX: slot.position.dx.toInt(),
        absMtPositionY: slot.position.dy.toInt(),
        synReport: true);

    _transport.sendCommand(command);
  }

  void handlePointerMoveEvent(
      PointerMoveEvent event, BoxConstraints constraints, Size touchscreenSize) {
    final scaledPointerPosition =
        _scalePointerPosition(event.localPosition, constraints, touchscreenSize);
    final slot = _getSlotFromTrackingId(event.pointer);
    if (slot == null) return;
    slot.position = scaledPointerPosition;

    log("Pointer move, matched slot ${slot.slotIndex}, trackingId ${slot.trackingId}");

    final command = VirtualTouchScreenCommand(
        absMtSlot: slot.slotIndex,
        absMtPositionX: slot.position.dx.toInt(),
        absMtPositionY: slot.position.dy.toInt(),
        synReport: true);

    _transport.sendCommand(command);
  }

  void handlePointerUpEvent(PointerEvent event, BoxConstraints constraints) {
    final slot = _getSlotFromTrackingId(event.pointer);
    if (slot == null) return;

    log("Pointer up, matched slot ${slot.slotIndex}, trackingId ${slot.trackingId}");

    slot.trackingId = -1;

    final command = VirtualTouchScreenCommand(
        absMtSlot: slot.slotIndex,
        absMtTrackingId: slot.trackingId,
        synReport: true);

    _transport.sendCommand(command);
  }

  VirtualTouchscreenSlotState? _getFirstUnusedSlot() {
    for (final slot in slotsState..shuffle()) {
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

  Offset _scalePointerPosition(Offset position, BoxConstraints constraints, Size touchscreenSize) {
    final scaleX = touchscreenSize.width / constraints.maxWidth;
    final scaleY = touchscreenSize.height / constraints.maxHeight;

    var scaledOffset = position.scale(scaleX, scaleY);

    if (scaledOffset.dx.isNegative) {
      scaledOffset = Offset(0, scaledOffset.dy);
    }

    if (scaledOffset.dy.isNegative) {
      scaledOffset = Offset(scaledOffset.dx, 0);
    }
    return scaledOffset;
  }
}
