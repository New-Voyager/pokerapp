import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class AppDecorators {
  AppDecorators._();

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

  static TextStyle getAccentTextStyle({@required AppTheme theme}) {
    return TextStyle(
      color: theme.accentColor,
      fontSize: 12.dp,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle getSubtitle1Style({@required AppTheme theme}) {
    return TextStyle(
      color: theme.supportingColorWithLight(),
      fontSize: 8.dp,
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
      color: theme.secondaryColorWithDark(),
      fontSize: 8.dp,
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

  static TextStyle getLabelTextStyle({AppTheme theme}) {
    return TextStyle(
      color: theme.secondaryColor.withAlpha(100),
      fontSize: 10.dp,
      fontWeight: FontWeight.w300,
    );
  }

  static BoxDecoration getGameItemDecoration({AppTheme theme}) {
    return BoxDecoration(
      border: Border.all(
        color: theme.secondaryColorWithDark(0.3),
        width: 2.pw,
      ),
      borderRadius: BorderRadius.circular(
        8.pw,
      ),
      color: theme.primaryColorWithDark(),
      image: DecorationImage(
        image: AssetImage(
          AppAssetsNew.pathLiveGameItemBackground,
        ),
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
