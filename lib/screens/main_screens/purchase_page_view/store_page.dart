import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import 'package:pokerapp/models/app_coin.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_config.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/services/app/appcoin_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:pokerapp/widgets/cross_fade.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:pokerapp/widgets/heading_widget.dart';
import 'package:pokerapp/widgets/round_color_button.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

import 'coin_update.dart';

const bool _kAutoConsume = true;
const String _kConsumableId = 'chips';

class StorePage extends StatefulWidget {
  const StorePage({Key key}) : super(key: key);

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  /// The In App Purchase plugin
  final InAppPurchase _connection = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = [];
  List<IapAppCoinProduct> _enabledProducts = [];
  List<ProductDetails> _iapProducts = [];
  List<PurchaseDetails> _purchases = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String _queryProductError;
  // bool _updateCoins = false;
  int _coinsFrom = 0;
  int _coinsTo = 0;
  AppTextScreen _appScreenText;
  final ValueNotifier<bool> _updateCoinState = ValueNotifier<bool>(false);
  @override
  void initState() {
    _appScreenText = getAppTextScreen("storePage");

    final Stream<List<PurchaseDetails>> purchaseUpdated =
        InAppPurchase.instance.purchaseStream;
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
    String projectAppID;
    String appVersion;
    String platformVersion;
    // try {
    //   projectAppID = await GetVersion.appID;
    //   appVersion = await GetVersion.projectVersion;
    //   platformVersion = await GetVersion.platformVersion;
    // } catch (e) {
    //   projectAppID = 'Failed to get app ID.';
    // }
    log('Project App ID: $projectAppID appVersion: $appVersion platformVersion: $platformVersion');

    _enabledProducts = await AppCoinService.availableProducts();
    final bool isAvailable = await _connection.isAvailable();
    log("isConnectionAvailable = $isAvailable");
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _iapProducts = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    // get product ids from the server
    List<String> productIds = _enabledProducts.map((e) => e.productId).toList();

    ProductDetailsResponse productDetailResponse =
        await _connection.queryProductDetails(productIds.toSet());
    log("productDetailResponse.productDetails = ${productDetailResponse.productDetails}");
    log("productDetailResponse.notFoundIDs = ${productDetailResponse.notFoundIDs}");

    if (productDetailResponse.error != null) {
      log("productDetailResponse.error.message = ${productDetailResponse.error.message}");
      log("productDetailResponse.error.details = ${productDetailResponse.error.details}");
      setState(() {
        _queryProductError = productDetailResponse.error.message;
        _isAvailable = isAvailable;
        _iapProducts = [];
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _iapProducts = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    // final QueryPurchaseDetailsResponse purchaseResponse =
    //     await _connection.
    // if (purchaseResponse.error != null) {
    //   // handle query past purchase error..
    // }
    // final List<PurchaseDetails> verifiedPurchases = [];
    // for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
    //   if (await _verifyPurchase(purchase)) {
    //     verifiedPurchases.add(purchase);
    //   }
    // }
    setState(() {
      _isAvailable = isAvailable;
      _iapProducts = productDetailResponse.productDetails;
      //_purchases = verifiedPurchases;
      _notFoundIds = productDetailResponse.notFoundIDs;
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
    final theme = AppTheme.getTheme(context);
    List<Widget> body = [];
    if (!_loading) {
      _enabledProducts.sort((a, b) => a.coins.compareTo(b.coins));
      for (final enabledProduct in _enabledProducts) {
        final productId = enabledProduct.productId;
        bool found = false;
        // locate the id in the product list to get number of coins
        final noCoins = enabledProduct.productId;
        ProductDetails iapProductFound;
        for (final iapProduct in _iapProducts) {
          if (iapProduct.id == productId) {
            found = true;
            iapProductFound = iapProduct;
            break;
          }
        }
        if (!found) {
          continue;
        }

        body.add(
          PurchaseItem(
            mrpPrice: iapProductFound.rawPrice,
            offerPrice: iapProductFound.rawPrice,
            noOfCoins: enabledProduct.coins,
            onBuy: () async {
              log('Purchasing $productId no of coins: ${enabledProduct.coins}');
              await handlePurchase(iapProductFound);
            },
            appScreenText: _appScreenText,
          ),
        );
      }
    }

    return Container(
      decoration: AppDecorators.bgRadialGradient(theme),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: _loading
              ? CircularProgressWidget(text: _appScreenText['loadingProducts'])
              : Column(
                  children: [
                    // header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Stack(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        alignment: Alignment.center,
                        children: [
                          // Row(
                          //   children: [
                          //     //BackArrowWidget(),
                          //     AppDimensionsNew.getHorizontalSpace(16),
                          //     Text(
                          //       "App Coins",
                          //       style: AppStylesNew.appBarTitleTextStyle,
                          //     ),
                          //   ],
                          // ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: RoundRectButton(
                                text: "Redeem",
                                onTap: () {
                                  _handleRedeem(theme, context);
                                },
                                theme: theme),
                          ),

                          // AppDimensionsNew.getHorizontalSpace(24.pw),
                          HeadingWidget(heading: _appScreenText['store']),

                          Align(
                            alignment: Alignment.centerRight,
                            child: ValueListenableBuilder<bool>(
                              builder: (
                                BuildContext context,
                                bool updateCoins,
                                Widget child,
                              ) {
                                // This builder will only get called when the _counter
                                // is updated.
                                return CoinWidget(
                                  AppConfig.availableCoins,
                                  // _coinsTo - _coinsFrom,
                                  10,
                                  updateCoins,
                                );
                              },
                              valueListenable: _updateCoinState,
                            ),
                          )
                        ],
                      ),
                    ),

                    Expanded(
                      child: Column(children: body),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  _handleRedeem(AppTheme theme, BuildContext context) async {
    final TextEditingController controller = TextEditingController();
    final result = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: EdgeInsets.zero,
        backgroundColor: theme.fillInColor,
        title: Text("Promotion Code"),
        content: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CardFormTextField(
                theme: theme,
                controller: controller,
                hintText: "Enter code",
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RoundRectButton(
                  text: "Ok",
                  onTap: () =>
                      Navigator.of(context).pop(controller.text.toString()),
                  theme: theme,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (result != null && controller.text.toString().isNotEmpty) {
      // redeem coins
      try {
        String code = controller.text.toString().trim();
        code = code.toUpperCase();
        _coinsFrom = AppConfig.availableCoins;

        final result = await AppCoinService.redeemCode(code);
        if (result.error != null) {
          /*
          PROMOTION_EXPIRED = 'PROMOTION_EXPIRED',
          PROMOTION_INVALID = 'PROMOTION_INVALID',
          PROMOTION_CONSUMED = 'PROMOTION_CONSUMED',
          PROMOTION_MAX_LIMIT_REACHED = 'PROMOTION_MAX_LIMIT_REACHED',
          PROMOTION_UNAUTHORIZED = 'PROMOTION_UNAUTHORIZED',
          */
          String error;
          if (result.error == 'PROMOTION_EXPIRED') {
            error = 'Promotion is expired';
          } else if (result.error == 'PROMOTION_INVALID') {
            error = 'Invalid promotion code';
          } else if (result.error == 'PROMOTION_CONSUMED') {
            error = 'Promotion is already used';
          } else if (result.error == 'PROMOTION_MAX_LIMIT_REACHED') {
            error = 'Promotion limit has been reached';
          } else if (result.error == 'PROMOTION_UNAUTHORIZED') {
            error = 'Unauthorized promotion code';
          }
          showErrorDialog(context, 'Error', error);
        } else {
          final availableCoins = await AppCoinService.availableCoins();
          // int availableAppCoins = AppConfig.availableCoins;
          AppConfig.setAvailableCoins(availableCoins);
          _coinsTo = AppConfig.availableCoins;
          debugPrint('Available coins ${AppConfig.availableCoins}');
          _updateCoinState.value = true;
          // setState(() {}); // we dont need to call setstate, as ValueListenableBuilder is triggered
          await Future.delayed(Duration(seconds: 1), () {
            _updateCoinState.value = false;
            // setState(() {}); we dont need to call setstate, as ValueListenableBuilder is triggered
          });
          // Alerts.showNotification(titleText: "Available coins ${result.availableCoins}");
        }
      } catch (err) {
        await showErrorDialog(context, 'Error', 'Failed to redeem code');
      }

      ///TODO
    }
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

  Future<void> handlePurchase(ProductDetails productDetails) async {
    PurchaseParam purchaseParam = PurchaseParam(
        productDetails: productDetails, applicationUserName: null);
    try {
      bool purchased = await _connection.buyConsumable(
          purchaseParam: purchaseParam,
          autoConsume: _kAutoConsume || Platform.isIOS);
    } catch (err) {
      log('Purchased ${productDetails.id}');
    }
  }

  // void onUpdateComplete() {
  //   _updateCoins = false;
  //   setState(() {});
  // }

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
      if (Platform.isAndroid) {
        sourceType = 'GOOGLE_PLAY_STORE';
        receipt = purchaseDetails.verificationData.localVerificationData;
      } else if (Platform.isIOS) {
        sourceType = 'IOS_APP_STORE';
        receipt = purchaseDetails.verificationData.serverVerificationData;
      }
      _coinsFrom = AppConfig.availableCoins;

      final product = _enabledProducts
          .firstWhere((e) => e.productId == purchaseDetails.productID);
      int coinsPurchased = 0;
      if (product != null) {
        coinsPurchased = product.coins;
      }
      bool ret = await AppCoinService.purchaseProduct(
          sourceType, coinsPurchased, receipt);
      debugPrint('purchase product returned $ret');
      if (ret) {
        final availableCoins = await AppCoinService.availableCoins();
        AppConfig.setAvailableCoins(availableCoins);
        _coinsTo = AppConfig.availableCoins;
        debugPrint('Available coins $availableCoins');

        // _updateCoins = true;
        _updateCoinState.value = true;
        // setState(() {});
        await Future.delayed(Duration(seconds: 1), () {
          // _updateCoins = false;
          _updateCoinState.value = false;
          // setState(() {});
        });

        // _updateCoins = true;
        // setState(() {});
      }
    } catch (err) {
      debugPrint(err.toString());
    }
    return Future<bool>.value(true);
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {}

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
            final data = jsonEncode(purchaseDetails);
            debugPrint(data);
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
          if (Platform.isAndroid) {
            if (!_kAutoConsume && purchaseDetails.productID == _kConsumableId) {
              final InAppPurchaseAndroidPlatformAddition androidAddition =
                  _connection.getPlatformAddition<
                      InAppPurchaseAndroidPlatformAddition>();
              await androidAddition.consumePurchase(purchaseDetails);
            }
          }
          if (purchaseDetails.pendingCompletePurchase) {
            await _connection.completePurchase(purchaseDetails);
          }
        }
      }
    });
  }
}

class PurchaseItem extends StatelessWidget {
  final int noOfCoins;
  final double mrpPrice;
  final double offerPrice;
  final Function onBuy;
  final AppTextScreen appScreenText;

  const PurchaseItem({
    Key key,
    this.noOfCoins,
    this.mrpPrice,
    this.offerPrice,
    this.onBuy,
    @required this.appScreenText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
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
      decoration: AppDecorators.tileDecoration(theme),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          "$noOfCoins ${appScreenText['coins']}",
          style: AppDecorators.getHeadLine4Style(theme: theme),
        ),
        leading: Image.asset(
          'assets/images/appcoins.png',
          height: 32.pw,
          width: 32.pw,
        ),
        subtitle: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: "\$${mrpPrice.toStringAsFixed(2)}",
                  style: showDiscount
                      ? AppDecorators.getAccentTextStyle(theme: theme).copyWith(
                          decoration: TextDecoration.lineThrough,
                        )
                      : AppDecorators.getAccentTextStyle(theme: theme)),
              TextSpan(
                text: showDiscount ? "\t\$$offerPrice" : "",
                style: AppDecorators.getSubtitle3Style(theme: theme),
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
        trailing: RoundRectButton(
          text: appScreenText['buy'],
          onTap: onBuy,
          theme: theme,
        ),
      ),
    );
  }
}
