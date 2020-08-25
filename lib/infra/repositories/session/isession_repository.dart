import 'package:neumodore/domain/data/session/session_service.dart';

abstract class ISessionRepository {
  saveSession(PomodoreSessionService _session);
  PomodoreSessionService loadSession();
}
