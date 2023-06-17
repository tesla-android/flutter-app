import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';

abstract class DisplayState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DisplayStateInitial extends DisplayState {}

class DisplayStateResizeCoolDown extends DisplayState {
  final BoxConstraints viewConstraints;
  final Size adjustedSize;
  final DateTime timestamp;

  DisplayStateResizeCoolDown(
      {required this.viewConstraints, required this.adjustedSize})
      : timestamp = DateTime.now();

  @override
  List<Object?> get props => [viewConstraints, adjustedSize, timestamp];
}

class DisplayStateResizeInProgress extends DisplayState {
  final BoxConstraints viewConstraints;
  final Size adjustedSize;

  DisplayStateResizeInProgress(
      {required this.viewConstraints, required this.adjustedSize});

  @override
  List<Object?> get props => [viewConstraints, adjustedSize];
}

class DisplayStateNormal extends DisplayState {
  final BoxConstraints viewConstraints;
  final Size adjustedSize;

  DisplayStateNormal(
      {required this.viewConstraints, required this.adjustedSize});

  @override
  List<Object?> get props => [viewConstraints, adjustedSize];
}
