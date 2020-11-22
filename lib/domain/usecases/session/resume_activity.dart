import 'package:neumodore/domain/data/pomodore_session/session_service.dart';
import 'package:neumodore/infra/repositories/session/isession_repository.dart';

import 'package:neumodore/shared/core/use_case.dart';

class ResumeActivityCase
    implements UseCase<Future<PomodoreSessionService>, dynamic> {
  ISessionRepository _sessionRepository;

  ResumeActivityCase(
    this._sessionRepository,
  );

  @override
  Future<PomodoreSessionService> execute(dynamic argument) async {
    final currentSession = this._sessionRepository.loadSession();
    currentSession.resumeSession();
    this._sessionRepository.saveSession(currentSession);
    return currentSession;
  }
}
