import 'package:neumodore/infra/services/screen/iscreen_service.dart';
import 'package:wakelock/wakelock.dart';

class ScreenServiceConcrete implements IScreenService {
  @override
  Future disableWakeLock() async {
    return Wakelock.enable();
  }

  @override
  Future enableWakeLock() async {
    return Wakelock.disable();
  }
}
