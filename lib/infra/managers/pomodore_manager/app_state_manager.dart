import 'package:neumodore/data/app_config/app_config.dart';
import 'package:neumodore/data/pomodore_state.dart';
import 'package:neumodore/infra/repositories/istate_repository.dart';

class AppStateManager {
  AppConfig _configuration;
  PomodoreState _neumodoreState;

  AppConfig get configuration => _configuration;
  PomodoreState get neumodoreState => _neumodoreState;

  IApplicationRepository _persist;

  AppStateManager(IApplicationRepository persistenceAdapter) {
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
