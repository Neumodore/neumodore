import 'interruption.dart';

abstract class Activity {
  DateTime startDate;
  DateTime endDate;
  Duration interruptionDuration = Duration.zero;

  Duration duration;

  Activity(this.duration);

  Duration get elapsedTime {
    var durationtotal = Duration.zero;
    if (endDate != null) {
      durationtotal = endDate.difference(startDate ?? DateTime.now());
    } else {
      durationtotal = DateTime.now().difference(startDate ?? DateTime.now());
    }
    durationtotal -= interruptionDuration;
    return durationtotal;
  }

  Duration get remainingTime {
    var durationtotal = Duration.zero;
    if (duration.inSeconds > elapsedTime.inSeconds) {
      durationtotal = Duration(
        seconds: duration.inSeconds - elapsedTime.inSeconds,
      );
    } else {
      durationtotal = Duration();
    }
    return durationtotal;
  }

  double get percentageComplete {
    return (this.elapsedTime.inMilliseconds / duration.inMilliseconds);
  }

  void startActivity() {
    this.startDate = DateTime.now();
  }

  void addInterruption(Interruption interruption) {
    interruptionDuration += interruption.inDuration;
  }

  void clearInterruptions() {
    interruptionDuration = Duration.zero;
  }

  void increaseDuration(Duration _duration) {
    this.duration += _duration;
  }
}

class PomodoreActivity extends Activity {
  PomodoreActivity({Duration duration})
      : super(
          duration ?? Duration(minutes: 25),
        );
}

class ShortBreakActivity extends Activity {
  ShortBreakActivity({Duration duration})
      : super(
          duration ?? Duration(minutes: 5),
        );
}

class LongBreakActivity extends Activity {
  LongBreakActivity({Duration duration})
      : super(
          duration ?? Duration(minutes: 15),
        );
}
