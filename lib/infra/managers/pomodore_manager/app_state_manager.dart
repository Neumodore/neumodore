import 'package:neumodore/data/app_config/app_config.dart';
import 'package:neumodore/data/pomodore_state.dart';

import '../../persistence/ipersistence_adapter.dart';

class AppStateManager {
  AppConfig _configuration;
  PomodoreState _neumodoreState;

  AppConfig get configuration => _configuration;
  PomodoreState get neumodoreState => _neumodoreState;

  IPersistenceAdapter _persist;

  AppStateManager(IPersistenceAdapter persistenceAdapter) {
    this._persist = persistenceAdapter;
  }

  void loadState() async {
    _configuration = await _persist.loadConfig();
    _neumodoreState = await _persist.loadState();
  }

  void saveState() async {
    await _persist.saveConfig(_configuration);
    await _persist.saveState(_neumodoreState);
  }
}
