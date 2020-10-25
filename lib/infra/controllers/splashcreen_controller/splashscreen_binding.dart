import 'package:get/get.dart';
import 'package:neumodore/infra/controllers/splashcreen_controller/splashscreen_controller.dart';
import 'package:neumodore/infra/repositories/theme/itheme_repository.dart';
import 'package:neumodore/infra/services/phrase_service.dart';

class SplashScreenBinding extends Bindings {
  @override
  void dependencies() async {
    Get.put<PhraseService>(PhraseService());

    Get.put<SplashScreenController>(
      SplashScreenController(
        Get.find<IThemeRepository>(),
        Get.find<PhraseService>(),
      ),
    );
  }
}
