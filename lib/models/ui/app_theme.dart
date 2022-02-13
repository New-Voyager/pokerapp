import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme_data.dart';
import 'package:provider/provider.dart';

class AppTheme extends ChangeNotifier {
  AppThemeData _themeData;

  // constructor, which takes in app theme data
  AppTheme(this._themeData);

  get themeData => _themeData;

  get tableAssetId => _themeData.tableAssetId;
  get backDropAssetId => _themeData.backDropAssetId;
  get cardFaceAssetId => _themeData.cardFaceAssetId;
  get cardBackAssetId => _themeData.cardBackAssetId;
  get betAssetId => _themeData.betAssetId;

  get navBgColor => _themeData.style.navBgColor;

  get navFabColor => _themeData.style.navFabColor;

  // function to update the theme data
  void updateThemeData(AppThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // call this from anywhere to get the app theme object
  static AppTheme getTheme(BuildContext context) {
    return context.read<AppTheme>();
  }

  // font family
  String get fontFamily => _themeData.style.fontFamily;
  void updateFontFamily(String fontFamily) {
    _themeData.style.fontFamily = fontFamily;
    notifyListeners();
  }

  // util functions for darkening or lighting a color

  // darken a color
  Color _darken(Color color, [double amount = 0.10]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  // lighten a color
  Color _lighten(Color color, [double amount = 0.10]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

  // main color that the app is based on
  Color get primaryColor => _themeData.style.primaryColor;
  Color primaryColorWithDark([double d = 0.10]) {
    return _darken(_themeData.style.primaryColor, d);
  }

  Color primaryColorWithLight([double l = 0.10]) =>
      _lighten(_themeData.style.primaryColor, l);

  // color that is used on buttons or other highlighting places
  Color get secondaryColor => _themeData.style.secondaryColor;
  Color secondaryColorWithDark([double d = 0.10]) =>
      _darken(_themeData.style.secondaryColor, d);
  Color secondaryColorWithLight([double l = 0.10]) =>
      _lighten(_themeData.style.secondaryColor, l);

  // accent color that works with the main color in the app
  Color get accentColor => _themeData.style.accentColor;
  Color accentColorWithDark([double d = 0.10]) =>
      _darken(_themeData.style.accentColor, d);
  Color accentColorWithLight([double l = 0.10]) =>
      _lighten(_themeData.style.accentColor, l);

  Color blackColorWithLight([double l = 0.10]) => _lighten(Colors.black, l);
  Color blackColorWithDark([double l = 0.10]) => _darken(Colors.black, l);

  // color that is used for filling inside text fields, or cards views
  Color get fillInColor => _themeData.style.fillInColor;

  Color get preFlopColor => _themeData.style.handlogPreflopColor;
  Color get flopColor => _themeData.style.handlogFlopColor;
  Color get turnColor => _themeData.style.handlogTurnColor;
  Color get riverColor => _themeData.style.handlogRiverColor;
  Color get showDownColor => _themeData.style.handlogShowdownColor;

  // supporting color: color that is used to create constrast with main color and accent color
  // mainly used for texts (white, or shades of white)
  Color get supportingColor => _themeData.style.supportingColor;
  Color supportingColorWithDark([double d = 0.10]) =>
      _darken(_themeData.style.supportingColor, d);
  Color supportingColorWithLight([double l = 0.10]) =>
      _lighten(_themeData.style.supportingColor, l);

  // negative or error colors
  // TODO: MAY BE WE CAN HAVE DIFFERENT SHADES OF THIS
  Color get negativeOrErrorColor => _themeData.style.negativeOrErrorColor;

  //Game List Shade Color
  Color get gameListShadeColor => _themeData.style.gameListShadeColor;

  //Rounded Button
  Color get roundedButtonBackgroundColor =>
      _themeData.style.roundedButtonBackgroundColor;
  TextStyle get roundedButtonTextStyle =>
      _themeData.style.roundedButtonTextStyle;
  Color get roundedButtonBorderColor =>
      _themeData.style.roundedButtonBorderColor;
  Color get roundButtonTextColor => _themeData.style.roundButtonTextColor;

  //Rounded Button 2
  Color get roundedButton2BackgroundColor =>
      _themeData.style.roundedButton2BackgroundColor;
  TextStyle get roundedButton2TextStyle =>
      _themeData.style.roundedButton2TextStyle;
  Color get roundButton2TextColor => _themeData.style.roundButton2TextColor;

  //Circle Image Button
  Color get circleImageButtonBorderColor =>
      _themeData.style.circleImageButtonBorderColor;
  Color get circleImageButtonImageColor =>
      _themeData.style.circleImageButtonImageColor;
  Color get circleImageButtonBackgroundColor =>
      _themeData.style.circleImageButtonBackgroundColor;
  TextStyle get circleImageButtonTextStyle =>
      _themeData.style.circleImageButtonTextStyle;

  //Confirm Yes Button
  Color get confirmYesButtonBackgroundColor =>
      _themeData.style.confirmYesButtonBackgroundColor;
  Color get confirmYesButtonIconColor =>
      _themeData.style.confirmYesButtonIconColor;

  //Confirm No Button
  Color get confirmNoButtonBackgroundColor =>
      _themeData.style.confirmNoButtonBackgroundColor;
  Color get confirmNoButtonIconColor =>
      _themeData.style.confirmNoButtonIconColor;
}
