import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/network/base_websocket_transport.dart';
import 'package:tesla_android/feature/touchscreen/model/virtual_touchscreen_command.dart';
import 'package:tesla_android/feature/touchscreen/model/virtual_touchscreen_slot_state.dart';

@injectable
class TouchScreenTransport extends BaseWebsocketTransport {
  TouchScreenTransport()
      : super(flavorUrlKey: "touchscreenWebSocket");

  @override
  void onOpen() {
    resetTouchScreen();
    super.onOpen();
  }

  void resetTouchScreen() {
    List<VirtualTouchScreenCommand> commands = [];
    for (final slot in VirtualTouchscreenSlotState.generateSlots()) {
      commands.add(VirtualTouchScreenCommand(
          absMtSlot: slot.slotIndex, absMtTrackingId: slot.trackingId));
    }
    sendCommands(commands: commands);
  }

  void sendCommands({required List<VirtualTouchScreenCommand> commands}) {
    commands.add(VirtualTouchScreenCommand(synReport: true));

    var message = '';
    for (final command in commands) {
      message += command.build();
    }
    sendString(message);
  }

  void sendCommand(VirtualTouchScreenCommand command) {
    sendString(command.build());
  }
}