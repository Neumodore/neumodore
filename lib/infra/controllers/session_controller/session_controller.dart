import 'dart:async';

import 'package:flutter/material.dart';
import 'package:neumodore/app/widgets/neumorphic/neumo_circle.dart';
import 'package:neumodore/domain/data/activity/activity.dart';
import 'package:neumodore/domain/data/session/session.dart';
import 'package:neumodore/domain/usecases/session/change_state.dart';
import 'package:neumodore/domain/usecases/session/get_session.dart';
import 'package:neumodore/domain/usecases/session/increase_activity_duration.dart';
import 'package:neumodore/domain/usecases/session/pause_activity.dart';
import 'package:neumodore/domain/usecases/session/resume_activity.dart';
import 'package:neumodore/domain/usecases/session/skip_activity.dart';
import 'package:neumodore/domain/usecases/session/start_activity.dart';
import 'package:neumodore/domain/usecases/session/stop_session.dart';

import 'package:neumodore/infra/configuration/configuration_repository.dart';

import 'package:neumodore/infra/repositories/session/isession_repository.dart';
import 'package:neumodore/infra/services/local_reminder_service.dart';

import 'package:neumodore/infra/services/screen/iscreen_service.dart';
import 'package:neumodore/shared/helpers/strings.dart';

import 'package:get/get.dart';

class SessionController extends GetxController {
  final NeuProgressController neuProgressController = NeuProgressController();

  Timer _timerUpdater;

  final ISessionRepository _sessionRepo;
  final ISettingsRepository _settingsRepo;
  final IScreenService _screenService;
  final LocalReminderService _reminderService;

  SessionController(
    this._sessionRepo,
    this._settingsRepo,
    this._screenService,
    this._reminderService,
  ) {
    _timerUpdater = Timer.periodic(Duration(milliseconds: 500), _onTimerUpdate);
  }
  PomodoreSession get session => GetSessionCase(_sessionRepo).execute(null);

  // initialized negative to be accepted in conditial bellow
  double lastPercentageUpdate = -1;
  ActivityState lastState = ActivityState.COMPLETED;

  String get activityName {
    switch (session.currentActivity.type) {
      case ActivityType.POMODORE:
        return "pomodore".tr;
        break;
      case ActivityType.SHORT_BREAK:
        return "short_break".tr;
        break;
      case ActivityType.LONG_BREAK:
        return "long_break".tr;
        break;
      default:
    }
    return "activity";
  }

  void _onTimerUpdate(var tim) {
    ActivityState curState = currentState;

    if (session.percentageComplete != lastPercentageUpdate ||
        session.activityState != curState) {
      if (curState == ActivityState.RUNING) {
        neuProgressController.animateTo(session.percentageComplete);
        if (session.remainingTime.inSeconds > 59 &&
            session.remainingTime.inSeconds < 61) {}
      } else if (curState == ActivityState.COMPLETED) {
        neuProgressController.animateTo(1);
      } else if (curState == ActivityState.STOPPED) {
        neuProgressController.animateTo(0.01);
      }
      lastState = curState;
      lastPercentageUpdate = session.percentageComplete;
      update();
    }
  }

  ActivityState get currentState =>
      GetSessionCase(_sessionRepo).execute(null).activityState;

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
    if (currentState == ActivityState.COMPLETED) {
      return 1;
    }
    if (currentState == ActivityState.STOPPED) {
      allreadyPlayed = false;
      return 1;
    }
    allreadyPlayed = false;
    return this.session.percentageComplete;
  }

  @override
  void onInit() async {
    super.onInit();
    _screenService.enableWakeLock();
  }

  void startActivity() async {
    await StartActivityCase(_sessionRepo).execute(null);
    await _scheduleActivityNotifications(session.remainingTime, tag: "Started");
    update();
  }

  void pauseActivity() async {
    await PauseActivityCase(_sessionRepo).execute(null);
    await _cancelNotifications();
    update();
  }

  void resumeActivity() async {
    await ResumeActivityCase(_sessionRepo).execute(null);
    await _scheduleActivityNotifications(session.remainingTime, tag: "Resumed");
    update();
  }

  void skipActivity() async {
    await SkipActivityCase(_sessionRepo).execute(null);
    await _cancelNotifications();
    update();
  }

  void increaseDuration() async {
    await IncreaseActivityDurationCase(_sessionRepo)
        .execute(Duration(minutes: 1));
    await _scheduleActivityNotifications(session.remainingTime,
        tag: "Increased");
    update();
  }

  void stopSession() async {
    await StopPomodoreSessionCase(_sessionRepo).execute(null);
    _cancelNotifications();
    update();
  }

  Future _cancelNotifications() async {
    await _reminderService.cancelAnyNotifications();
  }

  Future _scheduleActivityNotifications(
    Duration remainingTime, {
    String tag = "TAG",
  }) async {
    await _cancelNotifications();

    await _reminderService.scheduleProgress(
      timeoutDuration: remainingTime,
      msgTitle: "activity_ended".trArgs([activityName]).firstCharUpper(),
      msgBody: 'activity_ended_body'.trArgs([activityName]).firstCharUpper(),
      iconResName: "ic_alarm_finished",
      showWhenStamp: true,
      iconColor: Colors.green,
      notificationID: 23,
      channelTitle: "system_channel_name".tr,
      channelDescription: "system_channel_desc".tr,
    );
    await _reminderService.scheduleProgress(
      timeoutDuration: (remainingTime - Duration(minutes: 1)),
      msgTitle: "activity_ending".trArgs([activityName]).firstCharUpper(),
      msgBody: "activity_ending_body".trArgs([activityName]).firstCharUpper(),
      iconResName: "ic_less_one_minute",
      iconColor: Colors.red,
      showWhenStamp: true,
      notificationID: 24,
      channelTitle: "system_channel_name".tr,
      channelDescription: "system_channel_desc".tr,
    );
  }

  void animateTo(double d) {
    neuProgressController.animateTo(d);
  }
}
