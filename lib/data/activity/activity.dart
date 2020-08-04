import 'interruption.dart';

class Activity {
  DateTime startDate;
  DateTime endDate;
  Duration interruptionDuration = Duration.zero;

  final Duration duration;

  Activity(this.duration);

  Duration get elapsedTime {
    var durationtotal = Duration.zero;
    if (endDate != null) {
      durationtotal = endDate.difference(startDate);
    } else {
      durationtotal = DateTime.now().difference(startDate);
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

  factory Activity.shortBreak() => Activity(Duration(minutes: 5));

  factory Activity.onePomodore() => Activity(Duration(minutes: 25));

  factory Activity.longBreak() => Activity(Duration(minutes: 30));
}
