import 'package:neumodore/domain/data/session/session.dart';
import 'package:neumodore/infra/repositories/session/isession_repository.dart';

import 'package:neumodore/shared/core/use_case.dart';

class ResumeActivityCase implements UseCase<Future<PomodoreSession>, dynamic> {
  ISessionRepository _sessionRepository;

  ResumeActivityCase(
    this._sessionRepository,
  );

  @override
  Future<PomodoreSession> execute(dynamic argument) async {
    final currentSession = this._sessionRepository.loadSession();
    currentSession.resumeSession();
    this._sessionRepository.saveSession(currentSession);
    return currentSession;
  }
}
