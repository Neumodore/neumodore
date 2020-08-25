import 'package:neumodore/domain/data/session/session_service.dart';
import 'package:neumodore/infra/repositories/session/isession_repository.dart';
import 'package:neumodore/shared/core/use_case.dart';

class SkipActivityCase
    implements UseCase<Future<PomodoreSessionService>, dynamic> {
  ISessionRepository _sessionRepository;

  SkipActivityCase(this._sessionRepository);

  @override
  Future<PomodoreSessionService> execute(dynamic argument) async {
    final currentSession = this._sessionRepository.loadSession();
    currentSession.skipActivity();
    await this._sessionRepository.saveSession(currentSession);
    return currentSession;
  }
}
