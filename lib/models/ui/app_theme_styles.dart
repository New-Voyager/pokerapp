import 'dart:convert';

import 'package:flutter/material.dart';

Map<String, AppThemeStyle> appStyles;

class AppThemeStyle {
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

  //Circle Image Button
  TextStyle circleImageButtonTextStyle;
  Color circleImageButtonBorderColor;
  Color circleImageButtonBackgroundColor;
  Color circleImageButtonImageColor;

  //Rounded Button
  Color roundedButtonBackgroundColor;
  TextStyle roundedButtonTextStyle;
  Color roundedButtonBorderColor;
  Color roundButtonTextColor;

  //Rounded2 Button
  Color roundedButton2BackgroundColor;
  TextStyle roundedButton2TextStyle;
  Color roundButton2TextColor;

  //Confirm Yes Button
  Color confirmYesButtonBackgroundColor;
  Color confirmYesButtonIconColor;

  //Confirm No Button
  Color confirmNoButtonBackgroundColor;
  Color confirmNoButtonIconColor;

  // Handlog stage colors
  Color handlogPreflopColor;
  Color handlogFlopColor;
  Color handlogTurnColor;
  Color handlogRiverColor;
  Color handlogShowdownColor;

  Color navFabColor;
  Color navBgColor;
  AppThemeStyle();

  factory AppThemeStyle.fromJson(dynamic json) {
    AppThemeStyle style = AppThemeStyle();
    String color = json['primaryColor'] as String;
    style.primaryColor = HexColor.fromHex(color);
    style.secondaryColor = HexColor.fromHex(json['secondaryColor']);
    style.accentColor = HexColor.fromHex(json['accentColor']);
    style.fillInColor = HexColor.fromHex(json['fillInColor']);
    style.supportingColor = HexColor.fromHex(json['supportingColor']);
    style.negativeOrErrorColor = HexColor.fromHex(json['negativeOrErrorColor']);
    style.navBgColor = HexColor.fromHex(json['navBgColor']);
    style.navFabColor = HexColor.fromHex(json['navFabColor']);
    style.circleImageButtonBorderColor =
        HexColor.fromHex(json['circleImageButtonBorderColor']);
    style.circleImageButtonBackgroundColor =
        HexColor.fromHex(json['circleImageButtonBackgroundColor']);
    style.circleImageButtonImageColor =
        HexColor.fromHex(json['circleImageButtonImageColor']);
    style.roundedButtonBackgroundColor =
        HexColor.fromHex(json['roundedButtonBackgroundColor']);
    style.roundedButtonBorderColor =
        HexColor.fromHex(json['roundedButtonBorderColor']);
    style.roundedButton2BackgroundColor =
        HexColor.fromHex(json['roundedButton2BackgroundColor']);
    style.confirmNoButtonBackgroundColor =
        HexColor.fromHex(json['confirmNoButtonBackgroundColor']);
    style.confirmNoButtonIconColor =
        HexColor.fromHex(json['confirmNoButtonIconColor']);
    style.confirmYesButtonBackgroundColor =
        HexColor.fromHex(json['confirmYesButtonBackgroundColor']);
    style.confirmYesButtonIconColor =
        HexColor.fromHex(json['confirmYesButtonIconColor']);
    style.handlogPreflopColor = HexColor.fromHex(json['handlogPreflopColor']);
    style.handlogFlopColor = HexColor.fromHex(json['handlogFlopColor']);
    style.handlogTurnColor = HexColor.fromHex(json['handlogTurnColor']);
    style.handlogRiverColor = HexColor.fromHex(json['handlogRiverColor']);
    style.handlogShowdownColor = HexColor.fromHex(json['handlogShowdownColor']);

    style.fontFamily = json['fontFamily'] as String;
    style.roundedButton2TextStyle = TextStyle();
    style.roundedButtonTextStyle = TextStyle();
    style.roundButtonTextColor = HexColor.fromHex(json['roundButtonTextColor']);
    style.roundButton2TextColor =
        HexColor.fromHex(json['roundButton2TextColor']);
    // parse text styles here
    return style;
  }

