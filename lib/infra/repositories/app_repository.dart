import 'package:flutter/material.dart';
import 'package:neumodore/domain/data/activity/activity.dart';
import 'package:neumodore/domain/data/pomodore_state.dart';
import 'package:neumodore/infra/repositories/istate_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String CONFIG_KEY = 'configkey';
const String THEME_STORAGE_KEY = "theme_storage";
const String STATE_KEY = 'statekey';

class AppStateRepository implements IApplicationRepository {
  SharedPreferences _sharedPrefs;

  AppStateRepository(this._sharedPrefs) {
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  Future<PomodoreState> loadState({PomodoreState standardValue}) async {
    return PomodoreState(PomodoreActivity(), finishedActivities: []);
  }

  @override
  Future<void> saveState(PomodoreState state) async {}

  @override
  Future<ThemeMode> loadThemeMode({ThemeMode standardValue}) async {
    try {
      return themeModeFromIndex(
        _sharedPrefs.getString(THEME_STORAGE_KEY).toString(),
      );
    } catch (e) {
      return ThemeMode.system;
    }
  }

  @override
  Future saveThemeMode(ThemeMode mode) async {
    await _sharedPrefs.setString(
      THEME_STORAGE_KEY,
      mode.index.toString(),
    );
  }

  @override
  ThemeMode themeModeFromIndex(dynamic index) {
    return ThemeMode.values.elementAt(
      int.parse(index.toString()),
    );
  }
}
