import 'package:neumodore/domain/data/activity/activity.dart';

class SessionSettings {
  Activity defaultLongBreak;

  Activity defaultPomodore;

  Activity defaultShortBreak;

  int longIntervalLimit;

  SessionSettings(
    this.defaultPomodore,
    this.defaultShortBreak,
    this.defaultLongBreak,
    this.longIntervalLimit,
  );

  SessionSettings.fromJson(Map<String, dynamic> jsonEncode) {
    defaultPomodore = Activity.fromJson(jsonEncode['pomodore_activity']);
    defaultShortBreak = Activity.fromJson(jsonEncode['shortbreak_activity']);
    defaultLongBreak = Activity.fromJson(jsonEncode['longbreak_activity']);
    longIntervalLimit = jsonEncode['long_interval_limit'];
  }

  toJson() {
    return {
      'long_interval_limit': longIntervalLimit,
      'pomodore_activity': defaultPomodore.toJson(),
      'longbreak_activity': defaultLongBreak.toJson(),
      'shortbreak_activity': defaultShortBreak.toJson()
    };
  }
}
