import 'package:neumodore/domain/data/session/session.dart';

abstract class ISessionRepository {
  saveSession(PomodoreSession _session);
  PomodoreSession loadSession();
}
