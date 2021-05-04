import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_assets.dart';

import 'app_colors.dart';

class AppStyles {
  static const othersMessageDecoration = BoxDecoration(
    color: AppColors.cardBackgroundColor,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(16),
      bottomLeft: Radius.circular(16),
    ),
  );

  static const myMessageDecoration = BoxDecoration(
    color: AppColors.cardBackgroundColor,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(16),
      bottomRight: Radius.circular(16),
    ),
  );
  static const stackPopUpTextStyle = TextStyle(
    color: AppColors.lightGrayColor,
    fontSize: 12.0,
    fontFamily: AppAssets.fontFamilyLato,
    fontWeight: FontWeight.w400,
  );

  static const titleBarTextStyle = TextStyle(
    color: AppColors.appAccentColor,
    fontSize: 14.0,
    fontFamily: AppAssets.fontFamilyLato,
    fontWeight: FontWeight.w600,
  );
  static const cardTextStyle = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w700,
    fontFamily: AppAssets.fontFamilyTrocchi,
  );
  static const suitTextStyle = TextStyle(
    fontSize: 15.0,
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
    fontSize: 14.0,
    fontFamily: AppAssets.fontFamilyLato,
  );

  static const hostNameTextStyle = TextStyle(
    color: Color(0xffffffff),
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    fontFamily: AppAssets.fontFamilyLato,
  );
  static const sessionTimeTextStyle = TextStyle(
    color: Color(0xffffffff),
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
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
    color: Colors.black,
    fontSize: 12.0,
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
    fontSize: 16.0,
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

  // titles
  static const TextStyle subTitleTextStyle = TextStyle(
    fontFamily: 'Lato',
    color: AppColors.appAccentColor,
    fontSize: 20.0,
  );
  static const TextStyle titleTextStyle = TextStyle(
    fontFamily: 'Lato',
    color: Colors.white,
    fontSize: 25.0,
  );

  static const TextStyle notificationSubTitleTextStyle = TextStyle(
    fontFamily: 'Lato',
    color: AppColors.appAccentColor,
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
    color: AppColors.screenBackgroundColor,
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
    color: AppColors.stickerDialogTextColor,
    fontSize: 20.0,
  );

  static const TextStyle stickerDialogActionText =
      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);

  static const TextStyle betChipsText = TextStyle(
    fontSize: 16,
    color: Colors.yellow,
    fontWeight: FontWeight.w600,
  );

  static const disabledButtonTextStyle = TextStyle(
    color: Colors.grey,
    fontSize: 12.0,
    fontFamily: AppAssets.fontFamilyLato,
  );
}
