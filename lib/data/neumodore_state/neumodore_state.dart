import 'package:neumodore/data/activity/activity.dart';

class PomodoreState {
  int finishedPomodores = 0;
  int finishedBreaks = 0;

  Activity currentPomodore;

  PomodoreState(
    this.currentPomodore,
    this.finishedPomodores,
    this.finishedBreaks,
  );
}
