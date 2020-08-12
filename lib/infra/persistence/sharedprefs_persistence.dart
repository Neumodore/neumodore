import 'package:flutter/cupertino.dart';
import 'package:neumodore/data/activity/activity.dart';
import 'package:neumodore/data/pomodore_state.dart';
import 'package:neumodore/data/app_config/app_config.dart';
import 'package:neumodore/infra/persistence/ipersistence_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String CONFIG_KEY = 'configkey';
const String stateKey = 'statekey';

class SharedPrefsPersistence implements IPersistenceAdapter {
  Future<SharedPreferences> sharedInstance;

  SharedPrefsPersistence() {
    WidgetsFlutterBinding.ensureInitialized();
    this.sharedInstance = SharedPreferences.getInstance();
  }

  @override
  Future<AppConfig> loadConfig({AppConfig standardValue}) async {
    return AppConfig.fromJson((await sharedInstance).getString(CONFIG_KEY));
  }

  @override
  void saveConfig(AppConfig state) async {
    await (await sharedInstance).setString(CONFIG_KEY, state.toJson());
  }

  @override
  Future<PomodoreState> loadState({PomodoreState standardValue}) async {
    // TODO: implement loadState
    return PomodoreState(PomodoreActivity(), finishedActivities: []);
  }

  @override
  void saveState(PomodoreState state) async {
    // TODO: implement saveState
  }
}
