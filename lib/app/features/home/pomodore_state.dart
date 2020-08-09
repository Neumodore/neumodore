import 'package:neumodore/data/activity/activity.dart';

class PomodoreAppState {
  Activity activity = PomodoreActivity();

  List<Activity> finishedActivities = List<Activity>();

  void updateActivity(_activity) {
    activity = _activity;
  }

  double get percentageComplete {
    return activity.percentageComplete;
  }

  String get remainingTime {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
        activity.remainingTime.inMilliseconds);

    int minutes = dateTime.minute > 0 ? dateTime.minute : 0;
    int seconds = dateTime.second > 0 ? dateTime.second : 0;

    return "${minutes < 10 ? "0" : ''}$minutes : ${seconds < 10 ? "0" : ''}$seconds";
  }

  void startPomodore() {
    activity.startDate = DateTime.now();
  }

  int get pomodoreCount => finishedActivities
      .where((element) => element.runtimeType == PomodoreActivity)
      .length;

  Activity getNextActivity() {
    if (finishedActivities.length > 0) {
      if (finishedActivities.last.runtimeType == PomodoreActivity) {
        if (pomodoreCount == 4) {
          return LongBreakActivity();
        }
        return ShortBreakActivity();
      } else if (finishedActivities.last.runtimeType == ShortBreakActivity) {
        return PomodoreActivity();
      }
    }
    return PomodoreActivity();
  }

  void skipActivity() {
    finishedActivities.add(activity);
    activity = getNextActivity();
  }
}
