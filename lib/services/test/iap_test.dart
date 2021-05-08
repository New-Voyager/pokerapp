import 'dart:async';
import 'dart:developer';

import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPurchaseTest {
  static bool _kAutoConsume = true;

  static String _kConsumableId = 'chips';
  static String _kUpgradeId = 'upgrade';
  static String _kSilverSubscriptionId = 'subscription_silver';
  static String _kGoldSubscriptionId = 'subscription_gold';
  static List<String> _kProductIds = <String>[_kConsumableId];

  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  List<String> _consumables = [];

  void loadProducts() async {
    log('Loading IAP products');
    final bool isAvailable = await _connection.isAvailable();
    log("isConnectionAvailable = $isAvailable");

    ProductDetailsResponse productDetailResponse =
        await _connection.queryProductDetails(_kProductIds.toSet());
    log("productDetailResponse.productDetails = ${productDetailResponse.productDetails}");
    log("productDetailResponse.notFoundIDs = ${productDetailResponse.notFoundIDs}");
  }
}
