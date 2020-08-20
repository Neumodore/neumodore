import 'package:neumodore/domain/data/session/session.dart';
import 'package:neumodore/infra/repositories/session/isession_repository.dart';
import 'package:neumodore/infra/services/screen/iscreen_service.dart';
import 'package:neumodore/shared/core/use_case.dart';

class SkipActivityCase implements UseCase<PomodoreSession, dynamic> {
  ISessionRepository _sessionRepository;
  IScreenService _screenService;

  SkipActivityCase(this._sessionRepository, this._screenService);

  @override
  PomodoreSession execute(dynamic argument) {
    final currentSession = this._sessionRepository.loadSession();
    currentSession.skipActivity();
    this._sessionRepository.saveSession(currentSession);
    this._screenService.enableWakeLock();
    return currentSession;
  }
}
