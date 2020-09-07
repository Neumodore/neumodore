import 'dart:async';
import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';

class IAPService {
  StreamSubscription<List<PurchaseDetails>> _subscription;

  InAppPurchaseConnection get _instance => InAppPurchaseConnection.instance;

  Future<bool> get iapAvailable {
    return _instance.isAvailable();
  }

  IAPService() {
    // Inform the plugin that this app supports pending purchases on Android.
    // An error will occur on Android if you access the plugin `instance`
    // without this call.
    //
    // On iOS this is a no-op.
    InAppPurchaseConnection.enablePendingPurchases();

    void _handlePurchaseUpdates(purchases) {}

    final Stream purchaseUpdates =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdates.listen((purchases) {
      _handlePurchaseUpdates(purchases);
    });
    loadPurchases();
  }

  void loadPurchases() async {
    final QueryPurchaseDetailsResponse response =
        await InAppPurchaseConnection.instance.queryPastPurchases();
    if (response.error != null) {
      // Handle the error.
    }
    for (PurchaseDetails purchase in response.pastPurchases) {
      // Verify the purchase following the best practices for each storefront.
      _verifyPurchase(purchase);
      // Deliver the purchase to the user in your app.
      _deliverPurchase(purchase);
      if (Platform.isIOS) {
        // Mark that you've delivered the purchase. Only the App Store requires
        // this final confirmation.
        InAppPurchaseConnection.instance.completePurchase(purchase);
      }
    }
  }

  Future<List<ProductDetails>> listProducts() async {
    if (!await iapAvailable) {
      const Set<String> _kIds = {'product1', 'product2'};
      final ProductDetailsResponse response =
          await InAppPurchaseConnection.instance.queryProductDetails(_kIds);
      if (response.notFoundIDs.isNotEmpty) {
        // Handle the error.
      }
      List<ProductDetails> products = response.productDetails;
      // The store cannot be reached or accessed. Update the UI accordingly.
      return products;
    }
  }

  void dispose() {
    _subscription.cancel();
  }

  void _deliverPurchase(PurchaseDetails purchase) {}

  void _verifyPurchase(PurchaseDetails purchase) {}

  void makePurchase() async {}

  bool _isConsumable(ProductDetails productDetails) {}

  void buyProduct(PurchaseParam product) {
    _instance.buyConsumable(purchaseParam: product);
  }
}
