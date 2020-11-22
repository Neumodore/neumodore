import 'package:get/get.dart';
import 'package:neumodore/app/features/clickup/clickup_controller.dart';
import 'package:neumodore/domain/services/clickup/clickup_api.dart';
import 'package:neumodore/infra/services/deep_links.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClickupBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ClickupApiService>(
      ClickupApiService(
        Get.find<SharedPreferences>(),
      ),
      permanent: true,
    );

    Get.find<DeepLinkService>();

    Get.put<ClickupController>(
      ClickupController(
        Get.find<ClickupApiService>(),
        Get.find<DeepLinkService>(),
      ),
      permanent: true,
    );
  }
}
