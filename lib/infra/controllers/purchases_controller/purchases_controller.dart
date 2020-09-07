import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:neumodore/infra/services/in_app_purchase_service.dart';

class PurchasesController extends GetxController {
  IAPService iapService;

  List<ProductDetails> products = List<ProductDetails>();

  PurchasesController(this.iapService) {
    this.iapService.listProducts().then((value) {
      this.products = value;
      update();
    });
  }
}
