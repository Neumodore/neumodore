import 'package:neumodore/data/app_config/app_config.dart';
import 'package:neumodore/data/neumodore_state/neumodore_persistence.dart';
import 'package:neumodore/data/neumodore_state/neumodore_state.dart';

class NeumodoreStateManager {
  AppConfig _configuration;
  PomodoreState _neumodoreState;

  NeumodoreStateManager(INeumodorePersistence persistenceContainer) {
    loadState(persistenceContainer);
  }

  void loadState(INeumodorePersistence persistenceContainer) {
    _configuration = persistenceContainer.loadConfig();
    _neumodoreState = persistenceContainer.loadState();
  }

  void saveState(INeumodorePersistence persistenceContainer) {
    persistenceContainer.saveConfig(_configuration);
    persistenceContainer.saveState(_neumodoreState);
  }
}
