import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/network/mjpg_streamer_status_service.dart';

@injectable
class DisplayViewerRepository {
  final MjpgStreamerStatusService _mjpgStreamerStatusService;

  DisplayViewerRepository(this._mjpgStreamerStatusService);

  Future<Uint8List> getSnapshot() {
    return _mjpgStreamerStatusService.getAction("snapshot").then((value) => Uint8List.fromList(value));
  }
}
