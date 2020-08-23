import 'package:neumodore/domain/data/session/session.dart';
import 'package:neumodore/infra/repositories/session/isession_repository.dart';

import 'package:neumodore/shared/core/use_case.dart';

class PauseActivityCase implements UseCase<Future<PomodoreSession>, dynamic> {
  ISessionRepository _sessionRepository;

  PauseActivityCase(
    this._sessionRepository,
  );

  @override
  Future<PomodoreSession> execute(dynamic argument) async {
    var currentSession = this._sessionRepository.loadSession();
    currentSession.pauseSession();
    await this._sessionRepository.saveSession(currentSession);
    return currentSession;
  }
}
