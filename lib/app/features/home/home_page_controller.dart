import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import 'package:neumodore/data/activity/activity.dart';
import 'package:neumodore/data/activity/interruption.dart';

import 'pomodore_state.dart';

enum HomePageState { PAUSED, RUNING, STOPPED, FINISHED }

class HomePageController extends GetxController {
  HomePageController() : state = PomodoreAppState();

  Timer _timerUpdater;
  PomodoreAppState state;

  DateTime interruptionStartedAt;
  DateTime interruptionEndAt;

  HomePageState _curState = HomePageState.STOPPED;

  HomePageState get currentState {
    if (_isFinishedActivity) {
      _curState = HomePageState.FINISHED;
    }
    return _curState;
  }

  bool get _isFinishedActivity =>
      state.activity.remainingTime.inMilliseconds <= 0;

  set currentState(HomePageState nState) => _curState = nState;

  String get durationOSD => state.activity.duration.toString().substring(2, 7);

  String get timerOSD => state.remainingTime;

  int get finishedPomodores => state.finishedActivities
      .where((element) => element.runtimeType == PomodoreActivity)
      .length;

  bool allreadyPlayed = false;
  double get progressPercentage {
    if (currentState == HomePageState.FINISHED) {
      if (!allreadyPlayed) {
        AssetsAudioPlayer.newPlayer().open(
          Audio("assets/sounds/robinhood76_04864.mp3"),
          autoStart: true,
          loopMode: LoopMode.none,
          volume: 100,
          showNotification: false,
          playInBackground: PlayInBackground.enabled,
          audioFocusStrategy: AudioFocusStrategy.request(
            resumeOthersPlayersAfterDone: true,
          ),
        );
      }
      allreadyPlayed = true;
      return 1;
    }
    if (currentState == HomePageState.STOPPED) {
      allreadyPlayed = false;
      return 1;
    }

    allreadyPlayed = false;
    return state.percentageComplete;
  }

  @override
  void onInit() {
    super.onInit();

    state.activity = PomodoreActivity();
  }

  void _startPomodore() async {
    state.startPomodore();
    _startTimer();
  }

  void pausePomodore() {
    _openInterruption();
    update();
  }

  void resumePomodore() {
    _closeInterruption();
    update();
  }

  void stopPomodore() {
    state.activity.clearInterruptions();
    this.currentState = HomePageState.STOPPED;
    _stopTimer();
  }

  void _stopTimer() {
    _timerUpdater?.cancel();
    _timerUpdater = null;
    update();
  }

  void _startTimer() {
    currentState = HomePageState.RUNING;
    _timerUpdater = new Timer.periodic(Duration(milliseconds: 500), (var tim) {
      update();
    });
  }

  void _openInterruption() {
    this.currentState = HomePageState.PAUSED;
    this._timerUpdater?.cancel();
    this.interruptionStartedAt = DateTime.now();
  }

  void _closeInterruption() {
    currentState = HomePageState.RUNING;
    this.interruptionEndAt = DateTime.now();

    Interruption newInterruption = Interruption()
      ..startDate = interruptionStartedAt
      ..endDate = interruptionEndAt;

    state.activity.addInterruption(newInterruption);

    _startTimer();
  }

  void addOneMinute() {
    state.activity.increaseDuration(Duration(minutes: 1));
    update();
  }

  void skipActivity() {
    stopPomodore();
    state.skipActivity();
    update();
  }

  void startPomodore() {
    _startPomodore();
  }
}
