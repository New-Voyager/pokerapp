import 'package:flutter/material.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';

class AppStylesNew {
  static const RadialGradient newRadialGradientBg = RadialGradient(
    colors: [
      AppColorsNew.newGreenRadialStartColor,
      AppColorsNew.newGreenRadialStopColor,
      Colors.black,
    ],
    stops: [0.1, 0.3, 0.6],
  );

  static const RadialGradient newRadialGradientActiveBg = RadialGradient(
    colors: [
      Colors.black,
      AppColorsNew.newActiveBoxColor,
    ],
    stops: [0.1, 0.3],
  );

  static const RadialGradient newRadialGradientInactiveBg = RadialGradient(
    colors: [
      Colors.black,
      AppColorsNew.newInactiveBoxColor,
    ],
    stops: [0.1, 0.3],
  );
  static const BoxDecoration bgDecoration = BoxDecoration(
    color: AppColorsNew.newBackgroundBlackColor,
    image: DecorationImage(
      image: AssetImage(
        AppAssetsNew.pathBackgroundImage,
      ),
      fit: BoxFit.cover,
    ),
  );

  static const TextStyle JoinTextStyle = TextStyle(
    color: AppColorsNew.newBackgroundBlackColor,
    fontWeight: FontWeight.w700,
    fontSize: 12,
  );
  static const TextStyle TitleTextStyle = TextStyle(
      fontSize: 18,
      color: AppColorsNew.newTextColor,
      fontFamily: AppAssetsNew.fontFamilyRockwell,
      fontWeight: FontWeight.w700,
      shadows: [
        BoxShadow(
            color: Colors.green,
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 3)),
      ]);

  static const TextStyle BuyInTextStyle = TextStyle(
    color: AppColorsNew.newTextColor,
    fontFamily: AppAssetsNew.fontFamilyPoppins,
    fontWeight: FontWeight.w300,
    fontSize: 10,
  );
  static const TextStyle GameTypeTextStyle = TextStyle(
      color: AppColorsNew.newTextColor,
      fontWeight: FontWeight.w700,
      fontFamily: AppAssetsNew.fontFamilyPoppins);
  static const TextStyle GameIdTextStyle = TextStyle(
      color: AppColorsNew.newTextGreenColor,
      fontWeight: FontWeight.w300,
      fontSize: 12,
      fontFamily: AppAssetsNew.fontFamilyPoppins);
  static const TextStyle OpenSeatsTextStyle = TextStyle(
      color: AppColorsNew.newTextColor,
      fontSize: 12,
      fontFamily: AppAssetsNew.fontFamilyPoppins);
  static const TextStyle ElapsedTimeTextStyle = TextStyle(
      color: AppColorsNew.newTextColor,
      fontSize: 10,
      fontFamily: AppAssetsNew.fontFamilyPoppins);
}
