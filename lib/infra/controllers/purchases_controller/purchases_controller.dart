import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:neumodore/infra/services/iap_service.dart';

class PurchasesController extends GetxController {
  IAPService iapService;

  List<ProductDetails> products = [];

  PurchasesController(this.iapService);

  @override
  void onInit() async {
    this.products = await this.iapService.listProducts();

    update();

    super.onInit();
  }
}
