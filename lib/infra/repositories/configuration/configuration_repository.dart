import 'package:neumodore/domain/data/app_config/settings_entries.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ISettingsRepository {
  ISettingsRepository(sharedPrefs);

  Future<dynamic> setConfiguration(ConfigurationEntry entry, dynamic newValue);

  dynamic getConfiguration(ConfigurationEntry<dynamic> entry);
}

class ConfigurationRepo implements ISettingsRepository {
  SharedPreferences _sharedPrefs;

  ConfigurationRepo(this._sharedPrefs);

  @override
  dynamic getConfiguration(
    ConfigurationEntry entry,
  ) {
    return entry.getValue(_sharedPrefs);
  }

  @override
  Future<dynamic> setConfiguration(
    ConfigurationEntry entry,
    dynamic newValue,
  ) =>
      entry.updateValue(newValue, _sharedPrefs);
}
