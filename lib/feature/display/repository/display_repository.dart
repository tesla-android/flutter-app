import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/network/display_service.dart';
import 'package:tesla_android/feature/display/model/remote_display_state.dart';

@injectable
class DisplayRepository {
  final DisplayService _service;

  DisplayRepository(this._service);

  Future<RemoteDisplayState> getDisplayState() {
    return _service.getDisplayState();
  }

  Future updateDisplayConfiguration(RemoteDisplayState configuration) {
    return _service.updateDisplayConfiguration(configuration);
  }
}
