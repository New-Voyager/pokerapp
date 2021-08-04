import 'package:flutter/material.dart';

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

  AppThemeData({
    this.primaryColor = const Color(0xFF033614), // 0xFF300614
    // Color(0xFF40D876); (darken secondary color)
    this.secondaryColor = const Color(0xFF00FAAD),
    this.accentColor = const Color(0xFFD89E40),
    this.fillInColor = const Color(0xFF0B2324),
    this.supportingColor = Colors.white,
    this.negativeOrErrorColor = const Color(0xFFFA0000),
  });
}
