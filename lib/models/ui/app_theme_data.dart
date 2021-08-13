import 'package:flutter/material.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';

class AppThemeData {
  // main color that the app is based on
  Color primaryColor;

  // color that is used on buttons or other highlighting places
  Color secondaryColor;

  // accent color that works with the main color in the app
  Color accentColor;

  // color that is used for filling inside text fields, or cards views
  Color fillInColor;

  // supporting color: color that is used to create constrast with main color and accent color
  // mainly used for texts (white, or shades of white)
  Color supportingColor;

  // color used for negatives or errors
  Color negativeOrErrorColor;

  // font family
  String fontFamily;

  // Handlog stage colors
  Color handlogPreflopColor;
  Color handlogFlopColor;
  Color handlogTurnColor;
  Color handlogRiverColor;
  Color handlogShowdownColor;

  AppThemeData({
    this.primaryColor = const Color(0xFF033614), // 0xFF300614
    // Color(0xFF40D876); (darken secondary color)
    this.secondaryColor = const Color(0xFF00FAAD),
    this.accentColor = const Color(0xFFD89E40),
    this.fillInColor = const Color(0xFF0B2324),
    this.supportingColor = Colors.white,
    this.negativeOrErrorColor = const Color(0xFFFA0000),
    this.fontFamily = AppAssetsNew.fontFamilyPoppins,
    this.handlogPreflopColor = const Color(0xFF1A0E2D),
    this.handlogFlopColor = const Color(0xFF101E33),
    this.handlogTurnColor = const Color(0xFF072818),
    this.handlogRiverColor = const Color(0xff453A02),
    this.handlogShowdownColor = const Color(0xFF44110A),
  });
}
