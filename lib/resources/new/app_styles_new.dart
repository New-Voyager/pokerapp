import 'package:flutter/material.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';

class AppStylesNew {
  static const TextStyle AppBarTitleTextStyle = TextStyle(
    fontFamily: AppAssetsNew.fontFamilyPoppins,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static const BoxDecoration BgGreenRadialGradient = BoxDecoration(
    gradient: RadialGradient(
      colors: [
        AppColorsNew.newGreenRadialStartColor,
        AppColorsNew.newBackgroundBlackColor,
      ],
      center: Alignment.topLeft,
      radius: 1.5,
    ),
  );
  static const TextStyle GameActionTextStyle = TextStyle(
    color: AppColorsNew.newTextColor,
    fontSize: 11.0,
    fontFamily: AppAssetsNew.fontFamilyPoppins,
  );

  static ButtonStyle cancelButtonStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(
        color: AppColorsNew.newRedButtonColor,
        width: 2,
      ),
    ),
    textStyle: TextStyle(
      fontSize: 12,
    ),
    primary: Colors.transparent,
    shadowColor: AppColorsNew.newRedButtonColor,
    elevation: 2,
  );

  static ButtonStyle saveButtonStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(
        color: AppColorsNew.newGreenButtonColor,
        width: 2,
      ),
    ),
    textStyle: TextStyle(
      fontSize: 12,
    ),
    primary: Colors.transparent,
    shadowColor: AppColorsNew.newGreenButtonColor,
    elevation: 2,
  );
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

  static const TextStyle BackButtonTextStyle = TextStyle(
    color: AppColorsNew.newGreenButtonColor,
    fontFamily: AppAssetsNew.fontFamilyPoppins,
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

  static const TextStyle ActiveChipTextStyle = TextStyle(
    color: AppColorsNew.newBackgroundBlackColor,
    fontFamily: AppAssetsNew.fontFamilyPoppins,
    fontWeight: FontWeight.w500,
    fontSize: 12,
  );

  static const TextStyle InactiveChipTextStyle = TextStyle(
    color: AppColorsNew.newTextColor,
    fontFamily: AppAssetsNew.fontFamilyPoppins,
    fontWeight: FontWeight.w300,
    fontSize: 12,
  );

  static const ClubShortCodeTextStyle = TextStyle(
    color: AppColorsNew.newTextColor,
    fontSize: 25.0,
    fontFamily: AppAssetsNew.fontFamilyPoppins,
    fontWeight: FontWeight.w700,
  );

  static const ClubTitleTextStyle = TextStyle(
    color: AppColorsNew.newTextColor,
    fontSize: 18.0,
    fontFamily: AppAssetsNew.fontFamilyPoppins,
  );

  static final gradientBoxDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [
        AppColorsNew.darkGreenShadeColor,
        AppColorsNew.newGreenRadialStopColor,
      ],
    ),
    borderRadius: BorderRadius.circular(8),
  );

  static final stageNameTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColorsNew.newTextColor,
  );

  static final potSizeTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColorsNew.newTextColor,
  );

  static final playerNameTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColorsNew.newTextColor,
  );

  static final balanceTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColorsNew.newTextColor,
  );

  static final valueTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColorsNew.newTextColor,
  );

  static final actionRowDecoration = BoxDecoration(
    color: AppColorsNew.actionRowBgColor,
    borderRadius: BorderRadius.circular(5),
  );
}
