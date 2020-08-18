import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neumodore/domain/app_config/settings_entries.dart';
import 'package:neumodore/domain/usecases/settings/change_duration_request.dart';
import 'package:neumodore/domain/usecases/settings/decrease_config_duration.dart';
import 'package:neumodore/domain/usecases/settings/increase_config_duration.dart';
import 'package:neumodore/domain/usecases/settings/load_theme_mode_case.dart';
import 'package:neumodore/domain/usecases/settings/set_theme_mode_case.dart';
import 'package:neumodore/infra/configuration/configuration_repository.dart';
import 'package:neumodore/infra/repositories/itheme_repository.dart';

class SettingsController extends GetxController {
  ISettingsRepository _settingsRepo;
  IThemeRepository _themeRepository;

  SetThemeModeUseCase _setThemeModeCase;
  LoadThemeModeUseCase _loadTheemModeCase;

  String get pomodoreInterval =>
      _fetchConfig(settings.pomodoreDuration)?.inMinutes?.toString() ?? "--";

  String get shortBreakInterval =>
      _fetchConfig(settings.shortBreakDuration)?.inMinutes?.toString() ?? "--";

  String get longBreakInterval =>
      _fetchConfig(settings.longBreakDuration)?.inMinutes?.toString() ?? "--";

  ThemeMode get themeMode => _themeRepository.getThemeMode();

  set themeMode(ThemeMode val) {
    _themeRepository.setThemeMode(val);
    update();
  }

  SettingsEntries settings = SettingsEntries();
  SettingsController(this._settingsRepo, this._themeRepository) {
    this._setThemeModeCase = SetThemeModeUseCase(_themeRepository);
    this._loadTheemModeCase = LoadThemeModeUseCase(_themeRepository);
  }

  @override
  void onInit() async {
    super.onInit();
    await loadThemeMode();
  }

  Future loadThemeMode() async {
    try {
      _setThemeModeCase.execute(null);
      Get.changeThemeMode(themeMode);
    } catch (error) {
      print({'[LOAD THEME ERROR]': error});
      Get.changeThemeMode(
          Get.isPlatformDarkMode ? ThemeMode.dark : ThemeMode.light);
    }
  }

  void setTheme(int val) async {
    final themeMode = ThemeMode.values.elementAt(val);
    _setThemeModeCase.execute(themeMode);
    Get.changeThemeMode(themeMode);

    update();
  }

  plusPomodoreDuration(Duration duration) async {
    await _increaseDuration(settings.pomodoreDuration, duration);
    update();
  }

  plusLongBreakDuration(Duration duration) async {
    await _increaseDuration(settings.longBreakDuration, duration);
    update();
  }

  plusShortBreakDuration(Duration duration) async {
    await _increaseDuration(settings.shortBreakDuration, duration);
    update();
  }

  minusPomodoreDuration(Duration duration) async {
    await _decreaseDuration(settings.pomodoreDuration, duration);
    update();
  }

  minusLongBreakDuration(Duration duration) async {
    await _decreaseDuration(settings.longBreakDuration, duration);
    update();
  }

  minusShortBreakDuration(Duration duration) async {
    await _decreaseDuration(settings.shortBreakDuration, duration);
    update();
  }

  _fetchConfig(ConfigurationEntry config) => _settingsRepo.getConfiguration(
        config,
      );

  _increaseDuration(
    ConfigurationEntry config,
    Duration duration,
  ) {
    return IncreaseConfigDurationCase(_settingsRepo).execute(
      ChangeDurationRequest(
        configuration: config,
        value: duration,
      ),
    );
  }

  _decreaseDuration(
    ConfigurationEntry<Duration> config,
    Duration value,
  ) {
    DecreaseConfigDurationCase(_settingsRepo).execute(
      ChangeDurationRequest(
        configuration: config,
        value: value,
      ),
    );
  }
}
