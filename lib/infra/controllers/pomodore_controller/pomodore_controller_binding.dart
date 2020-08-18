import 'package:get/get.dart';
import 'package:neumodore/infra/configuration/configuration_repository.dart';
import 'package:neumodore/infra/controllers/pomodore_controller/pomodore_controller.dart';
import 'package:neumodore/infra/repositories/activity_repository.dart';
import 'package:neumodore/infra/repositories/iactivity_repo.dart';
import 'package:neumodore/infra/repositories/itheme_repository.dart';
import 'package:neumodore/infra/repositories/theme_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PomodoreControllerBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut<ISettingsRepository>(
      () => SettingsRepo(
        Get.find<SharedPreferences>(),
      ),
    );

    Get.lazyPut<IThemeRepository>(
      () => ThemeRepository(
        Get.find<ISettingsRepository>(),
      ),
    );

    Get.lazyPut<IActivityRepository>(
      () => ActivityRepository(
        Get.find<SharedPreferences>(),
      ),
    );

    Get.put<PomodoreController>(
      PomodoreController(
        Get.find<IActivityRepository>(),
        Get.find<ISettingsRepository>(),
      ),
      permanent: true,
    );
  }
}
