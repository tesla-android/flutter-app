import 'dart:async';
import 'dart:math' as math;

import 'dart:ui' hide window;

import 'package:flavor/flavor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tesla_android/common/network/base_websocket_transport.dart';
import 'package:tesla_android/common/utils/logger.dart';
import 'package:tesla_android/feature/display/cubit/display_state.dart';
import 'package:tesla_android/feature/display/model/remote_display_state.dart';
import 'package:tesla_android/feature/display/repository/display_repository.dart';

@injectable
class DisplayCubit extends Cubit<DisplayState> with Logger {
  final DisplayRepository _repository;
  final Flavor _flavor;

  DisplayCubit(this._repository, this._flavor) : super(DisplayStateInitial());

  BaseWebsocketTransport? activeTransport;

  StreamSubscription? _transportStreamSubscription;
  Timer? _resizeCoolDownTimer;
  static const Duration _coolDownDuration = Duration(seconds: 1);

  @override
  Future<void> close() {
    _resizeCoolDownTimer?.cancel();
    _transportStreamSubscription?.cancel();
    log("close");
    return super.close();
  }

  void resizeDisplay({required Size viewSize}) {
    if (state is DisplayStateResizeInProgress) {
      log(
        "Display resize can't happen now (state == DisplayStateResizeInProgress)",
      );
      return;
    }

    if (state is DisplayStateNormal) {
      final currentState = state as DisplayStateNormal;
      if (currentState.viewSize == viewSize) {
        log("Display resize not needed (state == DisplayStateNormal)");
        return;
      }
    }
    _startResize(viewSize: viewSize);
  }

  void onWindowSizeChanged(Size updatedSize) {
    log('`physicalSize`: $updatedSize');
    _startResize(viewSize: updatedSize);
  }

  void onDisplayTypeSelectionFinished({required bool isPrimaryDisplay}) {
    emit(DisplayStateDisplayTypeSelectionFinished());
    _repository.setDisplayType(isPrimaryDisplay);
    _startResize();
  }

  void _startResize({Size viewSize = Size.zero}) async {
    if (state is DisplayStateResizeCoolDown) {
      final currentState = state as DisplayStateResizeCoolDown;
      if (currentState.viewSize == viewSize) {
        log(
          "Display resize already scheduled (state == DisplayStateResizeCoolDown)",
        );
        return;
      } else {
        _resizeCoolDownTimer?.cancel();
        _resizeCoolDownTimer = null;
      }
    }

    final isPrimaryDisplay = await _repository.isPrimaryDisplay();
    final remoteState = await _getRemoteDisplayState();
    final isRearDisplayPrioritised = remoteState.isRearDisplayPrioritised == 1;
    final isRearDisplayEnabled = remoteState.isRearDisplayEnabled == 1;
    final resolutionPreset = remoteState.resolutionPreset;
    final isHeadless = (remoteState.isHeadless ?? 1) == 1;
    final renderer = _getRenderer(remoteState);
    final isResponsive = remoteState.isResponsive == 1;
    final quality = remoteState.quality;
    final isH264 = remoteState.isH264 == 1;
    final refreshRate = remoteState.refreshRate;
    final remoteSize = Size(
      remoteState.width.toDouble(),
      remoteState.height.toDouble(),
    );
    Size desiredSize = Size.zero;
    if (viewSize == Size.zero) {
      viewSize = remoteSize;
    }

    log(
      "Verify display type before triggering a resize (state == DisplayStateInitial)",
    );
    if (isPrimaryDisplay == null && isRearDisplayEnabled) {
      log("Primary display preference unset");
      emit(DisplayStateDisplayTypeSelectionTriggered());
      return;
    } else {
      if (isPrimaryDisplay == true ||
          isPrimaryDisplay == false && isRearDisplayPrioritised) {
        desiredSize = _calculateOptimalSize(
          isResponsive ? viewSize : const Size(1088, 832),
          isH264: isH264,
          resolutionPreset: resolutionPreset,
          isHeadless: isHeadless,
        );

        if (remoteState.width == desiredSize.width &&
            remoteState.height == desiredSize.height) {
          log("Display resize not needed remote size == desired size");
          _resizeCoolDownTimer?.cancel();
          _resizeCoolDownTimer = null;
          if (!isClosed) {
            emit(
              DisplayStateNormal(
                viewSize: viewSize,
                adjustedSize: desiredSize,
                rendererType: renderer,
              ),
            );
          }
          return;
        }
      } else {
        log("Display resize not needed, display is not prioritised");
        _resizeCoolDownTimer?.cancel();
        _resizeCoolDownTimer = null;
        desiredSize = remoteSize;
        if (!isClosed) {
          emit(
            DisplayStateNormal(
              viewSize: viewSize,
              adjustedSize: desiredSize,
              rendererType: renderer,
            ),
          );
        }
      }
    }

    if (!isClosed) {
      emit(
        DisplayStateResizeCoolDown(
          viewSize: viewSize,
          adjustedSize: desiredSize,
          resolutionPreset: resolutionPreset,
          rendererType: renderer,
          isH264: remoteState.isH264 == 1,
          isResponsive: remoteState.isResponsive == 1,
          quality: quality,
          refreshRate: refreshRate,
          isRearDisplayEnabled: remoteState.isRearDisplayEnabled == 1,
          isRearDisplayPrioritised: remoteState.isRearDisplayPrioritised == 1,
          isPrimaryDisplay: isPrimaryDisplay ?? true,
        ),
      );
    }
    _resizeCoolDownTimer = Timer(_coolDownDuration, _sendResizeRequest);
  }

