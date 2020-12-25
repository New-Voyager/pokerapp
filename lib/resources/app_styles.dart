import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_assets.dart';

class AppStyles {
  static const cardTextStyle = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w700,
    fontFamily: AppAssets.fontFamilyNoticia,
  );
  static const suitTextStyle = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w700,
    fontFamily: AppAssets.fontFamilyNoticia,
  );
  static const gamePlayScreenHeaderTextStyle1 = TextStyle(
    fontSize: 12.0,
    color: Colors.white,
    fontFamily: AppAssets.fontFamilyLato,
  );

  static const footerResultTextStyle1 = TextStyle(
    fontSize: 14.0,
    color: Colors.greenAccent,
    fontFamily: AppAssets.fontFamilyLato,
  );

  static const footerResultTextStyle2 = TextStyle(
    fontSize: 16.0,
    color: Colors.white,
    fontFamily: AppAssets.fontFamilyLato,
  );

  static const footerResultTextStyle3 = TextStyle(
    fontSize: 14.0,
    color: const Color(0xfff2a365),
    fontFamily: AppAssets.fontFamilyLato,
  );

  static const footerResultTextStyle4 = TextStyle(
    fontSize: 14.0,
    color: const Color(0xffCEE5F1),
    fontFamily: AppAssets.fontFamilyLato,
  );

  static const gamePlayScreenHeaderTextStyle2 = TextStyle(
    fontSize: 12.0,
    color: const Color(0xfff2a365),
    fontFamily: AppAssets.fontFamilyLato,
  );

  static const userPopUpMessageTextStyle = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w800,
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

  static const gamePlayScreenPlayerName = TextStyle(
    color: Colors.white,
    fontSize: 9.0,
    fontWeight: FontWeight.w800,
    fontFamily: AppAssets.fontFamilyLato,
  );

  static const gamePlayScreenPlayerChips = TextStyle(
    color: Colors.white,
    fontSize: 12.0,
    fontWeight: FontWeight.w800,
    fontFamily: AppAssets.fontFamilyLato,
  );

  static const dealerTextStyle = TextStyle(
    color: Colors.black,
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

  static const openSeatTextStyle = TextStyle(
    color: Color(0xff319ffe),
    fontSize: 10.0,
    fontWeight: FontWeight.w800,
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
