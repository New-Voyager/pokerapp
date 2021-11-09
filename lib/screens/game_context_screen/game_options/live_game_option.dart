import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';

class LiveGameOption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return liveGameItem();
      },
    );
  }

  liveGameItem() {
    return Container(
      height: 135.0,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: const BoxDecoration(
        color: AppColorsNew.cardBackgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimensions.cardRadius),
        ),
        boxShadow: AppStylesNew.cardBoxShadow,
      ),
      child: Row(
        children: <Widget>[
          /*
          * color
          * */

          Container(
            width: 50,
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: ([
                Color(0xffef9712),
                Color(0xff12efc2),
                Color(0xffef1229),
              ]..shuffle())
                  .first,
              shape: BoxShape.circle,
            ),
          ),

          /*
          * main content
          * */

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Spacer(),
                  Text(
                    "PLO 1/2 Buy",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19.0,
                      fontFamily: AppAssets.fontFamilyLato,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Hosted by Club Boston",
                    style: AppStylesNew.hostInfoTextStyle,
                  ),
                  Spacer(),
                  Spacer(),
                  Text(
                    "PLO 1/2 Buy",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19.0,
                      fontFamily: AppAssets.fontFamilyLato,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Hosted by Club Boston",
                    style: AppStylesNew.hostInfoTextStyle,
                  ),
                  Spacer(),
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
              color: AppColorsNew.cardBackgroundColor,
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(AppDimensions.cardRadius),
              ),
              boxShadow: AppStylesNew.cardBoxShadowMedium,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getButton(
                  title: 'Join Waitlist',
                  onTap: () {},
                ),
                SizedBox(
                  height: 20,
                ),
                getButton(
                  title: 'Watch',
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
          fontSize: 20.0,
          color: AppColorsNew.appAccentColor,
        ),
      ),
    );
  }
}
