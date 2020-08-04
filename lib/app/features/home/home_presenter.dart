import 'dart:async';

import 'package:neumodore/data/activity/activity.dart';
import 'package:neumodore/data/activity/interruption.dart';

import 'home_presenter_contract.dart';

class HomePresenter {
  HomePresenterContract _view;
  HomePresenterState _state;

  Timer _timerUpdater;

  HomePresenter(this._view) {
    _state = HomePresenterState();
  }

  HomePresenterState get getState => _state;
  double get progressPercentage => _state.percentageComplete;

  void loadPomodoreState() async {
    _state.activity = Activity.shortBreak()..startActivity();

    _startTimer();

    _view.onLoadState(_state);
  }

  void notifyListeners() {
    _view.onUpdateState(_state);
  }

  void pausePomodore() {
    _openInterruption();
    notifyListeners();
  }

  void resumePomodore() {
    _closeInterruption();
    notifyListeners();
  }

  DateTime interruptionStartedAt;
  DateTime interruptionEndAt;

  void _startTimer() {
    _state.activityState = ActivityState.RUNING;
    _timerUpdater =
        Timer.periodic(Duration(milliseconds: 500), (tim) => notifyListeners());
  }

  void _openInterruption() {
    this._state.activityState = ActivityState.PAUSED;
    this._timerUpdater.cancel();
    this.interruptionStartedAt = DateTime.now();
  }

  void _closeInterruption() {
    this._state.activityState = ActivityState.RUNING;
    this.interruptionEndAt = DateTime.now();
    var newInterruption = Interruption()
      ..startDate = interruptionStartedAt
      ..endDate = interruptionEndAt;
    this._state.activity.addInterruption(newInterruption);
    _startTimer();
  }
}
