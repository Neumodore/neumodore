enum ActivityState { STOPPED, PAUSED, RUNING, COMPLETED }
enum ActivityType { NONE, POMODORE, SHORT_BREAK, LONG_BREAK }

class Activity {
  ActivityType type = ActivityType.NONE;

  ActivityState _currentState = ActivityState.STOPPED;
  ActivityState getState() {
    if (_currentState == ActivityState.RUNING && isOvertTime) {
      _currentState = ActivityState.COMPLETED;
    }
    return _currentState;
  }

  DateTime activityStartDate = DateTime.now();
  DateTime _interruptionStartedAt = DateTime.now();
  Duration _interruptiontotal = Duration.zero;

  Duration totalDuration = Duration.zero;
  Duration _defaultDuration;

  Activity({this.totalDuration}) : this._defaultDuration = totalDuration;

  Duration get elapsedTime {
    Duration _total = Duration.zero;

    if (_currentState != ActivityState.STOPPED) {
      _total = DateTime.now().difference(activityStartDate);
      if (_currentState == ActivityState.PAUSED) {
        _total -= DateTime.now().difference(_interruptionStartedAt);
      }
      _total -= _interruptiontotal;
    }

    return _total;
  }

  bool get isOvertTime {
    return remainingTime <= Duration.zero;
  }

  Duration get remainingTime {
    Duration durationtotal = Duration.zero;
    if (totalDuration >= elapsedTime) {
      durationtotal = totalDuration - elapsedTime;
    }

    return durationtotal;
  }

  double get percentageComplete {
    final percentageCalc =
        (elapsedTime.inMilliseconds / totalDuration.inMilliseconds);
    return percentageCalc > 1 ? 1 : percentageCalc;
  }

  get hasEnded => remainingTime.inMilliseconds <= 0;

  void start() {
    this.activityStartDate = DateTime.now();
    changeState(ActivityState.RUNING);
  }

  void sumInterruption(Duration interruption) {
    _interruptiontotal += interruption;
  }

  void clearInterruptions() {
    _interruptiontotal = Duration.zero;
    _interruptionStartedAt = DateTime.now();
  }

  void increaseDuration(Duration _duration) {
    this.totalDuration += _duration;
  }

  void reset() {
    clearInterruptions();
    changeState(ActivityState.STOPPED);
    totalDuration = _defaultDuration;
    activityStartDate = DateTime.now();
  }

  void startInterruption() {
    if (getState() == ActivityState.RUNING) {
      _interruptionStartedAt = DateTime.now();
      changeState(ActivityState.PAUSED);
    }
  }

  void endInterruption() {
    if (getState() == ActivityState.PAUSED) {
      sumInterruption(
        DateTime.now().difference(_interruptionStartedAt),
      );
      changeState(ActivityState.RUNING);
    }
  }

  void changeState(ActivityState newState) {
    _currentState = newState;
  }

  Activity.fromJson(Map<String, dynamic> json)
      : activityStartDate =
            DateTime.fromMillisecondsSinceEpoch(json['started_at']) ??
                DateTime.now().millisecondsSinceEpoch,
        type = ActivityType.values.elementAt(
          json['type'],
        ),
        totalDuration = Duration(
          milliseconds: json['duration'] ?? 0,
        ),
        _defaultDuration = Duration(
          milliseconds: json['duration'] ?? 0,
        ),
        _interruptionStartedAt = DateTime.fromMillisecondsSinceEpoch(
          json['interruption_started_at'] ?? 0,
        ),
        _interruptiontotal = Duration(
          milliseconds: json['interruption_total'] ?? 0,
        ),
        _currentState = ActivityState.values.elementAt(
          json['current_state'] ?? 0,
        );

  /// Returns a New activity from given json string.
  Map<String, dynamic> toJson() => {
        'type': type.index,
        'duration': totalDuration.inMilliseconds,
        'interruption_started_at':
            _interruptionStartedAt.millisecondsSinceEpoch,
        'interruption_total': _interruptiontotal.inMilliseconds,
        'current_state': getState().index,
        'started_at': activityStartDate.millisecondsSinceEpoch,
      };
}

class PomodoreActivity extends Activity {
  @override
  ActivityType type = ActivityType.POMODORE;
  PomodoreActivity({Duration duration})
      : super(totalDuration: duration ?? Duration(minutes: 25));
}

class ShortBreakActivity extends Activity {
  @override
  ActivityType type = ActivityType.SHORT_BREAK;
  ShortBreakActivity({Duration duration})
      : super(totalDuration: duration ?? Duration(minutes: 5));
}

class LongBreakActivity extends Activity {
  @override
  ActivityType type = ActivityType.LONG_BREAK;
  LongBreakActivity({Duration duration})
      : super(totalDuration: duration ?? Duration(minutes: 15));
}
