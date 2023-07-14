import 'dart:async';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
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
import 'package:tesla_android/feature/display/transport/display_transport.dart';

@injectable
class DisplayCubit extends Cubit<DisplayState> with Logger {
  final DisplayRepository _repository;
  final DisplayTransportBlob _transportBlob;
  final DisplayTransportArrayBuffer _transportArrayBuffer;
  final Flavor _flavor;

  DisplayCubit(this._repository, this._transportBlob,
      this._transportArrayBuffer, this._flavor)
      : super(DisplayStateInitial());

  BaseWebsocketTransport? activeTransport;

  StreamSubscription? _transportStreamSubscription;
  Timer? _resizeCoolDownTimer;
  static const Duration _coolDownDuration = Duration(seconds: 1);

  @override
  Future<void> close() {
    _resizeCoolDownTimer?.cancel();
    _transportStreamSubscription?.cancel();
    _transportArrayBuffer.disconnect();
    _transportBlob.disconnect();
    log("close");
    return super.close();
  }

  void resizeDisplay({required Size viewSize}) {
    if (state is DisplayStateResizeInProgress) {
      log("Display resize can't happen now (state == DisplayStateResizeInProgress)");
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

  void _subscribeToTransportStream(bool isBlob) {
    if (activeTransport is DisplayTransportBlob && isBlob) {
      log("blob transport already selected");
    } else if (activeTransport is DisplayTransportArrayBuffer && !isBlob) {
      log("arraybuffer transport already selected");
    } else {
      activeTransport?.disconnect();
      activeTransport == null;
      _transportStreamSubscription?.cancel();
      _transportStreamSubscription = null;
      if (isBlob) {
        _transportBlob.connect();
        _transportStreamSubscription ??=
            _transportBlob.jpegDataSubject.listen((imageData) {
          if (state is DisplayStateNormal) {
            window.postMessage(imageData, "*");
          }
        });
        activeTransport = _transportBlob;
      } else {
        _transportArrayBuffer.connect();
        _transportStreamSubscription ??=
            _transportArrayBuffer.jpegDataSubject.listen((imageData) {
          if (state is DisplayStateNormal) {
            window.postMessage(imageData, "*");
          }
        });
        activeTransport = _transportArrayBuffer;
      }
    }
  }

  void onWindowSizeChanged(Size updatedSize) {
    log('`physicalSize`: $updatedSize');
    _startResize(viewSize: updatedSize);
  }

  void _startResize({required Size viewSize}) async {
    if (state is DisplayStateResizeCoolDown) {
      final currentState = state as DisplayStateResizeCoolDown;
      if (currentState.viewSize == viewSize) {
        log("Display resize already scheduled (state == DisplayStateResizeCoolDown)");
        return;
      } else {
        _resizeCoolDownTimer?.cancel();
        _resizeCoolDownTimer = null;
      }
    }

    final remoteState = await _getRemoteDisplayState();
    final resolutionPreset = remoteState.lowRes;

    final isHeadless = (remoteState.isHeadless ?? 1) == 1;
    final renderer = _getRenderer(remoteState);
    _subscribeToTransportStream(renderer.binaryType() == "blob");

    final desiredSize = _calculateOptimalSize(
      viewSize,
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

    if (!isClosed) {
      emit(DisplayStateResizeCoolDown(
        viewSize: viewSize,
        adjustedSize: desiredSize,
        resolutionPreset: resolutionPreset,
        rendererType: renderer,
      ));
    }
    _resizeCoolDownTimer = Timer(_coolDownDuration, _sendResizeRequest);
  }

  void _sendResizeRequest() async {
    if (state is DisplayStateResizeCoolDown) {
      final currentState = state as DisplayStateResizeCoolDown;
      final viewSize = currentState.viewSize;
      final adjustedSize = currentState.adjustedSize;
      final lowResModePreset = currentState.resolutionPreset;
      final renderer = currentState.rendererType;
      final density = lowResModePreset.density();
      emit(DisplayStateResizeInProgress());
      try {
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
              viewSize: viewSize,
              adjustedSize: adjustedSize,
              rendererType: renderer));
        });
        dispatchAnalyticsEvent(
          eventName: "virtualDisplayResolutionChanged",
          props: {
            "width": adjustedSize.width,
            "height": adjustedSize.height,
            "viewportWidth": viewSize.width,
            "viewportHeight": viewSize.height,
            "density": density,
            "lowRes": lowResModePreset.maxHeight(),
            "renderer": renderer.name(),
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

  DisplayRendererType _getRenderer(RemoteDisplayState remoteDisplayState) {
    var renderer = remoteDisplayState.renderer;
    final isSSL = _flavor.getBool("isSSL") ?? false;
    final rendererNeedsSSL = renderer.needsSSL();
    final isRendererSupported = isSSL && rendererNeedsSSL || !rendererNeedsSSL;
    if (!isRendererSupported) {
      log("Renderer needs SSL, returning to default");
      renderer = DisplayRendererType.imgTag;
    }
    return renderer;
  }

  ///
  /// Display resolution needs to be aligned by 16 for the hardware encoder
  /// Not going below 1280 x 832 just to be safe
  ///
  Size _calculateOptimalSize(
    Size viewSize, {
    required DisplayResolutionModePreset resolutionPreset,
    required bool isHeadless,
  }) {
    if (!isHeadless) {
      return const Size(1024, 480);
    }
    double maxWidth;
    double maxHeight;

    double maxShortestSide = resolutionPreset.maxHeight();

    if (viewSize.width > viewSize.height) {
      maxWidth = viewSize.width > 1280 ? 1280 : viewSize.width;
      maxHeight =
          viewSize.height > maxShortestSide ? maxShortestSide : viewSize.height;
    } else {
      maxWidth =
          viewSize.width > maxShortestSide ? maxShortestSide : viewSize.width;
      maxHeight = viewSize.height > 1280 ? 1280 : viewSize.height;
    }

    if (maxWidth < 320 || maxHeight < 320) {
      return const Size(320, 320);
    }

    double aspectRatio = viewSize.width / viewSize.height;

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
