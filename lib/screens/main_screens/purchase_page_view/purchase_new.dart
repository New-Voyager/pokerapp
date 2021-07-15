import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/widgets/round_color_button.dart';

class PurchasePageNew extends StatefulWidget {
  const PurchasePageNew({Key key}) : super(key: key);

  @override
  _PurchasePageNewState createState() => _PurchasePageNewState();
}

class _PurchasePageNewState extends State<PurchasePageNew> {
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
    log("Discount : $discountPer");
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
