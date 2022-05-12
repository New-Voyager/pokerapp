import 'dart:async';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:pokerapp/main.dart';

import 'package:pokerapp/models/app_coin.dart';
import 'package:pokerapp/models/app_state.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_config.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/main_screens/purchase_page_view/diamonds_widget.dart';
import 'package:pokerapp/services/app/appcoin_service.dart';
import 'package:pokerapp/utils/platform.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/services/data/hive_models/player_state.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/widgets/round_color_button.dart';
import 'package:pokerapp/widgets/textfields.dart';
import 'package:pokerapp/widgets/texts.dart';

import 'coin_update.dart';

const bool _kAutoConsume = true;
const String _kConsumableId = 'chips';

class StoreDialog extends StatefulWidget {
  final AppTheme theme;
  StoreDialog({Key key, this.theme}) : super(key: key);

  @override
  State<StoreDialog> createState() => _StoreDialogState();

  static void show(BuildContext context, AppTheme theme) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => StoreDialog(theme: theme),
    );
  }
}

class _StoreDialogState extends State<StoreDialog> {
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
  int _addedCoins = 0;
  int _addedDiamonds = 0;

  AppTextScreen _appScreenText;
  final ValueNotifier<bool> _updateCoinState = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _updateDiamondState = ValueNotifier<bool>(false);

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

    _enabledProducts = appState.enabledProducts;
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

