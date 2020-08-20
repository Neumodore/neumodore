import 'package:neumodore/domain/data/session/session.dart';
import 'package:neumodore/infra/repositories/session/isession_repository.dart';
import 'package:neumodore/shared/core/use_case.dart';

class GetSessionCase implements UseCase<PomodoreSession, dynamic> {
  ISessionRepository _sessionRepo;

  GetSessionCase(this._sessionRepo);

  @override
  PomodoreSession execute(dynamic duration) {
    return _sessionRepo.loadSession();
  }
}
