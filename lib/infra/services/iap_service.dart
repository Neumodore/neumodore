import 'dart:async';
import 'dart:io';

class IAPService {
  final Set<String> _kIds = {
    'donate_cookie',
    'donate_mcchicken',
    'donate_gourmet_coffee'
  };

  StreamSubscription<List<String>> _subscription;

  bool get iapAvailable => false;

  IAPService() {
    // Inform the plugin that this app supports pending purchases on Android.
    // An error will occur on Android if you access the plugin `instance`
    // without this call.
    //
    // On iOS this is a no-op.

    void _handlePurchaseUpdates(purchases) {}

    loadPurchases();
  }

  void loadPurchases() async {}

  Future<List<String>> listProducts() async {
    return [];
  }

  void dispose() {
    _subscription.cancel();
  }

  void _deliverPurchase(purchase) {}

  void _verifyPurchase(purchase) {}

  void makePurchase() async {}

  bool _isConsumable(productDetails) {}

  void buyProduct(product) {}
}
