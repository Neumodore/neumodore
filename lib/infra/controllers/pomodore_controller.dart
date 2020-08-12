import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import 'package:neumodore/data/activity/activity.dart';
import 'package:neumodore/data/activity/interruption.dart';
import 'package:neumodore/data/pomodore_state.dart';
import 'package:neumodore/infra/persistence/sharedprefs_persistence.dart';
import 'package:wakelock/wakelock.dart';

import 'pomodore_manager/pomodore_manager.dart';

enum ControllerState { PAUSED, RUNING, STOPPED, COMPLETED }

class PomodoreController extends GetxController {
  PomodoreController(PomodoreState pomodoreState) {
    stateManager = PomodoreManager(
      SharedPrefsPersistence(),
    );

    _timerUpdater = new Timer.periodic(Duration(milliseconds: 500), (var tim) {
      print('Remaining');
      print(this.stateManager.percentageComplete);
      print(this.getState().toString());

      if (getState() == ControllerState.RUNING &&
          stateManager.percentageComplete >= 1) {
        changeState(ControllerState.COMPLETED);
      }
      if (getState() == ControllerState.RUNING) {
        update();
      }
    });
  }

  Timer _timerUpdater;

  PomodoreManager stateManager;

  ControllerState _currentState = ControllerState.STOPPED;

  ControllerState getState() {
    return _currentState;
  }

  void changeState(ControllerState nextState) {
    if (nextState == ControllerState.COMPLETED &&
        _currentState == ControllerState.RUNING) {
      if (!allreadyPlayed) {
        AssetsAudioPlayer.newPlayer().open(
          Audio('assets/sounds/robinhood76_04864.mp3'),
          autoStart: true,
          loopMode: LoopMode.none,
          volume: 100,
          showNotification: false,
          playInBackground: PlayInBackground.enabled,
          audioFocusStrategy:
              AudioFocusStrategy.request(resumeOthersPlayersAfterDone: true),
        );
        allreadyPlayed = true;
      }
    }
    _currentState = nextState;
    update();
  }

  String get durationOSD =>
      stateManager.currentActivitiy.duration.toString().substring(2, 7);

  String get timerOSD => stateManager.remainingTime;

  int get finishedPomodores => stateManager.finishedActivities.length;

  bool allreadyPlayed = false;
  double get progressPercentage {
    if (getState() == ControllerState.COMPLETED) {
      return 1;
    }
    if (getState() == ControllerState.STOPPED) {
      allreadyPlayed = false;
      return 1;
    }
    allreadyPlayed = false;
    return stateManager.percentageComplete;
  }

  @override
  void onInit() async {
    super.onInit();
  }

  void pausePomodore() {
    changeState(ControllerState.PAUSED);
    stateManager.createInterruption();
  }

  void resumePomodore() {
    changeState(ControllerState.RUNING);
    stateManager.endInterruption();
  }

  void stopPomodore() {
    stateManager.resetActivity();
    Wakelock.disable();
    changeState(ControllerState.STOPPED);
  }

  void _startTimer() {
    changeState(ControllerState.RUNING);
  }

  void addOneMinute() {
    stateManager.currentActivitiy.increaseDuration(Duration(minutes: 1));
    update();
  }

  void skipActivity() {
    stopPomodore();
    stateManager.skipActivity();
    update();
  }

  void startPomodore() {
    Wakelock.enable();
    stateManager.startActivity();
    _startTimer();
    update();
  }
}
