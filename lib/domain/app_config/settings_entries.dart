import 'package:shared_preferences/shared_preferences.dart';

class SettingsEntries {
  final shortBreakDuration = ConfigurationEntry<Duration>(
    entryKey: 'shortbreak_length',
    defaultValue: Duration(minutes: 5),
    fromStorageTransformer: (value) {
      return Duration(minutes: int.parse(value));
    },
    toStorageTransformer: (value) {
      return value.inMinutes.toString();
    },
  );

  final longBreakDuration = ConfigurationEntry<Duration>(
    entryKey: 'longbreak_length',
    defaultValue: Duration(minutes: 15),
    fromStorageTransformer: (value) {
      return Duration(minutes: int.parse(value));
    },
    toStorageTransformer: (value) {
      return value.inMinutes.toString();
    },
  );

  final pomodoreDuration = ConfigurationEntry<Duration>(
    entryKey: 'pomodore_lenght',
    defaultValue: Duration(minutes: 25),
    fromStorageTransformer: (String storageVal) {
      return Duration(minutes: int.parse(storageVal));
    },
    toStorageTransformer: (duratio) {
      return duratio.inMinutes.toString();
    },
  );

  final sessionsLimitCount = ConfigurationEntry<int>(
    entryKey: 'session_pomodore_count',
    defaultValue: 4,
    fromStorageTransformer: (storageVal) {
      return int.parse(storageVal);
    },
    toStorageTransformer: (duratio) {
      return duratio.toString();
    },
  );
}

class ConfigurationEntry<T> {
  ConfigurationEntry({
    this.entryKey,
    this.defaultValue,
    this.fromStorageTransformer,
    this.toStorageTransformer,
  });

  final T defaultValue;
  final String entryKey;
  final T Function(String fromStorage) fromStorageTransformer;
  final String Function(T value) toStorageTransformer;

  T getValue(SharedPreferences _storagePrefs) {
    try {
      return fromStorageTransformer(_storagePrefs.getString(entryKey)) ??
          defaultValue;
    } catch (e) {
      print({
        '[CONFIGURATION LOAD ERROR]': e,
        'CONVERTER': entryKey,
        'defaultValue': defaultValue,
      });

      return defaultValue;
    }
  }

  Future<bool> updateValue(T value, SharedPreferences _storagePrefs) async {
    try {
      return _storagePrefs.setString(
        entryKey,
        toStorageTransformer(value),
      );
    } catch (e) {
      print({
        '[CONFIGURATION SAVE ERROR]': e,
        'CONVERTER': entryKey,
        'defaultValue': defaultValue,
      });
      return _storagePrefs.setString(
        entryKey,
        toStorageTransformer(defaultValue),
      );
    }
  }
}
