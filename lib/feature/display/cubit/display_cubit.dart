import 'dart:async';
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/utils/logger.dart';
import 'package:tesla_android/feature/display/cubit/display_state.dart';
import 'package:tesla_android/feature/display/model/remote_display_state.dart';
import 'package:tesla_android/feature/display/repository/display_repository.dart';
import 'package:tesla_android/feature/display/transport/display_transport.dart';

@injectable
class DisplayCubit extends Cubit<DisplayState> with Logger {
  final DisplayRepository _repository;
  final DisplayTransport _transport;

  DisplayCubit(this._repository, this._transport)
      : super(DisplayStateInitial()) {
    _transport.connect();
  }

  StreamSubscription? _transportStreamSubscription;
  Timer? _resizeCoolDownTimer;
  static const Duration _coolDownDuration = Duration(seconds: 1);

  @override
  Future<void> close() {
    _resizeCoolDownTimer?.cancel();
    _transportStreamSubscription?.cancel();
    _transport.disconnect();
    return super.close();
  }

  void resizeDisplay({required BoxConstraints viewConstraints}) {
    _subscribeToTransportStream();

    if (state is DisplayStateResizeInProgress) {
      log(
          "Display resize can't happen now (state == DisplayStateResizeInProgress)");
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

  void _subscribeToTransportStream() {
    _transportStreamSubscription ??=
        _transport.jpegDataSubject.listen((imageData) {
          window.postMessage(imageData, "*");
        });
  }

  void _startResize({required BoxConstraints viewConstraints}) async {
    if (state is DisplayStateResizeCoolDown) {
      final currentState = state as DisplayStateResizeCoolDown;
      if (currentState.viewConstraints == viewConstraints) {
        log(
            "Display resize already scheduled (state == DisplayStateResizeCoolDown)");
        return;
      } else {
        _resizeCoolDownTimer?.cancel();
        _resizeCoolDownTimer = null;
      }
    }

    final remoteState = await _getRemoteDisplayState();
    final lowResPreset = remoteState.lowRes;
    final renderer = remoteState.renderer;
    final isHeadless = (remoteState.isHeadless ?? 1) == 1;
    _transport.updateBinaryType(renderer.binaryType());

    final desiredSize = _calculateOptimalSize(
        viewConstraints,
        lowResModePreset: lowResPreset,
        isHeadless: isHeadless,
    );

    if (remoteState.width == desiredSize.width &&
        remoteState.height == desiredSize.height) {
      log("Display resize not needed remote size == desired size");
      _resizeCoolDownTimer?.cancel();
      _resizeCoolDownTimer = null;
      emit(
        DisplayStateNormal(
          viewConstraints: viewConstraints,
          adjustedSize: desiredSize,
          rendererType: renderer,
        ),
      );
    }

    emit(DisplayStateResizeCoolDown(
      viewConstraints: viewConstraints,
      adjustedSize: desiredSize,
      lowResModePreset: lowResPreset,
      rendererType: renderer,
    ));
    _resizeCoolDownTimer = Timer(_coolDownDuration, _sendResizeRequest);
  }

  void _sendResizeRequest() async {
    if (state is DisplayStateResizeCoolDown) {
      final currentState = state as DisplayStateResizeCoolDown;
      final viewConstraints = currentState.viewConstraints;
      final adjustedSize = currentState.adjustedSize;
      final lowResModePreset = currentState.lowResModePreset;
      final renderer = currentState.rendererType;
      final density = lowResModePreset.density();
      emit(DisplayStateResizeInProgress());
      try {
        _transport.updateBinaryType(renderer.binaryType());
        await _repository.updateDisplayConfiguration(RemoteDisplayState(
          width: adjustedSize.width.toInt(),
          height: adjustedSize.height.toInt(),
          density: density,
          lowRes: lowResModePreset,
          renderer: renderer,
        ));
        await Future.delayed(_coolDownDuration, () {
          if (isClosed) return;
          emit(DisplayStateNormal(
              viewConstraints: viewConstraints,
              adjustedSize: adjustedSize,
              rendererType: renderer));
        });
        dispatchAnalyticsEvent(
          eventName: "virtualDisplayResolutionChanged",
          props: {
            "width": adjustedSize.width,
            "height": adjustedSize.height,
            "viewportWidth": viewConstraints.maxWidth,
            "viewportHeight": viewConstraints.maxHeight,
            "density": density,
            "lowRes": lowResModePreset.maxHeight(),
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
  Size _calculateOptimalSize(BoxConstraints constraints, {
    required DisplayLowResModePreset lowResModePreset,
    required bool isHeadless,
  }) {
    if (!isHeadless) {
      return const Size(1024, 768);
    }
    double maxWidth;
    double maxHeight;

    double maxShortestSide = lowResModePreset.maxHeight();

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

    if (maxWidth < 320 || maxHeight < 320) {
      return const Size(320, 320);
    }

    double aspectRatio = constraints.maxWidth / constraints.maxHeight;

    double bestWidth = maxWidth;
    double bestHeight = maxHeight;
    double minEmptySpace = maxWidth * maxHeight;

    for (double height = maxHeight; height >= 320; height -= 16) {
      double width = height * aspectRatio;

      if (width > maxWidth) {
        continue;
      }

      if (width < 320 || height < 320) {
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
