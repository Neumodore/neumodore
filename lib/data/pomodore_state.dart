import 'package:neumodore/data/activity/activity.dart';

abstract class IPomodoreState {
  List<Activity> get finishedPomodores;
  List<Activity> get finishedShortBreaks;
  List<Activity> get finishedLongBreaks;

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
  List<Activity> finishedActivities = <Activity>[];

  @override
  List<Activity> get finishedPomodores =>
      finishedActivities
          ?.where((element) => element.runtimeType == PomodoreActivity)
          ?.toList() ??
      List<Activity>();

  @override
  List<Activity> get finishedShortBreaks =>
      finishedActivities
          ?.where((element) => element.runtimeType == ShortBreakActivity)
          ?.toList() ??
      List<Activity>();

  List<Activity> get finishedLongBreaks =>
      finishedActivities
          ?.where((element) => element.runtimeType == LongBreakActivity)
          ?.toList() ??
      List<Activity>();
}
