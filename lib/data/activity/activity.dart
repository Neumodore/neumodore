import 'dart:convert';

import 'interruption.dart';

abstract class Activity {
  String type = 'pomodore';
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

  get hasEnded => remainingTime.inMilliseconds <= 0;

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

  Activity fromJson(String json) {
    final parsed = jsonDecode(json);
    Activity newActivity = PomodoreActivity();
    switch (parsed['type']) {
      case 'pomodore':
        newActivity = PomodoreActivity(
          duration: Duration(milliseconds: parsed['duration']),
        );
        break;
      case 'shortbreak':
        newActivity = ShortBreakActivity(
          duration: Duration(milliseconds: parsed['duration']),
        );
        break;
      case 'longbreak':
        newActivity = PomodoreActivity(
          duration: Duration(milliseconds: parsed['duration']),
        );
        break;
    }
    return newActivity;
  }

  String toJson() {
    return jsonEncode(
      {
        'type': this.type,
        'duration': this.duration.inMilliseconds,
      },
    );
  }

  Activity copyWith({Duration newDuration, String newType}) {
    this.duration = newDuration ?? this.duration;
    this.type = newType ?? this.duration;
    return this;
  }
}

class PomodoreActivity extends Activity {
  PomodoreActivity({Duration duration})
      : super(
          duration ?? Duration(minutes: 25),
        ) {
    this.type = 'pomodore';
  }
}

class ShortBreakActivity extends Activity {
  ShortBreakActivity({Duration duration})
      : super(
          duration ?? Duration(minutes: 5),
        ) {
    this.type = 'shortbreak';
  }
}

class LongBreakActivity extends Activity {
  LongBreakActivity({Duration duration})
      : super(
          duration ?? Duration(minutes: 15),
        ) {
    this.type = 'longbreak';
  }
}
