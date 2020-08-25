import 'package:neumodore/domain/data/activity/activity.dart';
import 'package:neumodore/domain/data/session/session_settings.dart';
import 'package:neumodore/infra/repositories/session_settings/session_settings_repository.dart';
import 'package:neumodore/shared/core/use_case.dart';
import 'package:neumodore/domain/usecases/settings/change_duration_request.dart';

enum ChangeType { INCREASE, DECREASE }

class ChangeSettingsDurationCase
    implements UseCase<Future<SessionSettings>, ChangeDurationRequest> {
  SessionSettingsRepository _sessionRepo;

  ChangeSettingsDurationCase(this._sessionRepo);

  @override
  Future<SessionSettings> execute(
    ChangeDurationRequest changeRequest,
  ) async {
    final settings = _sessionRepo.loadSettings();

    switch (changeRequest.activity) {
      case ActivityType.POMODORE:
        settings.defaultPomodore =
            _changeDuration(settings.defaultPomodore, changeRequest);
        break;
      case ActivityType.LONG_BREAK:
        settings.defaultLongBreak =
            _changeDuration(settings.defaultLongBreak, changeRequest);
        break;
      case ActivityType.SHORT_BREAK:
        settings.defaultShortBreak =
            _changeDuration(settings.defaultShortBreak, changeRequest);
        break;
      default:
        break;
    }
    await _sessionRepo.saveSettings(settings);
    return settings;
  }

  Activity _changeDuration(
    Activity defaultPomodore,
    ChangeDurationRequest changeRequest,
  ) {
    switch (changeRequest.changeType) {
      case ChangeType.DECREASE:
        defaultPomodore.totalDuration =
            _decreaseDuration(defaultPomodore.totalDuration, changeRequest);
        break;
      default:
        defaultPomodore.totalDuration =
            _increaseDuration(defaultPomodore.totalDuration, changeRequest);
        break;
    }
    return defaultPomodore;
  }

  Duration _decreaseDuration(
    Duration newDuration,
    ChangeDurationRequest request,
  ) {
    if (newDuration.inMinutes > 1) newDuration -= request.duration;
    return newDuration;
  }

  Duration _increaseDuration(
    Duration newDuration,
    ChangeDurationRequest request,
  ) {
    if (newDuration.inMinutes < 59) newDuration += request.duration;
    return newDuration;
  }
}