  void _sendResizeRequest() async {
    if (state is DisplayStateResizeCoolDown) {
      final currentState = state as DisplayStateResizeCoolDown;
      final viewSize = currentState.viewSize;
      final adjustedSize = currentState.adjustedSize;
      final resolutionPreset = currentState.resolutionPreset;
      final renderer = currentState.rendererType;
      final isH264 = renderer != DisplayRendererType.mjpeg;
      final density = resolutionPreset.density(isH264: isH264);
      final quality = currentState.quality;
      final refreshRate = currentState.refreshRate;
      final isRearDisplayEnabled = currentState.isRearDisplayEnabled;
      final isRearDisplayPrioritised = currentState.isRearDisplayPrioritised;

      emit(DisplayStateResizeInProgress());
      try {
        await _repository.updateDisplayConfiguration(
          RemoteDisplayState(
            width: adjustedSize.width.toInt(),
            height: adjustedSize.height.toInt(),
            density: density,
            resolutionPreset: resolutionPreset,
            renderer: renderer,
            isResponsive: currentState.isResponsive ? 1 : 0,
            isH264: isH264 ? 1 : 0,
            quality: quality,
            refreshRate: refreshRate,
            isRearDisplayEnabled: isRearDisplayEnabled ? 1 : 0,
            isRearDisplayPrioritised: isRearDisplayPrioritised ? 1 : 0,
          ),
        );
        await Future.delayed(_coolDownDuration, () {
          if (isClosed) return;
          emit(
            DisplayStateNormal(
              viewSize: viewSize,
              adjustedSize: adjustedSize,
              rendererType: renderer,
            ),
          );
        });
      } catch (exception, stacktrace) {
        logException(exception: exception, stackTrace: stacktrace);
      }
    } else {
      log("Unable to send resize request. Invalid state, no pending resize");
    }
  }

  Future<RemoteDisplayState> _getRemoteDisplayState() {
    return _repository.getDisplayState();
  }

  DisplayRendererType _getRenderer(RemoteDisplayState remoteDisplayState) {
    return remoteDisplayState.renderer;
  }

  Size _calculateOptimalSize(
    Size viewSize, {
    required DisplayResolutionModePreset resolutionPreset,
    required isH264,
    required bool isHeadless,
  }) {
    if (!isHeadless) {
      return const Size(1024, 768);
    }

    DisplayResolutionModePreset adjustedResolutionPreset;
    if (isH264) {
      switch (resolutionPreset) {
        case DisplayResolutionModePreset.res832p:
          adjustedResolutionPreset = DisplayResolutionModePreset.res832p;
        default:
          adjustedResolutionPreset = DisplayResolutionModePreset.res720p;
      }
    } else {
      adjustedResolutionPreset = resolutionPreset;
    }

    // Pi H.264 safe “coded” limits (macroblock-aligned)
    const double maxW = 1920.0;
    const double maxH = 1088.0;
    const double minSide = 320.0;

    // Conservative alignment for Pi H.264:
    //  - width multiple of 64 (helps with stride/chroma alignment)
    //  - height multiple of 32 (more reliable than 16 on some builds)
    double alignUp(double v, int m) => ((v + (m - 1)) ~/ m * m).toDouble();

    final double ar = viewSize.width / viewSize.height;

    // Start from the incoming view size (bounded by encoder max)
    double w = viewSize.width.clamp(minSide, maxW);
    double h = w / ar;
    if (h > maxH) {
      h = maxH;
      w = h * ar;
    }

    // Cap by preset on SHORTEST side (e.g. 480/544/640/720/832).
    final double maxShortest = adjustedResolutionPreset.maxHeight();
    final double shortest = math.min(w, h);
    if (shortest > maxShortest) {
      final double s = maxShortest / shortest;
      w *= s;
      h *= s;
    }

    // Align UP to safe multiples.
    w = alignUp(w, 64);
    h = alignUp(h, 32);

    // For small presets, avoid exact 480 rows — use 512 (common good coded height).
    if (h <= 480) {
      h = 512;
      w = alignUp(h * ar, 64); // preserve AR as best as possible
    }

    // Enforce minimums after alignment.
    if (w < minSide) w = alignUp(minSide, 64);
    if (h < minSide) h = alignUp(minSide, 32);

    // Re-apply hard caps in case alignment pushed us over.
    w = math.min(w, maxW);
    h = math.min(h, maxH);

    return Size(w, h);
  }
}
