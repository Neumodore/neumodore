import 'package:flutter/material.dart';
import 'package:neumodore/data/app_config/app_config.dart';
import 'package:neumodore/data/pomodore_state.dart';

abstract class IPomodoreRepository {
  Future<void> saveState(PomodoreState state);
  Future<PomodoreState> loadState({PomodoreState standardValue});
}

abstract class IThemeRepository {
  Future<void> saveThemeMode(ThemeMode state);
  Future<ThemeMode> loadThemeMode({ThemeMode standardValue});
  ThemeMode themeModeFromIndex(int index);
}

abstract class IConfigRepository {
  Future<void> saveConfig(AppConfig state);
  Future<AppConfig> loadConfig({AppConfig standardValue});
}

abstract class IApplicationRepository
    implements IConfigRepository, IThemeRepository, IPomodoreRepository {}
