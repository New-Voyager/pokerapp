import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';

class ReplayHandControlsUtils {
  ReplayHandControlsUtils._();

  static Widget buildControlButton({
    @required IconData iconData,
    @required void onPressed(),
    @required bool isActive,
  }) =>
      InkWell(
        onTap: isActive ? onPressed : null,
        child: Opacity(
          opacity: isActive ? 1.0 : 0.50,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.60),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColorsNew.newGreenButtonColor,
                width: 3.0,
              ),
            ),
            padding: EdgeInsets.all(10.0),
            child: Icon(
              iconData,
              color: AppColorsNew.newGreenButtonColor,
              size: 30.0,
            ),
          ),
        ),
      );
}
