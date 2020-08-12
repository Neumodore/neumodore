import 'package:neumodore/data/activity/activity.dart';

abstract class IPomodoreState {
  List<Activity> get finishedPomodores;
  List<Activity> get finishedBreaks;

  Activity currentActivity;
  List<Activity> finishedActivities = List<Activity>();

  IPomodoreState(
    this.currentActivity, {
    this.finishedActivities,
  });
}

class PomodoreState implements IPomodoreState {
  @override
  Activity currentActivity;

  PomodoreState(
    this.currentActivity, {
    this.finishedActivities,
  });

  @override
  List<Activity> finishedActivities = List<Activity>();

  @override
  List<Activity> get finishedBreaks => finishedActivities
      .where((element) => element.runtimeType == ShortBreakActivity);

  @override
  List<Activity> get finishedPomodores => finishedActivities
      .where((element) => element.runtimeType == PomodoreActivity);
}
