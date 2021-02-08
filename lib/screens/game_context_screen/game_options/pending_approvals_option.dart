import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_styles.dart';

class PendingApprovalsOption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return liveGameItem();
      },
    );
  }

  liveGameItem() {
    final separator5 = SizedBox(height: 5.0);

    return Container(
      height: 135.0,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: const BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimensions.cardRadius),
        ),
        boxShadow: AppStyles.cardBoxShadow,
      ),
      child: Row(
        children: <Widget>[
          /*
          * color
          * */

          Container(
            width: 14.0,
            height: double.infinity,
            decoration: BoxDecoration(
              color: ([
                Color(0xffef9712),
                Color(0xff12efc2),
                Color(0xffef1229),
              ]..shuffle())
                  .first,
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(AppDimensions.cardRadius),
              ),
            ),
          ),

          /*
          * main content
          * */

          Expanded(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Pauls wants to buy 300 chips",
                    style: AppStyles.itemInfoSecondaryTextStyle,
                  ),
                  separator5,
                  Text(
                    "Game: ABHDJDJPLO 1/2",
                    style: AppStyles.itemInfoSecondaryTextStyle,
                  ),
                  separator5,
                  Text(
                    "Game total buying: 0",
                    style: AppStyles.itemInfoSecondaryTextStyle,
                  ),
                  separator5,
                  Row(
                    children: [
                      Text(
                        "Club balance: ",
                        style: AppStyles.itemInfoSecondaryTextStyle,
                      ),
                      Text(
                        "1000",
                        style: AppStyles.itemInfoSecondaryTextStyle.copyWith(
                            color: AppColors
                                .positiveColor), //AppColors.negativeColor
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          /*
          * action button or status
          * */

          Container(
            width: 120.0,
            decoration: const BoxDecoration(
              color: AppColors.cardBackgroundColor,
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(AppDimensions.cardRadius),
              ),
              boxShadow: AppStyles.cardBoxShadowMedium,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getButton(
                  title: 'Approve',
                  onTap: () {},
                ),
                SizedBox(
                  height: 20,
                ),
                getButton(
                  title: 'Deny',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  getButton({Function onTap, String title}) {
    return InkWell(
      onTap: onTap,
      child: Text(
        title.replaceFirst(" ", "\n"),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: AppAssets.fontFamilyLato,
          fontSize: 22.0,
          color: AppColors.appAccentColor,
        ),
      ),
    );
  }
}
