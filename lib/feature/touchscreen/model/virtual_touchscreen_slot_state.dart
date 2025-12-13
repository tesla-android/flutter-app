import 'dart:ui';

class VirtualTouchscreenSlotState {
  int slotIndex; // 0-9
  int trackingId; // active pointer index or -1
  Offset position;

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
