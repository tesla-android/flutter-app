class AudioState {
  final bool isEnabled;
  final double volume;

  AudioState({
    required this.isEnabled,
    this.volume = 1.0,
  });

  AudioState copyWith(
      {bool? isEnabled,
      bool? isWebSocketConnectionActive,
      double? volume}) {
    return AudioState(
        isEnabled: isEnabled ?? this.isEnabled,
        volume: volume ?? this.volume);
  }
}
