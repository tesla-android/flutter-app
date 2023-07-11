import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';
import 'package:tesla_android/feature/display/model/remote_display_state.dart';

abstract class DisplayState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DisplayStateInitial extends DisplayState {}

class DisplayStateResizeCoolDown extends DisplayState {
  final Size viewSize;
  final Size adjustedSize;
  final DisplayResolutionModePreset resolutionPreset;
  final DisplayRendererType rendererType;
  final DateTime timestamp;

  DisplayStateResizeCoolDown({
    required this.viewSize,
    required this.adjustedSize,
    required this.resolutionPreset,
    required this.rendererType,
  }) : timestamp = DateTime.now();

  @override
  List<Object?> get props => [
        viewSize,
        adjustedSize,
        timestamp,
        resolutionPreset,
        rendererType,
      ];
}

class DisplayStateResizeInProgress extends DisplayState {
  DisplayStateResizeInProgress();
}

class DisplayStateNormal extends DisplayState {
  final Size viewSize;
  final Size adjustedSize;
  final DisplayRendererType rendererType;

  DisplayStateNormal(
      {required this.viewSize,
      required this.adjustedSize,
      required this.rendererType});

  @override
  List<Object?> get props => [
        viewSize,
        adjustedSize,
        rendererType,
      ];
}