  refreshCoinCount() async {
    AppConfig.setAvailableCoins(await AppCoinService.availableCoins());
    log("Appcoins refreshed : ${AppConfig.availableCoins}");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    var format = NumberFormat.simpleCurrency(locale: locale.toString());

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
            currencySymbol: format.currencySymbol,
            mrpPrice: iapProductFound.rawPrice,
            offerPrice: iapProductFound.rawPrice,
            noOfCoins: enabledProduct.coins.toString(),
            onBuy: () async {
              log('Purchasing $productId no of coins: ${enabledProduct.coins}');
              await handlePurchase(iapProductFound);
            },
            appScreenText: _appScreenText,
          ),
        );
      }
    }

    body.add(DiamondItem(
      noOfDiamonds: 100,
      noOfCoins: 10,
      appScreenText: _appScreenText,
      onBuy: () async {
        try {
          int diamonds = 100;
          final ret = await AppCoinService.buyDiamonds(diamonds, 10);
          if (!ret) {
            await showErrorDialog(
                context, 'Error', 'Buying diamonds failed. Retry again later');
          } else {
            final coins = await AppCoinService.availableCoins();
            playerState.addDiamonds(diamonds);
            AppConfig.setAvailableCoins(coins);
            _addedDiamonds = diamonds;
            _addedCoins = -10;
            await showErrorDialog(context, 'Diamonds',
                'Buying diamonds successful. Available diamonds: ${playerState.diamonds}',
                info: true);
            _updateCoinState.value = true;
            _updateDiamondState.value = true;
            await Future.delayed(Duration(seconds: 1), () {
              _addedCoins = 0;
              _addedDiamonds = 0;
              _updateCoinState.value = false;
              _updateDiamondState.value = false;
            });

            //setState(() {});
          }
        } catch (err) {
          showErrorDialog(
              context, 'Error', 'Buying diamonds failed. Retry again later');
        }
      },
    ));

    return Center(
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height * 0.5,
                decoration:
                    AppDecorators.bgRadialGradient(widget.theme).copyWith(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: widget.theme.accentColor, width: 3),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: _loading
                      ? CircularProgressWidget(
                          text: _appScreenText['loadingProducts'])
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Stack(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                alignment: Alignment.center,
                                children: [
                                  Visibility(
                                    visible: false,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: RoundRectButton(
                                          text: "Redeem",
                                          onTap: () {
                                            _handleRedeem(theme, context);
                                          },
                                          theme: theme),
                                    ),
                                  ),

                                  // AppDimensionsNew.getHorizontalSpace(24.pw),
                                  HeadingWidget(
                                      heading: _appScreenText['store']),

                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ValueListenableBuilder<bool>(
                                          builder: (
                                            BuildContext context,
                                            bool update,
                                            Widget child,
                                          ) {
                                            // This builder will only get called when the _counter
                                            // is updated.
                                            return CoinWidget(
                                              AppConfig.availableCoins,
                                              _addedCoins,
                                              update,
                                            );
                                          },
                                          valueListenable: _updateCoinState,
                                        ),
                                        SizedBox(width: 15.dp),
                                        ValueListenableBuilder<bool>(
                                          builder: (
                                            BuildContext context,
                                            bool update,
                                            Widget child,
                                          ) {
                                            // This builder will only get called when the _counter
                                            // is updated.
                                            return DiamondWidget(
                                              playerState.diamonds,
                                              _addedDiamonds,
                                              update,
                                            );
                                          },
                                          valueListenable: _updateDiamondState,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                                mainAxisSize: MainAxisSize.min, children: body),
                          ],
                        ),
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            child: Material(
              color: Colors.transparent,
              child: RoundedIconButton2(
                onTap: () {
                  Navigator.pop(context);
                },
                icon: Icons.close,
              ),
            ),
          ),
        ],
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
        int coinsFrom = AppConfig.availableCoins;

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
          AppConfig.setAvailableCoins(availableCoins);
          int coinsTo = AppConfig.availableCoins;
          _addedCoins = coinsTo - coinsFrom;
          debugPrint('Available coins ${AppConfig.availableCoins}');
          _updateCoinState.value = true;
          await Future.delayed(Duration(seconds: 1), () {
            _addedCoins = 0;
            _updateCoinState.value = false;
          });
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
          autoConsume: _kAutoConsume || PlatformUtils.isIOS);
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
      ConnectionDialog.show(context: context, loadingText: 'Updating coins...');
      /*
        UNKNOWN
        IOS_APP_STORE
        GOOGLE_PLAY_STORE
        STRIPE_PAYMENT      
      */
      String sourceType = 'UNKNOWN';
      String receipt = '';
      if (PlatformUtils.isAndroid) {
        sourceType = 'GOOGLE_PLAY_STORE';
        receipt = purchaseDetails.verificationData.localVerificationData;
      } else if (PlatformUtils.isIOS) {
        sourceType = 'IOS_APP_STORE';
        receipt = purchaseDetails.verificationData.serverVerificationData;
      }

      final product = _enabledProducts
          .firstWhere((e) => e.productId == purchaseDetails.productID);
      int coinsPurchased = 0;
      if (product != null) {
        coinsPurchased = product.coins;
      }
      bool ret = await AppCoinService.purchaseProduct(
          sourceType, coinsPurchased, receipt);
      ConnectionDialog.dismiss(context: context);
      debugPrint('purchase product returned $ret');
      if (ret) {
        final availableCoins = await AppCoinService.availableCoins();
        AppConfig.setAvailableCoins(availableCoins);
        debugPrint('Available coins $availableCoins');

        _addedCoins = coinsPurchased;
        _updateCoinState.value = true;
        await Future.delayed(Duration(seconds: 1), () {
          _updateCoinState.value = false;
        });
      }
    } catch (err) {
      ConnectionDialog.dismiss(context: context);
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
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
          if (PlatformUtils.isAndroid) {
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
  final String noOfCoins;
  final double mrpPrice;
  final double offerPrice;
  final Function onBuy;
  final AppTextScreen appScreenText;
  final String currencySymbol;

  const PurchaseItem({
    Key key,
    this.currencySymbol,
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
                  text: "${this.currencySymbol}${mrpPrice.toStringAsFixed(2)}",
                  style: showDiscount
                      ? AppDecorators.getAccentTextStyle(theme: theme).copyWith(
                          decoration: TextDecoration.lineThrough,
                        )
                      : AppDecorators.getAccentTextStyle(theme: theme)),
              TextSpan(
                text: showDiscount ? "\t$offerPrice" : "",
                style: AppDecorators.getSubtitle3Style(theme: theme),
              ),
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

class DiamondItem extends StatelessWidget {
  final int noOfCoins;
  final int noOfDiamonds;
  final Function onBuy;
  final AppTextScreen appScreenText;

  const DiamondItem({
    Key key,
    this.noOfCoins,
    this.noOfDiamonds,
    this.onBuy,
    @required this.appScreenText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      decoration: AppDecorators.tileDecoration(theme),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          "$noOfDiamonds Diamonds",
          style: AppDecorators.getHeadLine4Style(theme: theme),
        ),
        leading: SvgPicture.asset(
          'assets/images/diamond.svg',
          height: 24.pw,
          width: 24.pw,
          color: Colors.cyan,
        ),
        subtitle: Row(
          children: [
            Text("${noOfCoins} coins",
                style: AppDecorators.getAccentTextStyle(theme: theme)),
            SizedBox(width: 5.dp),
            Image.asset(
              'assets/images/appcoins.png',
              height: 24.pw,
              width: 24.pw,
            ),
          ],
        ),
        trailing: RoundRectButton(
            text: appScreenText['buy'], theme: theme, onTap: onBuy),
      ),
    );
  }
}
