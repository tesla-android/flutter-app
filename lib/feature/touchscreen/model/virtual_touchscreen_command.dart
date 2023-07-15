class VirtualTouchScreenCommand {
  final int? absMtSlot; //ABS_MT_POSITION_X
  final int? absMtTrackingId; //ABS_MT_TRACKING_ID
  final int? absMtPositionX; //ABS_MT_POSITION_X
  final int? absMtPositionY; //ABS_MT_POSITION_Y
  final bool synReport; //SYN_REPORT

  VirtualTouchScreenCommand({
    this.absMtSlot,
    this.absMtTrackingId,
    this.absMtPositionX,
    this.absMtPositionY,
    this.synReport = false,
  });

  String build() {
    var command = "touchScreenCommand:";
    if (absMtSlot != null) command += 's $absMtSlot\n';
    if (absMtTrackingId != null) {
      command += 'T $absMtTrackingId\n';
      if (absMtTrackingId == -1) {
        command += 'a 0\n';
      } else {
        command += 'a 1\n';
      }
    }
    if (absMtPositionX != null) command += 'X $absMtPositionX\n';
    if (absMtPositionY != null) command += 'Y $absMtPositionY\n';
    if (synReport) command += 'e 0\nS 0\n';
    return command;
  }
}