import 'package:neumodore/domain/data/activity/activity.dart';
import 'package:neumodore/domain/data/session/session.dart';
import 'package:neumodore/infra/repositories/session/isession_repository.dart';
import 'package:neumodore/shared/core/use_case.dart';

class ChangeStateUseCase
    implements UseCase<Future<PomodoreSession>, ActivityState> {
  ISessionRepository _sessionRepo;
  ChangeStateUseCase(this._sessionRepo);

  @override
  Future<PomodoreSession> execute(ActivityState nextState) {
    return _sessionRepo.saveSession(
      _sessionRepo.loadSession()..currentActivity.setState(nextState),
    );
  }
}
