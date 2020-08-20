import 'package:neumodore/domain/data/session/session.dart';
import 'package:neumodore/infra/repositories/session/isession_repository.dart';
import 'package:neumodore/infra/services/screen/iscreen_service.dart';
import 'package:neumodore/shared/core/use_case.dart';

class ResumeActivityCase implements UseCase<PomodoreSession, dynamic> {
  ISessionRepository _sessionRepository;
  IScreenService _screenService;

  ResumeActivityCase(this._sessionRepository, this._screenService);

  @override
  PomodoreSession execute(dynamic argument) {
    final currentSession = this._sessionRepository.loadSession();
    currentSession.resumeSession();
    this._sessionRepository.saveSession(currentSession);
    this._screenService.disableWakeLock();
    return currentSession;
  }
}
