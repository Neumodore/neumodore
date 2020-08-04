import 'package:neumodore/data/activity/activity.dart';

abstract class HomePresenterContract {
  HomePresenterContract(_view);
  void onLoadState(HomePresenterState state);
  void onUpdateState(HomePresenterState state);
  void onLoadStateError(Error error);
}

enum ActivityState { PAUSED, RUNING, STOPPED }

class HomePresenterState {
  ActivityState activityState = ActivityState.STOPPED;
  Activity activity;
  bool interrupted = false;

  double get percentageComplete {
    return activity.percentageComplete;
  }

  bool get isCompleted {
    return activity.remainingTime.inMilliseconds < 0;
  }

  String get remainingTime {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(
        activity.remainingTime.inMilliseconds);
    var minutes = dateTime.minute > 0 ? dateTime.minute : 0;
    var seconds = dateTime.second > 0 ? dateTime.second : 0;

    return "${minutes < 10 ? "0" : ''}$minutes : ${seconds < 10 ? "0" : ''}$seconds";
  }
}
