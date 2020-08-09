import 'package:neumodore/data/app_config/app_config.dart';
import 'package:neumodore/data/neumodore_state/neumodore_state.dart';

abstract class INeumodorePersistence {
  void saveState(PomodoreState state);
  void saveConfig(AppConfig state);

  PomodoreState loadState({PomodoreState standardValue});
  AppConfig loadConfig({AppConfig standardValue});
}
