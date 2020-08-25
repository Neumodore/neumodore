import 'package:neumodore/domain/data/session/session_service.dart';
import 'package:neumodore/infra/repositories/session/isession_repository.dart';
import 'package:neumodore/shared/core/use_case.dart';

class StartActivityCase
    implements UseCase<Future<PomodoreSessionService>, dynamic> {
  ISessionRepository _sessionRepository;

  StartActivityCase(this._sessionRepository);

  @override
  Future<PomodoreSessionService> execute(dynamic argument) async {
    var currentSession = this._sessionRepository.loadSession();
    currentSession.startSession();
    await this._sessionRepository.saveSession(currentSession);
    return currentSession;
  }
}
