import 'package:get/get.dart';
import 'package:neumodore/infra/controllers/pomodore_controller/pomodore_controller.dart';
import 'package:neumodore/infra/persistence/sharedprefs_persistence.dart';

class PomodoreControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SharedPrefsPersistence>(
      () => SharedPrefsPersistence(),
    );
    Get.lazyPut<PomodoreController>(
      () => PomodoreController(
        Get.find<SharedPrefsPersistence>(),
      ),
    );
  }
}
