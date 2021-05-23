import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';

class Alerts {
  static void showSnackBar(BuildContext context, String text,
      {Duration duration = const Duration(milliseconds: 1500)}) {
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: AppColors.appAccentColor,
      content: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 16.0,
        ),
      ),
      duration: duration,
    ));
  }

  static void showTextNotification({@required String text}) {
    showSimpleNotification(
      Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontFamily: AppAssets.fontFamilyLato,
          fontWeight: FontWeight.w400,
        ),
      ),
      background: AppColors.cardBackgroundColor,
      position: NotificationPosition.top,
    );
  }

}
