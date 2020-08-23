import 'package:neumodore/domain/data/session/session.dart';
import 'package:neumodore/infra/repositories/session/isession_repository.dart';
import 'package:neumodore/shared/core/use_case.dart';

class SkipActivityCase implements UseCase<Future<PomodoreSession>, dynamic> {
  ISessionRepository _sessionRepository;

  SkipActivityCase(this._sessionRepository);

  @override
  Future<PomodoreSession> execute(dynamic argument) async {
    final currentSession = this._sessionRepository.loadSession();
    currentSession.skipActivity();
    await this._sessionRepository.saveSession(currentSession);
    return currentSession;
  }
}
