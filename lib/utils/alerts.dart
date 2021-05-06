import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
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

  static void showNotification(String text){
     showSimpleNotification(
      Text(text),
      position: NotificationPosition.top,
      autoDismiss: true,
      background: AppColors.cardBackgroundColor,
      duration: Duration(seconds: 5),
    );
  }
}
