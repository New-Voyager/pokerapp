import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_colors.dart';

class ReplayHandControlsUtils {
  ReplayHandControlsUtils._();

  static Widget buildControlButton({
    @required IconData iconData,
    @required void onPressed(),
  }) =>
      InkWell(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.appAccentColor,
              width: 1.0,
            ),
          ),
          padding: EdgeInsets.all(10.0),
          child: Icon(
            iconData,
            color: AppColors.appAccentColor,
            size: 30.0,
          ),
        ),
      );
}
