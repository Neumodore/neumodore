import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neumodore/domain/data/app_config/settings_entries.dart';
import 'package:neumodore/domain/usecases/settings/change_duration_request.dart';
import 'package:neumodore/domain/usecases/settings/decrease_config_duration.dart';
import 'package:neumodore/domain/usecases/settings/increase_config_duration.dart';
import 'package:neumodore/infra/repositories/configuration/configuration_repository.dart';
import 'package:neumodore/infra/repositories/istate_repository.dart';

class SettingsController extends GetxController {
  IApplicationRepository _appRepo;
  ISettingsRepository _configRepository;

  String get pomodoreInterval =>
      _fetchConfig(entries.pomodoreDuration)?.inMinutes?.toString() ?? "fail";

  String get shortBreakInterval =>
      _fetchConfig(entries.shortBreakDuration)?.inMinutes?.toString() ?? "fail";

  String get longBreakInterval =>
      _fetchConfig(entries.longBreakDuration)?.inMinutes?.toString() ?? "fail";

  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;
  set themeMode(ThemeMode val) {
    _themeMode = val;
    update();
  }

  SettingsEntries entries = SettingsEntries();
  SettingsController(this._appRepo, this._configRepository);

  @override
  void onInit() async {
    super.onInit();
    await loadThemeMode();
  }

  Future loadThemeMode() async {
    try {
      final themeMode = await _appRepo.loadThemeMode();
      Get.changeThemeMode(themeMode);
    } catch (error) {
      print({'[LOAD THEME ERROR]': error});
      Get.changeThemeMode(
          Get.isPlatformDarkMode ? ThemeMode.dark : ThemeMode.light);
    }
  }

  void switchTheme() async {
    ThemeMode curTheme = await _appRepo.loadThemeMode();
    _appRepo.saveThemeMode(
      curTheme == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
    );
    update();
  }

  void setTheme(int val) async {
    try {
      await _appRepo.saveThemeMode(_appRepo.themeModeFromIndex(val));
      Get.changeThemeMode(_appRepo.themeModeFromIndex(val));
    } catch (e) {
      print({'[----ERROR]': e});
    }

    update();
  }

  void refreshTheme() async {
    try {
      ThemeMode curTheme = await _appRepo.loadThemeMode();
      Get.changeThemeMode(curTheme);
    } catch (e) {
      Get.changeThemeMode(
        Get.isPlatformDarkMode ? ThemeMode.dark : ThemeMode.light,
      );
    }
  }

  plusPomodoreDuration(Duration duration) async {
    await _increaseDuration(entries.pomodoreDuration, duration);
    update();
  }

  plusLongBreakDuration(Duration duration) async {
    await _increaseDuration(entries.longBreakDuration, duration);
    update();
  }

  plusShortBreakDuration(Duration duration) async {
    await _increaseDuration(entries.shortBreakDuration, duration);
    update();
  }

  minusPomodoreDuration(Duration duration) async {
    await _decreaseDuration(entries.pomodoreDuration, duration);
    update();
  }

  minusLongBreakDuration(Duration duration) async {
    await _decreaseDuration(entries.longBreakDuration, duration);
    update();
  }

  minusShortBreakDuration(Duration duration) async {
    await _decreaseDuration(entries.shortBreakDuration, duration);
    update();
  }

  _fetchConfig(ConfigurationEntry config) => _configRepository.getConfiguration(
        config,
      );

  _increaseDuration(
    ConfigurationEntry config,
    Duration duration,
  ) {
    return IncreaseConfigDurationCase(_configRepository).execute(
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
    DecreaseConfigDurationCase(_configRepository).execute(
      ChangeDurationRequest(
        configuration: config,
        value: value,
      ),
    );
  }
}
