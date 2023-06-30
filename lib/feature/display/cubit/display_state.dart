import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';
import 'package:tesla_android/feature/display/model/remote_display_state.dart';

abstract class DisplayState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DisplayStateInitial extends DisplayState {}

class DisplayStateResizeCoolDown extends DisplayState {
  final BoxConstraints viewConstraints;
  final Size adjustedSize;
  final DisplayResolutionModePreset lowResModePreset;
  final DisplayRendererType rendererType;
  final DateTime timestamp;

  DisplayStateResizeCoolDown({
    required this.viewConstraints,
    required this.adjustedSize,
    required this.lowResModePreset,
    required this.rendererType,
  }) : timestamp = DateTime.now();

  @override
  List<Object?> get props => [
        viewConstraints,
        adjustedSize,
        timestamp,
        lowResModePreset,
        rendererType,
      ];
}

class DisplayStateResizeInProgress extends DisplayState {
  DisplayStateResizeInProgress();
}

class DisplayStateNormal extends DisplayState {
  final BoxConstraints viewConstraints;
  final Size adjustedSize;
  final DisplayRendererType rendererType;

  DisplayStateNormal(
      {required this.viewConstraints,
      required this.adjustedSize,
      required this.rendererType});

  @override
  List<Object?> get props => [
        viewConstraints,
        adjustedSize,
        rendererType,
      ];
}
