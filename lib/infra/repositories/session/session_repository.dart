import 'dart:convert';

import 'package:neumodore/domain/data/pomodore_session/session_service.dart';
import 'package:neumodore/infra/repositories/session/isession_repository.dart';
import 'package:neumodore/infra/repositories/session_settings/session_settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

const SESSION_STORAGE_KEY = 'session_storage3';

class ValueNotFoundException implements Exception {
  String message = "Value not founded in storage";

  ValueNotFoundException({this.message});
}

class SessionRepository implements ISessionRepository {
  SharedPreferences _dbContext;
  SessionSettingsRepository _sessionSettingsRepo;

  SessionRepository(this._dbContext, this._sessionSettingsRepo);
  @override
  PomodoreSessionService loadSession() {
    try {
      final strings = _dbContext.getString(SESSION_STORAGE_KEY);
      if (strings == null) throw ValueNotFoundException();

      return PomodoreSessionService.fromJson(jsonDecode(strings))
        ..sessionSettingsRepository = _sessionSettingsRepo;
    } catch (e) {
      if (e.runtimeType == ValueNotFoundException)
        return PomodoreSessionService(_sessionSettingsRepo);
      else
        throw e;
    }
  }

  @override
  saveSession(PomodoreSessionService _session) {
    return _dbContext.setString(
      SESSION_STORAGE_KEY,
      jsonEncode(_session.toJson()),
    );
  }
}
