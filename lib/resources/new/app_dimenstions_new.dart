import 'package:flutter/cupertino.dart';

class AppDimensionsNew {
  static double bottomSheetRadius = 16.0;

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
}
