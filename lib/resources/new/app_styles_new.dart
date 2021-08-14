import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_assets.dart';
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

  // static final dialogTextStyle = TextStyle(
  //   color: Colors.green,
  //   fontSize: 10.dp,
  //   fontWeight: FontWeight.normal,
  // );
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

  // app styles imported from app_styles.dart (OLD)

  static LinearGradient handlogGreyGradient = LinearGradient(
    colors: [Colors.grey[850], Colors.grey[700]],
  );

  // static LinearGradient handlogBlueGradient = LinearGradient(
  //   colors: [Color(0xFF02386E), Color(0xFF00498D)],
  // );

  // static const playerNameTextStyle = const TextStyle(
  //   fontFamily: AppAssets.fontFamilyLato,
  //   color: Colors.white,
  //   fontSize: 14.0,
  //   fontWeight: FontWeight.w600,
  // );
  static const boldTitleTextStyle = TextStyle(
    fontFamily: AppAssets.fontFamilyLato,
    color: Colors.white,
    fontSize: 22.0,
    fontWeight: FontWeight.w900,
  );

  static const myMessageDecoration = BoxDecoration(
    color: AppColorsNew.cardBackgroundColor,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(16),
      bottomLeft: Radius.circular(16),
    ),
  );

  static const otherMessageDecoration = BoxDecoration(
    color: AppColorsNew.cardBackgroundColor,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(16),
      bottomRight: Radius.circular(16),
    ),
  );

  static final stackPopUpTextStyle = TextStyle(
    color: Colors.blue[900],
    fontSize: 12.0,
    fontFamily: AppAssets.fontFamilyLato,
    fontWeight: FontWeight.w400,
  );

  static const titleBarTextStyle = TextStyle(
    color: AppColorsNew.appAccentColor,
    fontSize: 14.0,
    fontFamily: AppAssets.fontFamilyLato,
    fontWeight: FontWeight.w600,
  );
  static final cardTextStyle = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w700,
    fontFamily: AppAssets.fontFamilyTrocchi,
  );
  static final suitTextStyle = TextStyle(
    fontSize: 40.0,
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
    fontSize: 18.0,
    color: const Color(0xffCEE5F1),
    fontFamily: AppAssets.fontFamilyLato,
  );

  static const gamePlayScreenHeaderTextStyle2 = TextStyle(
    fontSize: 12.0,
    color: const Color(0xfff2a365),
    fontFamily: AppAssets.fontFamilyLato,
  );

  static const userPopUpMessageTextStyle = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.bold,
    fontFamily: AppAssets.fontFamilyLato,
  );

  static const itemInfoTextStyle = TextStyle(
    color: Color(0xff848484),
    fontSize: 12.0,
    fontFamily: AppAssets.fontFamilyLato,
  );

  static const hostInfoTextStyle = TextStyle(
    color: Color(0xff848484),
    fontSize: 12.0,
    fontFamily: AppAssets.fontFamilyLato,
  );

  static const hostNameTextStyle = TextStyle(
    color: Color(0xffffffff),
    fontSize: 14.0,
    // fontWeight: FontWeight.bold,
    fontFamily: AppAssets.fontFamilyLato,
  );
  static const sessionTimeTextStyle = TextStyle(
    color: Color(0xffffffff),
    fontSize: 14.0,
    //  fontWeight: FontWeight.bold,
    fontFamily: AppAssets.fontFamilyLato,
  );
  static const blindsTextStyle = TextStyle(
    color: Color(0xffffff84),
    fontSize: 16.0,
    fontFamily: AppAssets.fontFamilyLato,
  );

  static const gameCodeTextStyle = TextStyle(
    color: Colors.white60,
    fontSize: 10.0,
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
    fontSize: 12.0,
    fontWeight: FontWeight.bold,
    fontFamily: AppAssets.fontFamilyLato,
  );

  static const gamePlayScreenPlayerChips = TextStyle(
    color: Colors.white,
    fontSize: 12.0,
    fontWeight: FontWeight.w800,
    fontFamily: AppAssets.fontFamilyLato,
  );

  static const dealerTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 10.0,
    fontWeight: FontWeight.w800,
    fontFamily: AppAssets.fontFamilyLato,
  );

  static const itemInfoSecondaryTextStyle = TextStyle(
    color: Color(0xff848484),
    fontSize: 16.0,
    fontFamily: AppAssets.fontFamilyLato,
  );

  // club item info text styles
  static const clubCodeStyle = TextStyle(
    color: Colors.white,
    fontSize: 15.0,
    fontFamily: AppAssets.fontFamilyLato,
  );

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

  // // login screen
  // static const TextStyle welcomeTextStyle = TextStyle(
  //   fontFamily: AppAssets.fontFamilyLato,
  //   color: Colors.white,
  //   fontSize: 48.0,
  //   fontWeight: FontWeight.w700,
  // );

  static const TextStyle credentialsTextStyle = TextStyle(
    fontFamily: 'Lato',
    color: Colors.white,
    fontSize: 18.0,
    fontWeight: FontWeight.w400,
  );

  // titles
  static const TextStyle subTitleTextStyle = TextStyle(
    fontFamily: 'Lato',
    color: AppColorsNew.appAccentColor,
    fontSize: 20.0,
  );
  // static const TextStyle titleTextStyle = TextStyle(
  //   fontFamily: 'Lato',
  //   color: Colors.white,
  //   fontSize: 25.0,
  // );

  static const TextStyle notificationSubTitleTextStyle = TextStyle(
    fontFamily: 'Lato',
    color: AppColorsNew.appAccentColor,
    fontSize: 15.0,
  );
  static const TextStyle notificationTitleTextStyle = TextStyle(
    fontFamily: 'Lato',
    color: Colors.white,
    fontSize: 18.0,
  );

  // game option fonts
  static const optionTitle = TextStyle(
    color: Color(0xff319ffe),
    fontSize: 15.0,
    fontFamily: AppAssets.fontFamilyLato,
    fontWeight: FontWeight.bold,
  );

  static const optionname = TextStyle(
    color: AppColorsNew.screenBackgroundColor,
    fontSize: 15.0,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle optionTitleText = TextStyle(
    fontFamily: 'Lato',
    color: Colors.white,
    fontSize: 20.0,
  );

  static const TextStyle stickerDialogText = TextStyle(
    fontFamily: 'Lato',
    color: AppColorsNew.stickerDialogTextColor,
    fontSize: 20.0,
  );

  static const TextStyle stickerDialogActionText =
      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);

  // static const TextStyle betChipsText = TextStyle(
  //   fontSize: 16,
  //   color: Colors.yellow,
  //   fontWeight: FontWeight.w600,
  // );

  static const disabledButtonTextStyle = TextStyle(
    color: Colors.grey,
    fontSize: 12.0,
    fontFamily: AppAssets.fontFamilyLato,
  );

  static final profitStyle = TextStyle(color: Colors.green[400]);
  static final lossStyle = TextStyle(color: Colors.red[800]);
}
