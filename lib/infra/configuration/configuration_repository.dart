import 'package:neumodore/domain/app_config/settings_entries.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ISettingsRepository {
  ISettingsRepository(sharedPrefs);

  Future<bool> setConfiguration(ConfigurationEntry entry, dynamic newValue);

  dynamic getConfiguration(ConfigurationEntry<dynamic> entry);
}

class SettingsRepo implements ISettingsRepository {
  SharedPreferences _sharedPrefs;

  SettingsRepo(this._sharedPrefs);

  @override
  dynamic getConfiguration(
    ConfigurationEntry entry,
  ) {
    return entry.getValue(_sharedPrefs);
  }

  @override
  Future<bool> setConfiguration(
    ConfigurationEntry entry,
    dynamic newValue,
  ) {
    return entry.updateValue(newValue, _sharedPrefs);
  }
}
