import 'package:get/get.dart';
import 'package:neumodore/infra/controllers/pomodore_controller/pomodore_controller.dart';
import 'package:neumodore/infra/repositories/app_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PomodoreControllerBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut<AppStateRepository>(
      () => AppStateRepository(SharedPreferences.getInstance()),
    );
    Get.lazyPut<PomodoreController>(
      () => PomodoreController(Get.find<AppStateRepository>()),
    );
  }
}
