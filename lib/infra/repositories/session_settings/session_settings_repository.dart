import 'dart:convert';

import 'package:neumodore/domain/app_config/settings_entries.dart';
import 'package:neumodore/domain/data/activity/activity.dart';
import 'package:neumodore/domain/data/session/session_settings.dart';
import 'package:neumodore/infra/configuration/configuration_repository.dart';

const SESSION_SETTINGS_KEY = 'session_settings';

class SessionSettingsRepository {
  final ISettingsRepository settingsRepo;

  ConfigurationEntry _settingsEntry;

  SessionSettingsRepository(this.settingsRepo,
      {SessionSettings defaultSettings}) {
    _settingsEntry = ConfigurationEntry<SessionSettings>(
      entryKey: SESSION_SETTINGS_KEY,
      defaultValue: SessionSettings(
        PomodoreActivity(),
        ShortBreakActivity(),
        LongBreakActivity(),
        4,
      ),
      fromStorageTransformer: (fromStorage) {
        if (fromStorage != null) {
          final decoded = jsonDecode(fromStorage);
          final mapped = SessionSettings.fromJson(decoded);
          return mapped;
        } else {
          throw Exception("Session Settings empty");
        }
      },
      toStorageTransformer: (value) {
        final mapped = value.toJson();
        final json = jsonEncode(mapped);
        return json;
      },
    );
  }

  SessionSettings loadSettings() {
    return settingsRepo.getConfiguration(_settingsEntry);
  }

  Future<SessionSettings> saveSettings(SessionSettings newSettings) async {
    await settingsRepo.setConfiguration(
      _settingsEntry,
      newSettings,
    );
    return newSettings;
  }
}

class SessionSettingsRepositoryMock implements SessionSettingsRepository {
  SessionSettingsRepositoryMock();
  @override
  SessionSettings loadSettings() {
    return SessionSettings(
      PomodoreActivity(duration: Duration(seconds: 5)),
      LongBreakActivity(),
      ShortBreakActivity(),
      2,
    );
  }

  @override
  ConfigurationEntry _settingsEntry;

  @override
  // TODO: implement _defaultSettings
  SessionSettings get _defaultSettings => throw UnimplementedError();

  @override
  Future<SessionSettings> saveSettings(SessionSettings newSettings) {
    // TODO: implement saveSettings
    throw UnimplementedError();
  }

  @override
  // TODO: implement settingsRepo
  SettingsRepository get settingsRepo => throw UnimplementedError();
}
