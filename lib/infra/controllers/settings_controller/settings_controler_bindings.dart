import 'package:get/get.dart';
import 'package:neumodore/infra/controllers/settings_controller/settings_controller.dart';
import 'package:neumodore/infra/repositories/theme_repository.dart';

class SettingsScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ThemeModeRepository>(() => ThemeModeRepository());

    Get.lazyPut<SettingsController>(
      () => SettingsController(Get.find<ThemeModeRepository>()),
    );
  }
}
