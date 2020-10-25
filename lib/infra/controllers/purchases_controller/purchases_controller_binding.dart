import 'package:get/get.dart';
import 'package:neumodore/infra/controllers/purchases_controller/purchases_controller.dart';
import 'package:neumodore/infra/services/iap_service.dart';

class PurchasesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PurchasesController>(
      () => PurchasesController(
        Get.find<IAPService>(),
      ),
    );
  }
}
