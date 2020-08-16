import 'dart:async';

import 'package:neumodore/app/widgets/neumorphic/neumo_circle.dart';
import 'package:neumodore/infra/managers/pomodore_manager/pomodore_manager.dart';
import 'package:neumodore/infra/repositories/configuration/configuration_repository.dart';
import 'package:neumodore/infra/repositories/istate_repository.dart';
import 'package:wakelock/wakelock.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';

enum ControllerState { PAUSED, RUNING, STOPPED, COMPLETED }

class PomodoreController extends GetxController {
  final NeuProgressController neuProgressController = NeuProgressController();
  Timer _timerUpdater;
  PomodoreManager stateManager;
  ControllerState _currentState = ControllerState.STOPPED;

  PomodoreController(
    IPomodoreRepository persistenceAdapter,
    ISettingsRepository settingsRepository,
  ) {
    stateManager = PomodoreManager(persistenceAdapter, settingsRepository);
    _timerUpdater = Timer.periodic(Duration(milliseconds: 500), _onTimerUpdate);
  }

  double lastPercentageUpdate = 0.0;
  void _onTimerUpdate(var tim) {
    if (getState() == ControllerState.RUNING) {
      print(this.getState().toString());
      print(this.stateManager.percentageComplete);
      if (stateManager.percentageComplete >= 1) {
        changeState(ControllerState.COMPLETED);
      }
      if (stateManager.percentageComplete != lastPercentageUpdate) {
        neuProgressController.animateTo(stateManager.percentageComplete);
        lastPercentageUpdate = stateManager.percentageComplete;
        update();
      }
    }
  }

  ControllerState getState() {
    return _currentState;
  }

  void changeState(ControllerState nextState) {
    if (nextState == ControllerState.COMPLETED &&
        _currentState == ControllerState.RUNING) {
      _playMusic();
    }

    _currentState = nextState;
    update();
  }

  String get durationOSD =>
      stateManager.currentActivitiy.duration.toString().substring(2, 7);

  String get timerOSD => stateManager.remainingTime;

  int get finishedPomodores => stateManager?.finishedPomodores?.length ?? 0;

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

  void _playMusic() {
    AssetsAudioPlayer.newPlayer()
      ..setVolume(1)
      ..open(
        Audio('assets/sounds/robinhood76_04864.mp3'),
        loopMode: LoopMode.none,
        showNotification: true,
        playInBackground: PlayInBackground.enabled,
        audioFocusStrategy: AudioFocusStrategy.request(
          resumeAfterInterruption: true,
        ),
      )
      ..forwardOrRewind(1);
  }

  void animateTo(double d) {
    neuProgressController.animateTo(d);
  }
}
