import 'package:neumodore/domain/data/pomodore_session/session_service.dart';

abstract class ISessionRepository {
  saveSession(PomodoreSessionService _session);
  PomodoreSessionService loadSession();
}
