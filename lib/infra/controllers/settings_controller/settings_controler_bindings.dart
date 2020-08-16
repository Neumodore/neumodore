import 'package:get/get.dart';
import 'package:neumodore/infra/controllers/settings_controller/settings_controller.dart';
import 'package:neumodore/infra/repositories/app_repository.dart';
import 'package:neumodore/infra/repositories/configuration/configuration_repository.dart';

class SettingsScreenBinding implements Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => AppStateRepository(
        Get.find(),
      ),
    );

    Get.lazyPut<ConfigurationRepo>(
      () => ConfigurationRepo(
        Get.find(),
      ),
    );

    Get.put<SettingsController>(
      SettingsController(
        Get.find<AppStateRepository>(),
        Get.find<ConfigurationRepo>(),
      ),
      permanent: true,
    );
  }
}
