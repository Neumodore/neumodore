import 'package:get/get.dart';
import 'package:neumodore/infra/controllers/settings_controller/settings_controller.dart';
import 'package:neumodore/infra/repositories/app_repository.dart';

class SettingsScreenBinding implements Bindings {
  @override
  void dependencies() async {
    Get.lazyPut<SettingsController>(
      () => SettingsController(Get.find<AppStateRepository>()),
    );
  }
}
