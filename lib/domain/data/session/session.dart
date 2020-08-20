import 'package:neumodore/domain/data/activity/activity.dart';
import 'package:neumodore/domain/data/session/session_settings.dart';

class PomodoreSession {
  Activity currentActivity;

  List<Activity> pastActivities = List<Activity>();

  SessionSettings sessionSettings;

  PomodoreSession(this.sessionSettings) {
    currentActivity = sessionSettings.defaultPomodore;
  }

  List<Activity> get finishedPomodores =>
      pastActivities
          ?.where((element) => element.type == ActivityType.POMODORE)
          ?.toList() ??
      List<Activity>();

  List<Activity> get finishedShortBreaks =>
      pastActivities
          ?.where((element) => element.type == ActivityType.SHORT_BREAK)
          ?.toList() ??
      List<Activity>();

  List<Activity> get finishedLongBreaks =>
      pastActivities
          ?.where((element) => element.type == ActivityType.LONG_BREAK)
          ?.toList() ??
      List<Activity>();

  Duration get elapsedTime => currentActivity.elapsedTime;
  Duration get remainingTime => currentActivity.remainingTime;

  ActivityState get activityState => currentActivity.getState();

  double get percentageComplete {
    return currentActivity.percentageComplete;
  }

  void skipActivity() {
    pastActivities.add(currentActivity);
    currentActivity = findNextActivity();
  }

  Activity findNextActivity() {
    if (pastActivities.last.type == ActivityType.POMODORE) {
      if (finishedPomodores.length >= sessionSettings.longIntervalLimit)
        return sessionSettings.defaultLongBreak;

      return sessionSettings.defaultBreak;
    } else if (pastActivities.last.type == ActivityType.LONG_BREAK) {
      pastActivities.clear();
      return sessionSettings.defaultPomodore;
    }
    return sessionSettings.defaultPomodore;
  }

  void startSession() {
    currentActivity.start();
  }

  void resetSession() {
    currentActivity = sessionSettings.defaultPomodore;
    pastActivities.clear();
  }

  void pauseSession() {
    currentActivity.startInterruption();
  }

  void resumeSession() {
    currentActivity.endInterruption();
  }

  PomodoreSession.fromJson(Map<String, dynamic> map) {
    this.currentActivity = Activity.fromJson(map['current_activity']);
    this.pastActivities = (map['past_activities'] as List)
        .map((value) => Activity.fromJson(value))
        .toList();
  }
  Map<String, dynamic> toJson() {
    return {
      'current_activity': currentActivity.toJson(),
      'past_activities': pastActivities.map((e) => e.toJson()).toList(),
    };
  }

  void increaseDuration(Duration durationToBeIncreased) =>
      currentActivity.increaseDuration(durationToBeIncreased);
}
