import 'package:neumodore/domain/data/activity/activity.dart';

class SessionSettings {
  final Activity defaultLongBreak;

  final Activity defaultPomodore;

  final Activity defaultBreak;

  final int longIntervalLimit;

  SessionSettings(
    this.defaultPomodore,
    this.defaultBreak,
    this.defaultLongBreak,
    this.longIntervalLimit,
  );
}
