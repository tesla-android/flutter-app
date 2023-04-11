import 'dart:ui';

const touchScreenMaxX = 1024.0;
const touchScreenMaxY = 768.0;

class VirtualTouchscreenSlotState {
  int slotIndex; // 0-9
  int trackingId; // active pointer index or -1
  Offset position;

  VirtualTouchscreenSlotState._({
    required this.slotIndex,
    required this.trackingId,
    required this.position,
  });

  VirtualTouchscreenSlotState.initial({required this.slotIndex})
      : trackingId = -1,
        position = Offset.zero;

  static List<VirtualTouchscreenSlotState> generateSlots() {
    return List.generate(
      10,
      (index) => VirtualTouchscreenSlotState.initial(slotIndex: index),
    );
  }
}
