import 'app_theme_styles.dart';

class AppThemeData {
  // // main color that the app is based on
  // Color primaryColor;

  // // color that is used on buttons or other highlighting places
  // Color secondaryColor;

  // // accent color that works with the main color in the app
  // Color accentColor;

  // // color that is used for filling inside text fields, or cards views
  // Color fillInColor;

  // // supporting color: color that is used to create constrast with main color and accent color
  // // mainly used for texts (white, or shades of white)
  // Color supportingColor;

  // // color used for negatives or errors
  // Color negativeOrErrorColor;

  // // font family
  // String fontFamily;

  // //Circle Image Button
  // TextStyle circleImageButtonTextStyle;
  // Color circleImageButtonBorderColor;
  // Color circleImageButtonBackgroundColor;
  // Color circleImageButtonImageColor;

  // //Rounded Button
  // Color roundedButtonBackgroundColor;
  // TextStyle roundedButtonTextStyle;
  // Color roundedButtonBorderColor;

  // //Rounded2 Button
  // Color roundedButton2BackgroundColor;
  // TextStyle roundedButton2TextStyle;

  // //Confirm Yes Button
  // Color confirmYesButtonBackgroundColor;
  // Color confirmYesButtonIconColor;

  // //Confirm No Button
  // Color confirmNoButtonBackgroundColor;
  // Color confirmNoButtonIconColor;

  // // Handlog stage colors
  // Color handlogPreflopColor;
  // Color handlogFlopColor;
  // Color handlogTurnColor;
  // Color handlogRiverColor;
  // Color handlogShowdownColor;

  // Color navFabColor;
  // Color navBgColor;

  AppThemeStyle style;
  String tableAssetId;
  String backDropAssetId;
  String cardFaceAssetId;
  String cardBackAssetId;

  String betAssetId;

  AppThemeData({
    // this.primaryColor = const Color(0xFF033614), // 0xFF300614
    // // Color(0xFF40D876); (darken secondary color)
    // this.secondaryColor = const Color(0xFF00FAAD),
    // this.accentColor = const Color(0xFFD89E40),
    // this.fillInColor = const Color(0xFF0B2324),
    // this.supportingColor = Colors.white,
    // this.negativeOrErrorColor = const Color(0xFFFA0000),
    // this.fontFamily = AppAssetsNew.fontFamilyPoppins,
    // this.handlogPreflopColor = const Color(0xFF1A0E2D),
    // this.handlogFlopColor = const Color(0xFF101E33),
    // this.handlogTurnColor = const Color(0xFF072818),
    // this.handlogRiverColor = const Color(0xff453A02),
    // this.handlogShowdownColor = const Color(0xFF44110A),
    // this.navBgColor = const Color(0xFF3D5242),
    // this.navFabColor = const Color(0xFF40D876),
    // this.circleImageButtonTextStyle = const TextStyle(),
    // this.circleImageButtonBorderColor = Colors.black,
    // this.circleImageButtonBackgroundColor = const Color(0xFFD89E40),
    // this.circleImageButtonImageColor = Colors.black,
    // this.roundedButtonBackgroundColor = Colors.white,
    // this.roundedButtonBorderColor = Colors.black,
    // this.roundedButtonTextStyle = const TextStyle(),
    // this.roundedButton2BackgroundColor = Colors.white,
    // this.roundedButton2TextStyle = const TextStyle(),
    // this.confirmNoButtonBackgroundColor = Colors.red,
    // this.confirmNoButtonIconColor = Colors.white,
    // this.confirmYesButtonBackgroundColor = Colors.green,
    // this.confirmYesButtonIconColor = Colors.white,
    this.style,
    this.tableAssetId = "default-table",
    this.backDropAssetId = "default-backdrop",
    this.cardBackAssetId = "default-cardback",
    this.cardFaceAssetId = "default-cardface",
    this.betAssetId: "default-bet",
  });

  Map<String, dynamic> toMap() {
    return {
      "style": this.style.toMap(),
      "tableAssetId": this.tableAssetId,
      "backDropAssetId": this.backDropAssetId,
      "cardBackAssetId": this.cardBackAssetId,
      "cardFaceAssetId": this.cardFaceAssetId,
      "betAssetId": this.betAssetId,
    };
  }

  AppThemeData copyWith({
    AppThemeStyle style,
    String tableAssetId,
    String backDropAssetId,
    String cardFaceAssetId,
    String cardBackAssetId,
    String betAssetId,
  }) {
    return AppThemeData(
      style: style ?? this.style,
      tableAssetId: tableAssetId ?? this.tableAssetId,
      backDropAssetId: backDropAssetId ?? this.backDropAssetId,
      cardFaceAssetId: cardFaceAssetId ?? this.cardFaceAssetId,
      cardBackAssetId: cardBackAssetId ?? this.cardBackAssetId,
      betAssetId: betAssetId ?? this.betAssetId,
    );
  }
}
