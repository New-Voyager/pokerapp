import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:pokerapp/consumable_store.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/appcoin_service.dart';
import 'package:pokerapp/widgets/round_color_button.dart';

const bool _kAutoConsume = true;
const String _kConsumableId = 'chips';
const List<String> _kProductIds = <String>[_kConsumableId];

class StorePage extends StatefulWidget {
  const StorePage({Key key}) : super(key: key);

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  /// The In App Purchase plugin
  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  List<String> _consumables = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String _queryProductError;


  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
    initStoreInfo();
    super.initState();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _connection.isAvailable();
    log("isConnectionAvailable = $isAvailable");
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = [];
        _purchases = [];
        _notFoundIds = [];
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    // get product ids from the server

    ProductDetailsResponse productDetailResponse =
        await _connection.queryProductDetails(_kProductIds.toSet());
    log("productDetailResponse.productDetails = ${productDetailResponse.productDetails}");
    log("productDetailResponse.notFoundIDs = ${productDetailResponse.notFoundIDs}");

    if (productDetailResponse.error != null) {
      log("productDetailResponse.error.message = ${productDetailResponse.error.message}");
      log("productDetailResponse.error.details = ${productDetailResponse.error.details}");
      setState(() {
        _queryProductError = productDetailResponse.error.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    final QueryPurchaseDetailsResponse purchaseResponse =
        await _connection.queryPastPurchases();
    if (purchaseResponse.error != null) {
      // handle query past purchase error..
    }
    final List<PurchaseDetails> verifiedPurchases = [];
    for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
      if (await _verifyPurchase(purchase)) {
        verifiedPurchases.add(purchase);
      }
    }
    List<String> consumables = await ConsumableStore.load();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = verifiedPurchases;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = consumables;
      _purchasePending = false;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppStylesNew.BgGreenRadialGradient,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      BackArrowWidget(),
                      AppDimensionsNew.getHorizontalSpace(16),
                      Text(
                        "App Coins",
                        style: AppStylesNew.appBarTitleTextStyle,
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "3399",
                        ),
                        Text(
                          "coins",
                          style: AppStylesNew.labelTextStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              PurchaseItem(
                mrpPrice: 2,
                offerPrice: 0.99,
                noOfCoins: 10,
              ),
              PurchaseItem(
                mrpPrice: 3,
                offerPrice: 1.99,
                noOfCoins: 25,
              ),
              PurchaseItem(
                mrpPrice: 5,
                offerPrice: 3.49,
                noOfCoins: 50,
              ),
              PurchaseItem(
                mrpPrice: 8,
                offerPrice: 5.99,
                noOfCoins: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }
  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }


  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    try {
      /*
        UNKNOWN
        IOS_APP_STORE
        GOOGLE_PLAY_STORE
        STRIPE_PAYMENT      
      */
      String sourceType = 'UNKNOWN';
      String receipt = '';
      if (purchaseDetails.verificationData.source == IAPSource.GooglePlay) {
        sourceType = 'GOOGLE_PLAY_STORE';
        receipt = purchaseDetails.verificationData.localVerificationData;
      } else if (purchaseDetails.verificationData.source ==
          IAPSource.AppStore) {
        sourceType = 'IOS_APP_STORE';
        receipt = purchaseDetails.verificationData.serverVerificationData;
      }
      bool ret = await AppCoinService.purchaseProduct(sourceType, receipt);
      debugPrint('purchase product returned $ret');

      int coins = await AppCoinService.availableCoins();
      debugPrint('Available coins $coins');
    } catch (err) {
      debugPrint(err.toString());
    }
    return Future<bool>.value(true);
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {

  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            //final data = jsonEncode(purchaseDetails);
            //debugPrint(data);
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (Platform.isAndroid) {
          if (!_kAutoConsume && purchaseDetails.productID == _kConsumableId) {
            await InAppPurchaseConnection.instance
                .consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchaseConnection.instance
              .completePurchase(purchaseDetails);
        }
      }
    });
  }  
}

class PurchaseItem extends StatelessWidget {
  final int noOfCoins;
  final double mrpPrice;
  final double offerPrice;
  const PurchaseItem({
    Key key,
    this.noOfCoins,
    this.mrpPrice,
    this.offerPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (mrpPrice <= 0) {
      return Container();
    }
    double discountPer = ((mrpPrice - offerPrice) / (mrpPrice)) * 100;
    //log("Discount : $discountPer");
    bool showDiscount = discountPer.toInt() > 0;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        tileColor: AppColorsNew.actionRowBgColor,
        title: Text("$noOfCoins coins"),
        leading: SvgPicture.asset(
          AppAssetsNew.coinsImagePath,
          height: 32,
          width: 32,
        ),
        subtitle: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: "\$$mrpPrice",
                  style: showDiscount
                      ? AppStylesNew.accentTextStyle.copyWith(
                          decoration: TextDecoration.lineThrough,
                        )
                      : AppStylesNew.accentTextStyle),
              TextSpan(
                text: showDiscount ? "\t\$$offerPrice" : "",
                style: AppStylesNew.stageNameTextStyle,
              ),
              // TextSpan(
              //   text: showDiscount
              //       ? "\t\tSave upto ${discountPer.toStringAsFixed(0)}%"
              //       : "",
              //   style: AppStylesNew.labelTextStyle,
              // ),
            ],
          ),
        ),
        trailing: RoundedColorButton(
          text: AppStringsNew.buyButtonText,
          backgroundColor: AppColorsNew.yellowAccentColor,
          textColor: AppColorsNew.darkGreenShadeColor,
        ),
      ),
    );
  }
}
