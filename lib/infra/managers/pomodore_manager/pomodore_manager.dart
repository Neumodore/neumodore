import 'package:neumodore/domain/data/activity/activity.dart';
import 'package:neumodore/domain/data/pomodore_state.dart';

class PomodoreManager {
  PomodoreState _pomodoreState = PomodoreState(PomodoreActivity());

  DateTime _interruptionStartAt;

  DateTime _interruptionEndAt;

  PomodoreManager();

  List<Activity> get finishedActivities => _pomodoreState.finishedActivities;

  List<Activity> get finishedPomodores => _pomodoreState.finishedPomodores;

  List<Activity> get finishedShortBreaks => _pomodoreState.finishedShortBreaks;

  List<Activity> get finishedLongBreaks => _pomodoreState.finishedLongBreaks;

  Activity get currentActivitiy => _pomodoreState.currentActivity;

  void changeActivity(_activity) {
    _pomodoreState.currentActivity = _activity;
  }

  double get percentageComplete {
    return currentActivitiy.percentageComplete;
  }

  bool get hasEnded => currentActivitiy.hasEnded;

  String get remainingTime {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
        currentActivitiy.remainingTime.inMilliseconds);

    int minutes = dateTime.minute > 0 ? dateTime.minute : 0;
    int seconds = dateTime.second > 0 ? dateTime.second : 0;

    return "${minutes < 10 ? "0" : ''}$minutes : ${seconds < 10 ? "0" : ''}$seconds";
  }

  void startActivity() {
    currentActivitiy.start();
  }

  int get pomodoreCount => finishedActivities
      .where((element) => element.runtimeType == PomodoreActivity)
      .length;

  Activity findNextActivity() {
    if (finishedActivities.length > 0) {
      if (finishedActivities.last.runtimeType == PomodoreActivity) {
        if (pomodoreCount == 4) {
          return LongBreakActivity();
        }
        return ShortBreakActivity(duration: Duration(seconds: 10));
      } else if (finishedActivities.last.runtimeType == ShortBreakActivity) {
        return PomodoreActivity();
      }
    }
    return PomodoreActivity();
  }

  void skipActivity() {
    finishedActivities.add(currentActivitiy);
    changeActivity(findNextActivity());
  }

  void clearInterruptions() {
    _pomodoreState.currentActivity.clearInterruptions();
  }

  void resetActivity() {
    clearInterruptions();
    startActivity();
  }

  void createInterruption() {
    _interruptionStartAt = DateTime.now();
  }

  void endInterruption() {
    _interruptionEndAt = DateTime.now();

    currentActivitiy.sumInterruption(
      _interruptionEndAt.difference(_interruptionStartAt),
    );
  }
}
