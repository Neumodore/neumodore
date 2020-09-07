import 'package:get/get.dart';
import 'package:neumodore/infra/controllers/purchases_controller/purchases_controller.dart';
import 'package:neumodore/infra/services/in_app_purchase_service.dart';

class PurchasesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IAPService>(
      () => IAPService(),
    );

    Get.lazyPut<PurchasesController>(
      () => PurchasesController(
        Get.find<IAPService>(),
      ),
    );
  }
}
