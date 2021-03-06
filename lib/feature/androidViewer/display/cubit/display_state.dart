enum DisplayState {
  initial,
  unreachable,
  waitingForBoot,
  normal,
}

extension FetchIntervalExtension on DisplayState {
  Duration get fetchInterval {
    switch(this) {
      case DisplayState.initial:
        return Duration.zero;
      case DisplayState.unreachable:
        return const Duration(seconds: 1);
      case DisplayState.waitingForBoot:
      case DisplayState.normal:
        return const Duration(seconds: 15);
    }
  }
}
