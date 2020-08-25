import 'package:neumodore/domain/data/session/session_service.dart';
import 'package:neumodore/infra/repositories/session/isession_repository.dart';
import 'package:neumodore/shared/core/use_case.dart';

class IncreaseActivityDurationCase
    implements UseCase<Future<PomodoreSessionService>, Duration> {
  IncreaseActivityDurationCase(this._sessionRepository);

  ISessionRepository _sessionRepository;

  @override
  Future<PomodoreSessionService> execute(Duration durationToBeIncreased) async {
    final session = _sessionRepository.loadSession();
    session.increaseDuration(durationToBeIncreased);
    await _sessionRepository.saveSession(session);
    return session;
  }
}
