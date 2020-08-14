import 'package:flutter/material.dart';
import 'package:neumodore/data/activity/activity.dart';
import 'package:neumodore/data/pomodore_state.dart';
import 'package:neumodore/data/app_config/app_config.dart';
import 'package:neumodore/infra/repositories/istate_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String CONFIG_KEY = 'configkey';
const String THEME_STORAGE_KEY = "theme_storage";
const String STATE_KEY = 'statekey';

class AppStateRepository implements IApplicationRepository {
  Future<SharedPreferences> _sharedPrefs;

  AppStateRepository(this._sharedPrefs) {
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  Future<AppConfig> loadConfig({AppConfig standardValue}) async {
    return AppConfig.fromJson((await _sharedPrefs).getString(CONFIG_KEY));
  }

  @override
  Future<bool> saveConfig(AppConfig state) async {
    return (await _sharedPrefs).setString(CONFIG_KEY, state.toJson());
  }

  @override
  Future<PomodoreState> loadState({PomodoreState standardValue}) async {
    return PomodoreState(PomodoreActivity(), finishedActivities: []);
  }

  @override
  Future<void> saveState(PomodoreState state) async {}

  @override
  Future<ThemeMode> loadThemeMode({ThemeMode standardValue}) async {
    return themeModeFromIndex(
      (await _sharedPrefs).getString(THEME_STORAGE_KEY).toString(),
    );
  }

  @override
  Future saveThemeMode(ThemeMode mode) async {
    await (await _sharedPrefs).setString(
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
