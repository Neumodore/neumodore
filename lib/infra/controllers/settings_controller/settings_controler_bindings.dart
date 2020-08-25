import 'package:get/get.dart';
import 'package:neumodore/infra/configuration/configuration_repository.dart';
import 'package:neumodore/infra/controllers/settings_controller/settings_controller.dart';
import 'package:neumodore/infra/repositories/session_settings/session_settings_repository.dart';
import 'package:neumodore/infra/repositories/theme/itheme_repository.dart';
import 'package:neumodore/infra/repositories/theme/theme_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreenBinding implements Bindings {
  @override
  void dependencies() async {
    Get.put<ISettingsRepository>(
      SettingsRepository(
        Get.find<SharedPreferences>(),
      ),
      permanent: true,
    );

    Get.put<IThemeRepository>(
      ThemeRepository(Get.find<ISettingsRepository>()),
    );

    Get.put(
      SessionSettingsRepository(
        Get.find<ISettingsRepository>(),
      ),
      permanent: true,
    );

    Get.put<SettingsController>(
      SettingsController(
        Get.find<IThemeRepository>(),
        Get.find<SessionSettingsRepository>(),
      ),
      permanent: true,
    );
  }
}
