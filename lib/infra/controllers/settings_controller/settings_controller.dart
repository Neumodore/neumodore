import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neumodore/domain/app_config/settings_entries.dart';
import 'package:neumodore/domain/data/activity/activity.dart';
import 'package:neumodore/domain/data/session/session_settings.dart';
import 'package:neumodore/domain/usecases/settings/change_duration_request.dart';
import 'package:neumodore/domain/usecases/settings/change_settings_duration.dart';
import 'package:neumodore/domain/usecases/settings/load_theme_mode_case.dart';
import 'package:neumodore/domain/usecases/settings/set_theme_mode_case.dart';
import 'package:neumodore/infra/repositories/session_settings/session_settings_repository.dart';
import 'package:neumodore/infra/repositories/theme/itheme_repository.dart';

class SettingsController extends GetxController {
  final IThemeRepository _themeRepository;

  final SetThemeModeUseCase _setThemeModeCase;
  final LoadThemeModeUseCase _loadThemeModeCase;

  final SettingsEntries settings = SettingsEntries();

  final SessionSettingsRepository _sessionSettingsRepo;

  SettingsController(this._themeRepository, this._sessionSettingsRepo)
      : this._setThemeModeCase = SetThemeModeUseCase(_themeRepository),
        this._loadThemeModeCase = LoadThemeModeUseCase(_themeRepository);

  String get pomodoreInterval =>
      _fetchConfig?.defaultPomodore?.totalDuration?.inMinutes?.toString() ??
      "--";

  String get shortBreakInterval =>
      _fetchConfig?.defaultShortBreak?.totalDuration?.inMinutes?.toString() ??
      "--";

  String get longBreakInterval =>
      _fetchConfig?.defaultLongBreak?.totalDuration?.inMinutes?.toString() ??
      "--";

  ThemeMode get themeMode => _loadThemeModeCase.execute(ThemeMode.system);

  set themeMode(ThemeMode val) {
    _setThemeModeCase.execute(val);
    update();
  }

  @override
  void onInit() async {
    super.onInit();
  }

  Future loadThemeMode() async {
    try {
      Get.changeThemeMode(this.themeMode);
    } catch (error) {
      print({'[LOAD THEME ERROR]': error});
      Get.changeThemeMode(
        Get.isPlatformDarkMode ? ThemeMode.dark : ThemeMode.light,
      );
    }
  }

  void setTheme(int val) async {
    final themeMode = ThemeMode.values.elementAt(val);
    _setThemeModeCase.execute(themeMode);
    Get.changeThemeMode(themeMode);

    update();
  }

  plusPomodoreDuration(Duration duration) async {
    await _increaseDuration(ActivityType.POMODORE, duration);
    update();
  }

  plusLongBreakDuration(Duration duration) async {
    await _increaseDuration(ActivityType.LONG_BREAK, duration);
    update();
  }

  plusShortBreakDuration(Duration duration) async {
    await _increaseDuration(ActivityType.SHORT_BREAK, duration);
    update();
  }

  decreasePomodore(Duration duration) async {
    await _decreaseDuration(ActivityType.POMODORE, duration);
    update();
  }

  decreaseLongBreak(Duration duration) async {
    await _decreaseDuration(ActivityType.LONG_BREAK, duration);
    update();
  }

  decreaseShortBreak(Duration duration) async {
    await _decreaseDuration(ActivityType.SHORT_BREAK, duration);
    update();
  }

  SessionSettings get _fetchConfig => this._sessionSettingsRepo.loadSettings();

  _increaseDuration(
    ActivityType type,
    Duration duration,
  ) {
    return ChangeSettingsDurationCase(_sessionSettingsRepo).execute(
      ChangeDurationRequest(
        activity: type,
        duration: duration,
        changeType: ChangeType.INCREASE,
      ),
    );
  }

  _decreaseDuration(
    ActivityType type,
    Duration duration,
  ) {
    return ChangeSettingsDurationCase(_sessionSettingsRepo).execute(
      ChangeDurationRequest(
        activity: type,
        duration: duration,
        changeType: ChangeType.DECREASE,
      ),
    );
  }
}
