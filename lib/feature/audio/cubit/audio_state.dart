class AudioState {
  final bool isEnabled;
  final bool isWebSocketConnectionActive;
  final double volume;

  AudioState({
    required this.isEnabled,
    required this.isWebSocketConnectionActive,
    this.volume = 1.0,
  });

  AudioState copyWith(
      {bool? isEnabled,
      bool? isWebSocketConnectionActive,
      double? volume}) {
    return AudioState(
        isEnabled: isEnabled ?? this.isEnabled,
        isWebSocketConnectionActive:
            isWebSocketConnectionActive ?? this.isWebSocketConnectionActive,
        volume: volume ?? this.volume);
  }
}
