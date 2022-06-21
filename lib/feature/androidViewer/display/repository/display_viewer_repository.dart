import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/network/ustreamer_status_service.dart';
import 'package:tesla_android/feature/androidViewer/display/model/ustreamer_state.dart';

@injectable
class DisplayViewerRepository {
  final UstreamerStatusService _ustreamerStatusService;

  DisplayViewerRepository(this._ustreamerStatusService);

  Future<UstreamerState> getUstreamerState() {
    return _ustreamerStatusService.getState();
  }
}