import 'package:flutter/material.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class AppNameAndLogoWidget extends StatelessWidget {
  const AppNameAndLogoWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Text(
            "Poker Club App",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColorsNew.yellowAccentColor,
              fontSize: 16.dp,
            ),
          ),
        ),
        Text(
          "Play poker with friends",
          textAlign: TextAlign.center,
          style: AppStylesNew.labelTextStyle,
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          child: Image.asset(
            AppAssetsNew.pathGameTypeChipImage,
            height: 100.ph,
            width: 100.pw,
          ),
        ),
      ],
    );
  }
}
