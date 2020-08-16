import 'package:flutter/material.dart';

import 'package:neumodore/domain/data/pomodore_state.dart';

abstract class IPomodoreRepository {
  Future<void> saveState(PomodoreState state);
  Future<PomodoreState> loadState({PomodoreState standardValue});
}

abstract class IThemeRepository {
  Future<void> saveThemeMode(ThemeMode state);
  Future<ThemeMode> loadThemeMode({ThemeMode standardValue});
  ThemeMode themeModeFromIndex(int index);
}

abstract class IApplicationRepository
    implements IThemeRepository, IPomodoreRepository {}
