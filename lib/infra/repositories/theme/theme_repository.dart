import 'package:flutter/material.dart';
import 'package:neumodore/domain/app_config/settings_entries.dart';
import 'package:neumodore/infra/configuration/configuration_repository.dart';
import 'package:neumodore/infra/repositories/theme/itheme_repository.dart';

class ThemeRepository implements IThemeRepository {
  final themeModeSettings = ConfigurationEntry<ThemeMode>(
    entryKey: 'theme_mode',
    defaultValue: ThemeMode.system,
    fromStorageTransformer: (fromStorage) => ThemeMode.values.elementAt(
      int.parse(fromStorage),
    ),
    toStorageTransformer: (value) => value.index.toString(),
  );

  ISettingsRepository _settingsRepo;

  ThemeRepository(this._settingsRepo);

  @override
  ThemeMode getThemeMode() {
    try {
      return _settingsRepo.getConfiguration(themeModeSettings);
    } catch (e) {
      print(e);
      return ThemeMode.system;
    }
  }

  @override
  Future<bool> setThemeMode(ThemeMode state) async {
    try {
      return _settingsRepo.setConfiguration(themeModeSettings, state);
    } catch (e) {
      print(e);
      return false;
    }
  }
}
