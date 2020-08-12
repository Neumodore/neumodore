import 'package:neumodore/data/app_config/app_config.dart';
import 'package:neumodore/data/pomodore_state.dart';

abstract class IPersistenceAdapter {
  void saveState(PomodoreState state);
  void saveConfig(AppConfig state);

  Future<PomodoreState> loadState({PomodoreState standardValue});
  Future<AppConfig> loadConfig({AppConfig standardValue});
}
