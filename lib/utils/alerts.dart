import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/overlay_notification.dart';

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

  static void showNotification({
    @required String titleText,
    String subTitleText,
    IconData leadingIcon,
    Duration duration,
  }) {
    if (duration == null) {
      duration = Duration(milliseconds: 1500);
    }
    showOverlayNotification(
      (context) => OverlayNotificationWidget(
        title: titleText,
        subTitle: subTitleText,
        icon: leadingIcon,
      ),
      position: NotificationPosition.top,
      duration: duration,
    );
  }
}
