import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tesla_android/feature/androidViewer/display/cubit/display_state.dart';
import 'package:tesla_android/feature/androidViewer/display/model/ustreamer_state.dart';
import 'package:tesla_android/feature/androidViewer/display/model/ustreamer_state_resolution.dart';
import 'package:tesla_android/feature/androidViewer/display/repository/display_viewer_repository.dart';

@injectable
class DisplayCubit extends Cubit<DisplayState> {
  final DisplayViewerRepository _repository;

  DisplayCubit(this._repository) : super(DisplayState.initial) {
    _fetchUstreamerState();
  }

  void _fetchUstreamerState() async {
    await Future.delayed(state.fetchInterval, () async {
      late DisplayState displayState;

      try {
        final ustreamerState = await _repository.getUstreamerState();
        displayState = _mapUstreamerState(ustreamerState);
      } catch (e) {
        displayState = DisplayState.unreachable;
      }

      if (displayState != state) {
        emit(displayState);
      }
      _fetchUstreamerState();
    });
  }

  DisplayState _mapUstreamerState(UstreamerState ustreamerState) {
    if (ustreamerState.status) {
      if(ustreamerState.result.source.resolution == UstreamerStateResolution.normalStreamResolution) {
        return DisplayState.normal;
      }
      return DisplayState.waitingForBoot;
    }
    return DisplayState.unreachable;
  }
}

