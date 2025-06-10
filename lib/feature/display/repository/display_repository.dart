import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesla_android/common/network/display_service.dart';
import 'package:tesla_android/feature/display/model/remote_display_state.dart';

@injectable
class DisplayRepository {
  final DisplayService _service;
  final SharedPreferences _sharedPreferences;

  final String _isPrimaryDisplaySharedPreferencesKey =
      'DisplayRepository_isPrimaryDisplaySharedPreferencesKey';

  DisplayRepository(this._service, this._sharedPreferences);

  Future<RemoteDisplayState> getDisplayState() {
    return _service.getDisplayState();
  }

  Future updateDisplayConfiguration(RemoteDisplayState configuration) {
    return _service.updateDisplayConfiguration(configuration);
  }

  Future<bool?> isPrimaryDisplay() async {
    final state = await getDisplayState();
    if (state.isRearDisplayEnabled == 1) {
      return _sharedPreferences.getBool(_isPrimaryDisplaySharedPreferencesKey);
    } else {
      return true;
    }
  }

  Future setDisplayType(bool isPrimaryDisplay) {
    return _sharedPreferences.setBool(
      _isPrimaryDisplaySharedPreferencesKey,
      isPrimaryDisplay,
    );
  }
}
