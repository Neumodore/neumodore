import 'package:neumodore/domain/data/pomodore_session/session_service.dart';
import 'package:neumodore/infra/repositories/session/isession_repository.dart';
import 'package:neumodore/shared/core/use_case.dart';

class StopPomodoreSessionCase implements UseCase {
  ISessionRepository _sessionRepository;

  StopPomodoreSessionCase(this._sessionRepository);
  @override
  Future<PomodoreSessionService> execute(dynamic argument) async {
    final PomodoreSessionService session = _sessionRepository.loadSession();
    session.resetSession();
    await _sessionRepository.saveSession(session);
    return session;
  }
}
