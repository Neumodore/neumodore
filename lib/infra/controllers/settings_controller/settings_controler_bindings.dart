import 'package:get/get.dart';
import 'package:neumodore/infra/configuration/configuration_repository.dart';
import 'package:neumodore/infra/controllers/settings_controller/settings_controller.dart';
import 'package:neumodore/infra/repositories/itheme_repository.dart';

class SettingsScreenBinding implements Bindings {
  @override
  void dependencies() async {
    Get.lazyPut<SettingsRepo>(
      () => SettingsRepo(
        Get.find(),
      ),
    );

    Get.put<SettingsController>(
      SettingsController(
        Get.find<ISettingsRepository>(),
        Get.find<IThemeRepository>(),
      ),
      permanent: true,
    );
  }
}
