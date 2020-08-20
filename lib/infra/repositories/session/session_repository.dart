import 'dart:convert';

import 'package:neumodore/domain/data/session/session.dart';
import 'package:neumodore/domain/data/session/session_settings.dart';
import 'package:neumodore/infra/repositories/session/isession_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

const SESSION_STORAGE_KEY = 'session_storage3';

class ValueNotFoundException implements Exception {
  String message = "Value not founded in storage";

  ValueNotFoundException({this.message});
}

class SessionRepository implements ISessionRepository {
  SharedPreferences _dbContext;
  SessionSettings _defaultSettings;

  SessionRepository(this._dbContext, this._defaultSettings);
  @override
  PomodoreSession loadSession() {
    try {
      final strings = _dbContext.getString(SESSION_STORAGE_KEY);
      if (strings == null) throw ValueNotFoundException();

      return PomodoreSession.fromJson(jsonDecode(strings))
        ..sessionSettings = _defaultSettings;
    } catch (e) {
      if (e.runtimeType == ValueNotFoundException)
        return PomodoreSession(_defaultSettings);
      else
        throw e;
    }
  }

  @override
  saveSession(PomodoreSession _session) {
    return _dbContext.setString(
      SESSION_STORAGE_KEY,
      jsonEncode(_session.toJson()),
    );
  }
}
