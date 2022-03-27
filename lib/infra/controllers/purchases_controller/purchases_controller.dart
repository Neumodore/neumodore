import 'package:get/get.dart';

import 'package:neumodore/infra/services/iap_service.dart';

class SkuDetails {
  String title;
}

class DigitalProduct {
  String description, title, price;
  SkuDetails skuDetail;
}

class PurchasesController extends GetxController {
  IAPService iapService;

  List<DigitalProduct> products = [];

  PurchasesController(this.iapService);

  @override
  void onInit() async {
    this.products = [];
    update();

    super.onInit();
  }
}
