import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';

class AppDimensionsNew {
  static double bottomSheetRadius = 16.0;

  static double maxWidth = 600.0;

  static Widget getVerticalSizedBox(double height) {
    return SizedBox(
      height: height,
    );
  }

  static Widget getHorizontalSpace(double width) {
    return SizedBox(
      width: width,
    );
  }

  static getDivider(AppTheme theme) {
    return Divider(
      color: theme.secondaryColorWithLight(),
      height: 2,
      endIndent: 8,
      indent: 8,
    );
  }
}