  Map<String, dynamic> toMap() {
    return {
      "primaryColor": this.primaryColor.value,
      "secondaryColor": this.secondaryColor.value,
      "accentColor": this.accentColor.value,
      "fillInColor": this.fillInColor.value,
      "supportingColor": this.supportingColor.value,
      "negativeOrErrorColor": this.negativeOrErrorColor.value,
      "fontFamily": this.fontFamily,
      "circleImageButtonBorderColor": this.circleImageButtonBorderColor,
      "circleImageButtonBackgroundColor": this.circleImageButtonBackgroundColor,
      "circleImageButtonImageColor": this.circleImageButtonImageColor,
      "circleImageButtonTextStyle": this.circleImageButtonTextStyle,
      "roundedButtonTextStyle": this.roundedButtonTextStyle,
      "roundButtonTextColor": this.roundButtonTextColor,
      "roundedButtonBackgroundColor": this.roundedButtonBackgroundColor,
      "roundedButton2TextStyle": this.roundedButton2TextStyle,
      "roundedButton2BackgroundColor": this.roundedButton2BackgroundColor,
      "roundButton2TextColor": this.roundButton2TextColor,
      "confirmYesButtonBackgroundColor": this.confirmYesButtonBackgroundColor,
      "confirmYesButtonIconColor": this.confirmYesButtonIconColor,
      "confirmNoButtonBackgroundColor": this.confirmNoButtonBackgroundColor,
      "confirmNoButtonIconColor": this.confirmNoButtonIconColor,
      "navBgColor": this.navBgColor.value,
      "navFabColor": this.navFabColor.value,
    };
  }
}

Map<String, AppThemeStyle> getAppStyles() {
  if (appStyles != null) {
    return appStyles;
  }
  appStyles = Map<String, AppThemeStyle>();
  final defaultStyleJson = jsonDecode(defaultAppStyle);
  final defaultStyle = AppThemeStyle.fromJson(defaultStyleJson);
  appStyles['default'] = defaultStyle;
  return appStyles;
}

AppThemeStyle getAppStyle(String name) {
  final appStyles = getAppStyles();
  if (appStyles.containsKey(name)) {
    return appStyles[name];
  }
  return appStyles['default'];
}

String defaultAppStyle = '''{
  "fontFamily": "Poppins",
  "primaryColor": "FF033614",
  "secondaryColor": "FF00FAAD",
  "accentColor": "FFD89E40",
  "fillInColor": "FF0B2324",
  "supportingColor": "FFFFFFFF",
  "negativeOrErrorColor": "FFFA0000",

  "navBgColor": "FF3D5242",
  "navFabColor": "FF40D876",
  "circleImageButtonBorderColor": "FF000000",
  "circleImageButtonBackgroundColor": "FFD89E40",
  "circleImageButtonImageColor": "FF000000",
  "roundedButtonBackgroundColor": "FFD89E40",
  "roundedButtonBorderColor": "FF000000",
  "roundedButton2BackgroundColor": "FFFFFFFF",
  "roundButtonTextColor": "FF000000",
  "roundButton2TextColor": "FF000000",
  "roundedButtonTextStyle": {
    "color": "FF000000"
  },
  "roundedButton2TextStyle": {
    "color": "FF000000"
  },
  "confirmNoButtonBackgroundColor": "FFFF0000",
  "confirmNoButtonIconColor": "FFFFFFFF",
  "confirmYesButtonBackgroundColor": "FF00FF00",
  "confirmYesButtonIconColor": "FFFFFFFF",

  "handlogPreflopColor": "FF1A0E2D",
  "handlogFlopColor": "FF101E33",
  "handlogTurnColor": "FF072818",
  "handlogRiverColor": "FF453A02",
  "handlogShowdownColor": "FF44110A"
}''';

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
