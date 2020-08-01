import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_assets.dart';

class AppStyles {
  // game item info text styles
  static const gameItemInfoTextStyle = TextStyle(
    color: Color(0xff848484),
    fontSize: 12.0,
    fontFamily: AppAssets.fontFamilyLato,
  );

  // main screen styles
  static const double cardRadius = 10.0;

  static const List<BoxShadow> cardBoxShadow = [
    BoxShadow(
      color: Colors.black,
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
