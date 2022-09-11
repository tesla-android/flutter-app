import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tesla_android/feature/androidViewer/display/cubit/display_state.dart';
import 'package:tesla_android/feature/androidViewer/display/repository/display_viewer_repository.dart';

@injectable
class DisplayCubit extends Cubit<DisplayState> {
  final DisplayViewerRepository _repository;

  DisplayCubit(this._repository) : super(DisplayState.initial) {
    _fetchSnapshot();
  }

  void _fetchSnapshot() async {
    await Future.delayed(state.fetchInterval, () async {
      late DisplayState displayState;

      try {
        await _repository.getSnapshot();
        displayState = DisplayState.normal;
      } catch (e) {
        displayState = DisplayState.unreachable;
      }

      if (displayState != state) {
        emit(displayState);
      }
      _fetchSnapshot();
    });
  }
}

