import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/utils/logger.dart';
import 'package:tesla_android/feature/display/cubit/display_state.dart';
import 'package:tesla_android/feature/display/model/remote_display_state.dart';
import 'package:tesla_android/feature/display/repository/display_repository.dart';

@injectable
class DisplayCubit extends Cubit<DisplayState> with Logger {
  final DisplayRepository _repository;

  DisplayCubit(this._repository) : super(DisplayStateInitial());

  Timer? _resizeCoolDownTimer;
  static const Duration _coolDownDuration = Duration(seconds: 1);

  @override
  Future<void> close() {
    _resizeCoolDownTimer?.cancel();
    return super.close();
  }

  void resizeDisplay({required BoxConstraints viewConstraints}) {
    if (state is DisplayStateResizeInProgress) {
      log("Display resize can't happen now (state == DisplayStateResizeInProgress)");
      return;
    }

    if (state is DisplayStateNormal) {
      final currentState = state as DisplayStateNormal;
      if (currentState.viewConstraints == viewConstraints) {
        log("Display resize not needed (state == DisplayStateNormal)");
        return;
      }
    }
    _startResize(viewConstraints: viewConstraints);
  }

  void _startResize({required BoxConstraints viewConstraints}) async {
    if (state is DisplayStateResizeCoolDown) {
      final currentState = state as DisplayStateResizeCoolDown;
      if (currentState.viewConstraints == viewConstraints) {
        log("Display resize already scheduled (state == DisplayStateResizeCoolDown)");
        return;
      } else {
        _resizeCoolDownTimer?.cancel();
        _resizeCoolDownTimer = null;
      }
    }

    final remoteState = await _getRemoteDisplayState();
    final needsLowRes = remoteState.lowRes == 1 ? true : false;

    final desiredSize = _calculateOptimalSize(
      viewConstraints,
      needsLowRes: needsLowRes,
    );

    if (remoteState.width == desiredSize.width &&
        remoteState.height == desiredSize.height) {
      log("Display resize not needed remote size == desired size");
      _resizeCoolDownTimer?.cancel();
      _resizeCoolDownTimer = null;
      emit(
        DisplayStateNormal(
            viewConstraints: viewConstraints, adjustedSize: desiredSize),
      );
    }

    emit(DisplayStateResizeCoolDown(
      viewConstraints: viewConstraints,
      adjustedSize: desiredSize,
      isLowRes: needsLowRes,
    ));
    _resizeCoolDownTimer = Timer(_coolDownDuration, _sendResizeRequest);
  }

  void _sendResizeRequest() async {
    if (state is DisplayStateResizeCoolDown) {
      final currentState = state as DisplayStateResizeCoolDown;
      final viewConstraints = currentState.viewConstraints;
      final adjustedSize = currentState.adjustedSize;
      final isLowRes = currentState.isLowRes;
      const density = 200;
      emit(DisplayStateResizeInProgress(
          viewConstraints: viewConstraints, adjustedSize: adjustedSize));
      try {
        await _repository.updateDisplayConfiguration(RemoteDisplayState(
          width: adjustedSize.width.toInt(),
          height: adjustedSize.height.toInt(),
          density: density,
          lowRes: isLowRes ? 1 : 0,
        ));
        await Future.delayed(_coolDownDuration, () {
          if (isClosed) return;
          emit(DisplayStateNormal(
            viewConstraints: viewConstraints,
            adjustedSize: adjustedSize,
          ));
        });
        dispatchAnalyticsEvent(
          eventName: "virtualDisplayResolutionChanged",
          props: {
            "width": adjustedSize.width,
            "height": adjustedSize.height,
            "viewportWidth": viewConstraints.maxWidth,
            "viewportHeight": viewConstraints.maxHeight,
            "density": density,
            "lowRes": isLowRes,
          },
        );
      } catch (exception, stacktrace) {
        logExceptionAndUploadToSentry(
            exception: exception, stackTrace: stacktrace);
      }
    } else {
      log("Unable to send resize request. Invalid state, no pending resize");
    }
  }

  Future<RemoteDisplayState> _getRemoteDisplayState() {
    return _repository.getDisplayState();
  }

  ///
  /// Display resolution needs to be aligned by 16 for the hardware encoder
  /// Not going below 1280 x 832 just to be safe
  ///
  Size _calculateOptimalSize(
    BoxConstraints constraints, {
    required bool needsLowRes,
  }) {
    double maxWidth;
    double maxHeight;

    double maxShortestSide = needsLowRes ? 672 : 832;

    if (constraints.maxWidth > constraints.maxHeight) {
      maxWidth = constraints.maxWidth > 1280 ? 1280 : constraints.maxWidth;
      maxHeight = constraints.maxHeight > maxShortestSide
          ? maxShortestSide
          : constraints.maxHeight;
    } else {
      maxWidth = constraints.maxWidth > maxShortestSide
          ? maxShortestSide
          : constraints.maxWidth;
      maxHeight = constraints.maxHeight > 1280 ? 1280 : constraints.maxHeight;
    }

    if (maxWidth < 640 || maxHeight < 480) {
      return const Size(640, 480);
    }

    double aspectRatio = constraints.maxWidth / constraints.maxHeight;

    double bestWidth = maxWidth;
    double bestHeight = maxHeight;
    double minEmptySpace = maxWidth * maxHeight;

    for (double height = maxHeight; height >= 480; height -= 16) {
      double width = height * aspectRatio;

      if (width > maxWidth) {
        continue;
      }

      if (width < 640 || height < 480) {
        continue;
      }

      width = (width ~/ 16) * 16;

      double emptySpace = (maxWidth - width) * (maxHeight - height);

      if (emptySpace < minEmptySpace) {
        minEmptySpace = emptySpace;
        bestWidth = width;
        bestHeight = height;
      }
    }
    return Size(bestWidth, bestHeight);
  }
}
