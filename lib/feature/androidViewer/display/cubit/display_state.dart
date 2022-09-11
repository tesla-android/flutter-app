enum DisplayState {
  initial,
  unreachable,
  normal,
}

extension FetchIntervalExtension on DisplayState {
  Duration get fetchInterval {
    switch(this) {
      case DisplayState.initial:
        return Duration.zero;
      case DisplayState.unreachable:
        return const Duration(seconds: 1);
      case DisplayState.normal:
        return const Duration(seconds: 15);
    }
  }
}
