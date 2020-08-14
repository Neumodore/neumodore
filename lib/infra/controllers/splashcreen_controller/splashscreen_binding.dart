import 'package:get/get.dart';
import 'package:neumodore/infra/controllers/splashcreen_controller/splashscreen_controller.dart';
import 'package:neumodore/infra/repositories/app_repository.dart';

class SplashScreenBinding extends Bindings {
  @override
  void dependencies() async {
    Get.put<SplashScreenController>(
      SplashScreenController(Get.find<AppStateRepository>()),
    );
  }
}
