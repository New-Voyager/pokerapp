import 'package:flutter/material.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';

class HeaderViewUtilWidgets {
  HeaderViewUtilWidgets._();
  static Widget buildText(String text, {bool whiteColor = true}) => Container(
        margin: EdgeInsets.only(bottom: 5.0),
        child: Text(
          text,
          style: whiteColor
              ? AppStylesNew.gamePlayScreenHeaderTextStyle1
              : AppStylesNew.gamePlayScreenHeaderTextStyle2,
        ),
      );
}
