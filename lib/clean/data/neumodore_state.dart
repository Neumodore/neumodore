class PomodoreState {
  DateTime startedAt;

  Duration duration;

  bool isRuning;

  DateTime pausedAt;

  DateTime cumulatedTime;

  PomodoreState({
    this.startedAt,
    this.duration,
    this.cumulatedTime,
    this.isRuning,
  });

  factory PomodoreState.shortBreak({
    DateTime startDate,
  }) {
    return PomodoreState(
      startedAt: startDate ?? DateTime.now(),
      duration: Duration(minutes: 5),
    );
  }
}
