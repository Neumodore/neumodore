import 'dart:async';

import 'package:neumodore/app/widgets/neumorphic/neumo_circle.dart';
import 'package:neumodore/domain/data/activity/activity.dart';
import 'package:neumodore/domain/data/session/session.dart';
import 'package:neumodore/domain/usecases/session/get_session.dart';
import 'package:neumodore/domain/usecases/session/increase_activity_duration.dart';
import 'package:neumodore/domain/usecases/session/pause_activity.dart';
import 'package:neumodore/domain/usecases/session/resume_activity.dart';
import 'package:neumodore/domain/usecases/session/skip_activity.dart';
import 'package:neumodore/domain/usecases/session/start_activity.dart';
import 'package:neumodore/domain/usecases/session/stop_session.dart';

import 'package:neumodore/infra/configuration/configuration_repository.dart';

import 'package:neumodore/infra/repositories/session/isession_repository.dart';
import 'package:neumodore/infra/services/audio/iaudio_service.dart';

import 'package:neumodore/infra/services/screen/iscreen_service.dart';

import 'package:get/get.dart';
import 'package:neumodore/shared/core/use_case.dart';

class SessionController extends GetxController {
  final NeuProgressController neuProgressController = NeuProgressController();

  Timer _timerUpdater;

  ISessionRepository _sessionRepo;
  ISettingsRepository _settingsRepo;
  IAudioService _audioService;
  IScreenService _screenService;

  SessionController(
    this._sessionRepo,
    this._settingsRepo,
    this._audioService,
    this._screenService,
  ) {
    _timerUpdater = Timer.periodic(Duration(milliseconds: 500), _onTimerUpdate);
  }
  PomodoreSession get session => GetSessionCase(_sessionRepo).execute(null);

  // initialized negative to be accepted in conditial bellow
  double lastPercentageUpdate = -1;

  void _onTimerUpdate(var tim) {
    if (currentState() == ActivityState.RUNING) {
      if (session.percentageComplete != lastPercentageUpdate) {
        neuProgressController.animateTo(session.percentageComplete);
        lastPercentageUpdate = session.percentageComplete;
        update();
      }
    } else if (currentState() == ActivityState.COMPLETED) {
      neuProgressController.animateTo(1);
    } else if (currentState() == ActivityState.STOPPED) {
      neuProgressController.animateTo(1);
    }
  }

  ActivityState currentState() {
    return GetSessionCase(_sessionRepo).execute(null).activityState;
  }

  changeState(ActivityState nstate) {
    ChangeStateUseCase(_sessionRepo).execute(null);
    update();
  }

  String get durationOSD =>
      this.session.currentActivity.totalDuration.toString().substring(2, 7);

  String get timerOSD {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
        this.session.remainingTime.inMilliseconds);

    int minutes = dateTime.minute > 0 ? dateTime.minute : 0;
    int seconds = dateTime.second > 0 ? dateTime.second : 0;

    return "${minutes < 10 ? "0" : ''}$minutes : ${seconds < 10 ? "0" : ''}$seconds";
  }

  int get finishedPomodores => this.session?.finishedPomodores?.length ?? 0;

  bool allreadyPlayed = false;
  double get progressPercentage {
    if (currentState() == ActivityState.COMPLETED) {
      return 1;
    }
    if (currentState() == ActivityState.STOPPED) {
      allreadyPlayed = false;
      return 1;
    }
    allreadyPlayed = false;
    return this.session.percentageComplete;
  }

  @override
  void onInit() async {
    super.onInit();
  }

  void startActivity() {
    StartActivityCase(_sessionRepo, _screenService).execute(null);
    update();
  }

  void pauseActivity() {
    PauseActivityCase(_sessionRepo, _screenService).execute(null);
    update();
  }

  void resumeActivity() {
    ResumeActivityCase(_sessionRepo, _screenService).execute(null);
    update();
  }

  void skipActivity() {
    SkipActivityCase(_sessionRepo, _screenService).execute(null);
    update();
  }

  void increaseDuration() {
    IncreaseActivityDurationCase(_sessionRepo).execute(Duration(minutes: 1));
    update();
  }

  void stopSession() {
    StopPomodoreSessionCase(_sessionRepo).execute(null);
    update();
  }

  void animateTo(double d) {
    neuProgressController.animateTo(d);
  }
}

class ChangeStateUseCase
    implements UseCase<Future<PomodoreSession>, ActivityState> {
  ISessionRepository _sessionRepo;
  ChangeStateUseCase(this._sessionRepo);

  @override
  Future<PomodoreSession> execute(ActivityState nextState) {
    return _sessionRepo.saveSession(
      _sessionRepo.loadSession()..currentActivity.setState(nextState),
    );
  }
}
