import 'package:neumodore/domain/data/session/session_service.dart';
import 'package:neumodore/infra/repositories/session/isession_repository.dart';
import 'package:neumodore/shared/core/use_case.dart';

class GetSessionCase implements UseCase<PomodoreSessionService, dynamic> {
  ISessionRepository _sessionRepo;

  GetSessionCase(this._sessionRepo);

  @override
  PomodoreSessionService execute(dynamic duration) {
    return _sessionRepo.loadSession();
  }
}
