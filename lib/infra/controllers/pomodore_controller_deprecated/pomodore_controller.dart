// import 'dart:async';

// import 'package:neumodore/app/widgets/neumorphic/neumo_circle.dart';
// import 'package:neumodore/domain/data/activity/activity.dart';
// import 'package:neumodore/infra/configuration/configuration_repository.dart';
// import 'package:neumodore/infra/managers/pomodore_manager/pomodore_manager.dart';

// import 'package:neumodore/infra/repositories/activity/iactivity_repo.dart';
// import 'package:wakelock/wakelock.dart';
// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:get/get.dart';

// class PomodoreController extends GetxController {
//   final NeuProgressController neuProgressController = NeuProgressController();
//   final stateManager = PomodoreManager();
//   Timer _timerUpdater;

//   ActivityState _currentState = ActivityState.STOPPED;

//   PomodoreController(
//     IActivityRepository persistenceAdapter,
//     ISettingsRepository settingsRepository,
//   ) {
//     _timerUpdater = Timer.periodic(Duration(milliseconds: 500), _onTimerUpdate);
//   }

//   double lastPercentageUpdate = 0.0;
//   void _onTimerUpdate(var tim) {
//     if (getState() == ActivityState.RUNING) {
//       print(this.getState().toString());
//       print(this.stateManager.percentageComplete);
//       if (stateManager.percentageComplete >= 1) {
//         changeState(ActivityState.COMPLETED);
//       }
//       if (stateManager.percentageComplete != lastPercentageUpdate) {
//         neuProgressController.animateTo(stateManager.percentageComplete);
//         lastPercentageUpdate = stateManager.percentageComplete;
//         update();
//       }
//     }
//   }

//   ActivityState getState() {
//     return _currentState;
//   }

//   void changeState(ActivityState nextState) {
//     if (nextState == ActivityState.COMPLETED &&
//         _currentState == ActivityState.RUNING) {
//       _playMusic();
//     }

//     _currentState = nextState;
//     update();
//   }

//   String get durationOSD =>
//       stateManager.currentActivitiy.totalDuration.toString().substring(2, 7);

//   String get timerOSD => stateManager.remainingTime;

//   int get finishedPomodores => stateManager?.finishedPomodores?.length ?? 0;

//   bool allreadyPlayed = false;
//   double get progressPercentage {
//     if (getState() == ActivityState.COMPLETED) {
//       return 1;
//     }
//     if (getState() == ActivityState.STOPPED) {
//       allreadyPlayed = false;
//       return 1;
//     }
//     allreadyPlayed = false;
//     return stateManager.percentageComplete;
//   }

//   @override
//   void onInit() async {
//     super.onInit();
//   }

//   void pausePomodore() {
//     changeState(ActivityState.PAUSED);
//     stateManager.createInterruption();
//   }

//   void resumePomodore() {
//     changeState(ActivityState.RUNING);
//     stateManager.endInterruption();
//   }

//   void stopPomodore() {
//     stateManager.resetActivity();
//     Wakelock.disable();
//     changeState(ActivityState.STOPPED);
//   }

//   void _startTimer() {
//     changeState(ActivityState.RUNING);
//   }

//   void addOneMinute() {
//     stateManager.currentActivitiy.increaseDuration(Duration(minutes: 1));
//     update();
//   }

//   void skipActivity() {
//     stopPomodore();
//     stateManager.skipActivity();
//     update();
//   }

//   void startPomodore() {
//     Wakelock.enable();
//     stateManager.startActivity();
//     _startTimer();
//     update();
//   }

//   void _playMusic() {
//     AssetsAudioPlayer.newPlayer()
//       ..setVolume(1)
//       ..open(
//         Audio('assets/sounds/robinhood76_04864.mp3'),
//         loopMode: LoopMode.none,
//         showNotification: true,
//         playInBackground: PlayInBackground.enabled,
//         audioFocusStrategy: AudioFocusStrategy.request(
//           resumeAfterInterruption: true,
//         ),
//       )
//       ..forwardOrRewind(1);
//   }

//   void animateTo(double d) {
//     neuProgressController.animateTo(d);
//   }
// }
