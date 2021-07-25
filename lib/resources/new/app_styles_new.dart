import 'package:flutter/material.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class AppStylesNew {
  static final accentTextStyle = TextStyle(
    color: AppColorsNew.yellowAccentColor,
    fontSize: 10.dp,
    fontWeight: FontWeight.w400,
  );
  static final cardHeaderTextStyle = TextStyle(
    color: AppColorsNew.newTextColor,
    fontSize: 12.dp,
    fontWeight: FontWeight.w500,
  );
  static final statValTextStyle = TextStyle(
    color: AppColorsNew.newTextColor,
    fontSize: 10.dp,
    fontWeight: FontWeight.w300,
  );
  static final statTitleTextStyle = TextStyle(
    color: AppColorsNew.newTextColor,
    fontSize: 12.dp,
    fontWeight: FontWeight.w300,
  );
  static final labelTextStyle = TextStyle(
    color: AppColorsNew.labelColor,
    fontSize: 8.dp,
  );
  static final valueTextStyle = TextStyle(
    color: AppColorsNew.newTextColor,
    fontSize: 12.dp,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle appBarTitleTextStyle = TextStyle(
    fontFamily: AppAssetsNew.fontFamilyPoppins,
    fontSize: 12.dp,
    fontWeight: FontWeight.w500,
    color: AppColorsNew.yellowAccentColor,
  );

  static final TextStyle appBarSubTitleTextStyle = TextStyle(
    fontFamily: AppAssetsNew.fontFamilyPoppins,
    fontSize: 8.dp,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
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
  static final BoxDecoration bgCurvedGreenRadialGradient = BoxDecoration(
    gradient: RadialGradient(
      colors: [
        AppColorsNew.newGreenRadialStartColor,
        AppColorsNew.newBackgroundBlackColor,
      ],
      center: Alignment.topLeft,
      radius: 1.5,
    ),
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(AppDimensionsNew.bottomSheetRadius),
      topRight: Radius.circular(AppDimensionsNew.bottomSheetRadius),
    ),
    boxShadow: [
      BoxShadow(
        color: AppColorsNew.newGreenButtonColor,
        offset: Offset(1, 1),
        blurRadius: 1,
        spreadRadius: 1,
      )
    ],
  );
  static final TextStyle gameActionTextStyle = TextStyle(
    color: AppColorsNew.newTextColor,
    fontSize: 10.0.dp,
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
  static BoxDecoration bgDecoration = BoxDecoration(
    color: AppColorsNew.newBackgroundBlackColor,
    image: DecorationImage(
      image: AssetImage(
        AppAssetsNew.chatBgImagePath,
        // AppAssetsNew.pathBackgroundImage,
      ),
      repeat: ImageRepeat.repeat,
    ),
  );

  static final TextStyle joinTextStyle = TextStyle(
    color: AppColorsNew.newBackgroundBlackColor,
    fontWeight: FontWeight.w700,
    fontSize: 11.dp,
  );

  static final TextStyle backButtonTextStyle = TextStyle(
    color: AppColorsNew.newGreenButtonColor,
    fontFamily: AppAssetsNew.fontFamilyPoppins,
    fontSize: 13.dp,
  );
  static TextStyle titleTextStyle = TextStyle(
      fontSize: 18.dp,
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

  static final TextStyle buyInTextStyle = TextStyle(
    color: AppColorsNew.newTextColor,
    fontFamily: AppAssetsNew.fontFamilyPoppins,
    fontWeight: FontWeight.w300,
    fontSize: 9.0.dp,
  );

  static final TextStyle gameTypeTextStyle = TextStyle(
    fontSize: 12.0.dp,
    color: AppColorsNew.newTextColor,
    fontWeight: FontWeight.w700,
    fontFamily: AppAssetsNew.fontFamilyPoppins,
  );

  static final TextStyle gameIdTextStyle = TextStyle(
    color: AppColorsNew.newTextGreenColor,
    fontWeight: FontWeight.w300,
    fontSize: 10.dp,
    fontFamily: AppAssetsNew.fontFamilyPoppins,
  );

  static final TextStyle openSeatsTextStyle = TextStyle(
    color: AppColorsNew.newTextColor,
    fontSize: 10.dp,
    fontFamily: AppAssetsNew.fontFamilyPoppins,
  );

  static final TextStyle elapsedTimeTextStyle = TextStyle(
    color: AppColorsNew.newTextColor,
    fontSize: 8.dp,
    fontFamily: AppAssetsNew.fontFamilyPoppins,
  );

  static final TextStyle activeChipTextStyle = TextStyle(
    color: AppColorsNew.newBackgroundBlackColor,
    fontFamily: AppAssetsNew.fontFamilyPoppins,
    fontWeight: FontWeight.w500,
    fontSize: 12.dp,
  );

  static final TextStyle inactiveChipTextStyle = TextStyle(
    color: AppColorsNew.newTextColor,
    fontFamily: AppAssetsNew.fontFamilyPoppins,
    fontWeight: FontWeight.w300,
    fontSize: 12.dp,
  );

  static final clubShortCodeTextStyle = TextStyle(
    color: AppColorsNew.newTextColor,
    fontSize: 20.0.dp,
    fontFamily: AppAssetsNew.fontFamilyPoppins,
    fontWeight: FontWeight.w700,
  );

  static final clubTitleTextStyle = TextStyle(
    color: AppColorsNew.newTextColor,
    fontSize: 15.0.dp,
    fontFamily: AppAssetsNew.fontFamilyPoppins,
  );

  static final gradientBoxDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [
        AppColorsNew.darkFlopShadeColor,
        AppColorsNew.flopStopColor,
      ],
    ),
    borderRadius: BorderRadius.circular(8),
  );

  static final gradientFlopBoxDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [
        AppColorsNew.darkGreenShadeColor,
        AppColorsNew.newGreenRadialStopColor,
      ],
    ),
    borderRadius: BorderRadius.circular(8),
  );

  static final gradientBorderBoxDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [
        AppColorsNew.darkGreenShadeColor,
        AppColorsNew.newGreenRadialStopColor,
      ],
    ),
    border: Border.all(
      color: AppColorsNew.newBorderColor,
      width: 0.5,
    ),
    borderRadius: BorderRadius.circular(5),
  );

  static final stageNameTextStyle = TextStyle(
    fontSize: 14.dp,
    fontWeight: FontWeight.w800,
    color: AppColorsNew.newTextColor,
  );

  static final potSizeTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w800,
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

  static final dialogTextStyle = TextStyle(
    color: Colors.green,
    fontSize: 10.dp,
    fontWeight: FontWeight.normal,
  );
  static final textButtonStyle = TextStyle(
    color: AppColorsNew.newGreenButtonColor,
    fontSize: 10.dp,
    fontWeight: FontWeight.normal,
  );
  // static final valueTextStyle = TextStyle(
  //   fontSize: 14,
  //   fontWeight: FontWeight.w500,
  //   color: AppColorsNew.newTextColor,
  // );

  static final actionRowDecoration = BoxDecoration(
    color: AppColorsNew.actionRowBgColor,
    borderRadius: BorderRadius.circular(5),
  );

  static final blackContainerDecoration = BoxDecoration(
    border: Border.all(color: AppColorsNew.borderColor, width: 1),
    color: AppColorsNew.newBackgroundBlackColor,
    borderRadius: BorderRadius.circular(8),
  );

  static final gameHistoryDecoration = BoxDecoration(
    border: Border.all(color: AppColorsNew.gameHistoryColor, width: 2),
    color: AppColorsNew.newBackgroundBlackColor,
    borderRadius: BorderRadius.circular(8),
  );
  static final greenContainerDecoration = BoxDecoration(
    border: Border.all(color: AppColorsNew.borderColor, width: 1),
    color: AppColorsNew.tileGreenColor,
    borderRadius: BorderRadius.circular(8),
  );

  static final resumeBgDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      // color: Colors.black.withOpacity(0.50),
      image: DecorationImage(
        image: AssetImage(
          AppAssetsNew.pauseBgPath,
        ),
        fit: BoxFit.fill,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.white54,
          spreadRadius: 10,
          blurRadius: 20,
        ),
      ]);

  static final labelTextFieldStyle = TextStyle(
    color: AppColorsNew.yellowAccentColor,
  );
  static final focusBorderStyle = OutlineInputBorder(
    borderRadius: BorderRadius.circular(32),
    borderSide: BorderSide(
      color: AppColorsNew.newBorderColor,
    ),
  );
  static final errorBorderStyle = OutlineInputBorder(
    borderRadius: BorderRadius.circular(32),
    borderSide: BorderSide(
      color: AppColorsNew.newRedButtonColor,
    ),
  );

  static final borderStyle = OutlineInputBorder(
    borderRadius: BorderRadius.circular(32),
    borderSide: BorderSide(
      color: AppColorsNew.actionRowBgColor,
    ),
  );
}
