import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_assets.dart';

class AppStyles {
  static const cardTextStyle = TextStyle(
    fontSize: 1.0,
    fontWeight: FontWeight.w900,
    fontFamily: AppAssets.fontFamilyLato,
  );

  static const itemInfoTextStyle = TextStyle(
    color: Color(0xff848484),
    fontSize: 12.0,
    fontFamily: AppAssets.fontFamilyLato,
  );

  static const itemInfoTextStyleHeavy = TextStyle(
    color: Colors.white,
    fontSize: 12.0,
    fontWeight: FontWeight.w800,
    fontFamily: AppAssets.fontFamilyLato,
  );

  static const itemInfoSecondaryTextStyle = TextStyle(
    color: Color(0xff848484),
    fontSize: 16.0,
    fontFamily: AppAssets.fontFamilyLato,
  );

  // club item info text styles
  static const clubItemInfoTextStyle = TextStyle(
    color: Color(0xff319ffe),
    fontSize: 12.0,
    fontFamily: AppAssets.fontFamilyLato,
  );

  static const List<BoxShadow> cardBoxShadow = [
    BoxShadow(
      color: Colors.black,
      blurRadius: 6.0,
    ),
  ];

  static const List<BoxShadow> cardBoxShadowMedium = [
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 6.0,
    ),
  ];

  // login screen
  static const TextStyle welcomeTextStyle = TextStyle(
    fontFamily: AppAssets.fontFamilyLato,
    color: Colors.white,
    fontSize: 48.0,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle credentialsTextStyle = TextStyle(
    fontFamily: 'Lato',
    color: Colors.white,
    fontSize: 18.0,
    fontWeight: FontWeight.w400,
  );
}
