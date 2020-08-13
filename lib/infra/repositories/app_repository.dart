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
  SharedPreferences _sharedPrefs;

  AppStateRepository(Future<SharedPreferences> sharedPrefsInstance) {
    WidgetsFlutterBinding.ensureInitialized();
    sharedPrefsInstance.then((value) => _sharedPrefs = value);
  }

  @override
  Future<AppConfig> loadConfig({AppConfig standardValue}) async {
    return AppConfig.fromJson(_sharedPrefs.getString(CONFIG_KEY));
  }

  @override
  Future<void> saveConfig(AppConfig state) async {
    await _sharedPrefs.setString(CONFIG_KEY, state.toJson());
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
      int.parse(
        (await SharedPreferences.getInstance())
            .getString(THEME_STORAGE_KEY)
            .toString(),
      ),
    );
  }

  @override
  Future saveThemeMode(ThemeMode mode) async {
    await (await SharedPreferences.getInstance())
        .setString(THEME_STORAGE_KEY, mode.index.toString());
  }

  @override
  ThemeMode themeModeFromIndex(int index) {
    return ThemeMode.values.elementAt(index);
  }
}
