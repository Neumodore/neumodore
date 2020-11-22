import 'package:get/get.dart';
import 'package:neumodore/app/features/splashscreen/splashscreen_controller.dart';
import 'package:neumodore/infra/repositories/theme/itheme_repository.dart';
import 'package:neumodore/infra/services/deep_links.dart';
import 'package:neumodore/infra/services/phrase_service.dart';

class SplashScreenBinding extends Bindings {
  @override
  void dependencies() async {
    Get.put<PhraseService>(PhraseService());

    Get.put<SplashScreenController>(
      SplashScreenController(
        Get.find<IThemeRepository>(),
        Get.find<PhraseService>(),
        Get.find<DeepLinkService>(),
      ),
    );
  }
}
