import 'dart:ui';

const touchScreenMaxX = 1024.0;
const touchScreenMaxY = 768.0;

class PointerState {
  int trackingId;
  int multiTouchSlot;
  bool isBeingTouched;
  Offset position;

  PointerState(
      {required this.trackingId, this.multiTouchSlot = 0, required this.isBeingTouched, required this.position});

  @override
  String toString() {
    return "Index $trackingId, position: $position";
  }

  String toVirtualTouchScreenEvent() {
    return "s $multiTouchSlot\nX $_positionX\nY $_positionY\na $_isBeingTouchedFlag\ne 0\nS 0\n";
  }

  int get _isBeingTouchedFlag {
    return isBeingTouched ? 1 : 0;
  }

  int get _positionX {
    return position.dx.toInt();
  }

  int get _positionY {
    return position.dy.toInt();
  }
}
