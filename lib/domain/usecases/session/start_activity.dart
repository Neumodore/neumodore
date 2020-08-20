import 'package:neumodore/domain/data/session/session.dart';
import 'package:neumodore/infra/repositories/session/isession_repository.dart';
import 'package:neumodore/infra/services/screen/iscreen_service.dart';
import 'package:neumodore/shared/core/use_case.dart';

class StartActivityCase implements UseCase<PomodoreSession, dynamic> {
  ISessionRepository _sessionRepository;
  IScreenService _screenService;

  StartActivityCase(this._sessionRepository, this._screenService);

  @override
  PomodoreSession execute(dynamic argument) {
    var currentSession = this._sessionRepository.loadSession();
    currentSession.startSession();
    this._sessionRepository.saveSession(currentSession);
    this._screenService.enableWakeLock();
    return currentSession;
  }
}
