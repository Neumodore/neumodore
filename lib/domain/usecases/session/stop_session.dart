import 'package:neumodore/domain/data/session/session.dart';
import 'package:neumodore/infra/repositories/session/isession_repository.dart';
import 'package:neumodore/shared/core/use_case.dart';

class StopPomodoreSessionCase implements UseCase {
  ISessionRepository _sessionRepository;

  StopPomodoreSessionCase(this._sessionRepository);
  @override
  Future<PomodoreSession> execute(dynamic argument) async {
    final PomodoreSession session = _sessionRepository.loadSession();

    session.resetSession();

    _sessionRepository.saveSession(session);
    return session;
  }
}
