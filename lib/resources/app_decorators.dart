import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class AppDecorators {
  AppDecorators._();
  static BoxDecoration bgImage(AppTheme theme) => BoxDecoration(
        color: Colors.black,
        image: DecorationImage(
          image: AssetImage(
            "assets/images/backgrounds/bg5.jpg",
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2), BlendMode.dstATop),
        ),
      );

// gradients
  static BoxDecoration bgRadialGradient(AppTheme theme) => BoxDecoration(
        gradient: RadialGradient(
          colors: [
            theme.primaryColor,
            theme.primaryColorWithDark(),
          ],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
      );

  static BoxDecoration accentNoBorderDecoration(AppTheme theme) =>
      BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(8),
      );

  static BoxDecoration accentBorderDecoration1(AppTheme theme) => BoxDecoration(
        border: Border.all(color: theme.accentColor, width: 3),
        borderRadius: BorderRadius.circular(8),
        color: theme.accentColorWithDark(0.20),
      );

  static BoxDecoration accentBorderDecoration(AppTheme theme) => BoxDecoration(
        border: Border.all(color: theme.accentColor, width: 3),
        borderRadius: BorderRadius.circular(8),
        color: Colors.transparent,
      );

  static BoxDecoration tileDecoration(AppTheme theme) => BoxDecoration(
        border: Border.all(color: theme.accentColor, width: 1),
        color: theme.fillInColor,
        borderRadius: BorderRadius.circular(8),
      );

  static BoxDecoration tileDecorationWithoutBorder(AppTheme theme) =>
      BoxDecoration(
        color: theme.fillInColor,
        borderRadius: BorderRadius.circular(8),
      );
  static getBorderStyle({
    Color color = Colors.black,
    double radius = 10.0,
  }) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(
          color: color,
        ),
      );

  static TextStyle getHeadLine1Style({@required AppTheme theme}) {
    return TextStyle(
      color: theme.supportingColor,
      fontSize: 24.dp,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle getHeadLine2Style({@required AppTheme theme}) {
    return TextStyle(
      color: theme.supportingColor,
      fontSize: 18.dp,
      fontWeight: FontWeight.w700,
      fontFamily: theme.fontFamily,
    );
  }

  static TextStyle getAppBarStyle({@required AppTheme theme}) {
    return TextStyle(
      color: theme.accentColor,
      fontSize: 14.dp,
      fontWeight: FontWeight.w700,
      fontFamily: theme.fontFamily,
    );
  }

  static TextStyle getHeadLine3Style({@required AppTheme theme}) {
    return TextStyle(
      color: theme.supportingColor,
      fontSize: 14.dp,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle getHeadLine4Style({@required AppTheme theme}) {
    return TextStyle(
      color: theme.supportingColor,
      fontSize: 12.dp,
    );
  }

  static TextStyle getHeadLine5Style({@required AppTheme theme}) {
    return TextStyle(
      color: theme.supportingColor,
      fontSize: 9.dp,
    );
  }

  static TextStyle getHeadLine6Style({@required AppTheme theme}) {
    return TextStyle(
      color: theme.supportingColor,
      fontSize: 8.dp,
    );
  }

  static TextStyle getAccentTextStyle({@required AppTheme theme}) {
    return TextStyle(
      color: theme.accentColor,
      fontSize: 12.dp,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle getSubtitleStyle({@required AppTheme theme}) {
    return TextStyle(
      color: theme.supportingColorWithLight(),
      fontSize: 12.dp,
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle getSubtitle1Style({@required AppTheme theme}) {
    return TextStyle(
      color: theme.supportingColorWithLight(),
      fontSize: 10.dp,
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle getSubtitle2Style({@required AppTheme theme}) {
    return TextStyle(
      color: theme.secondaryColor,
      fontSize: 10.dp,
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle getSubtitle3Style({@required AppTheme theme}) {
    return TextStyle(
      color: theme.secondaryColorWithLight(),
      fontSize: 8.dp,
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle getSubtitle4Style({@required AppTheme theme}) {
    return TextStyle(
      color: theme.secondaryColorWithLight(),
      fontSize: 7.dp,
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle getNameplateStyle({@required AppTheme theme}) {
    return TextStyle(
      color: theme.supportingColor,
      fontSize: 10.dp,
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle getCenterTextTextstyle({@required AppTheme appTheme}) {
    return TextStyle(
        fontSize: 18.dp,
        color: appTheme.supportingColor,
        fontFamily: AppAssetsNew.fontFamilyRockwell,
        fontWeight: FontWeight.w700,
        shadows: [
          BoxShadow(
              color: appTheme.secondaryColor,
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(0, 3)),
        ]);
  }

  // static TextStyle getLabelTextStyle({@required AppTheme theme}) {
  //   return TextStyle(
  //     color: theme.secondaryColor.withAlpha(100),
  //     fontSize: 10.dp,
  //     fontWeight: FontWeight.w300,
  //   );
  // }

  static BoxDecoration getGameItemDecoration({@required AppTheme theme}) {
    return BoxDecoration(
      border: Border.all(
        color: theme.secondaryColorWithDark(0.3),
        width: 2.pw,
      ),
      borderRadius: BorderRadius.circular(
        8.pw,
      ),
      color: theme.secondaryColorWithDark(0.4),
      // image: DecorationImage(
      //   image: AssetImage(
      //     AppAssetsNew.pathLiveGameItemBackground,
      //   ),
      //   fit: BoxFit.fitWidth,
      // ),
    );
  }

  static BoxDecoration getChatMyMessageDecoration(AppTheme theme) {
    return BoxDecoration(
      color: theme.fillInColorWithLight(0.18),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
        bottomLeft: Radius.circular(16),
      ),
    );
  }

  static BoxDecoration getChatOtherMessageDecoration(AppTheme theme) {
    return BoxDecoration(
      color: theme.fillInColorWithLight(0.05),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
    );
  }

  static BoxDecoration getCurvedRadialGradient(AppTheme theme) => BoxDecoration(
        gradient: RadialGradient(
          colors: [
            theme.primaryColor,
            theme.primaryColorWithDark(),
          ],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.secondaryColor,
            offset: Offset(1, 1),
            blurRadius: 1,
            spreadRadius: 1,
          )
        ],
      );

  static getLabelTextStyle(AppTheme theme) {
    return TextStyle(
      color: theme.greyColor,
      fontSize: 10.dp,
      fontWeight: FontWeight.w300,
    );
  }
}
