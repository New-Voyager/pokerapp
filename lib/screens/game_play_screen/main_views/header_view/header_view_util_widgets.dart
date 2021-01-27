import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:provider/provider.dart';

class HeaderViewUtilWidgets {
  HeaderViewUtilWidgets._();
  static Widget buildText(String text, {bool whiteColor = true}) => Container(
        margin: EdgeInsets.only(bottom: 5.0),
        child: Text(
          text,
          style: whiteColor
              ? AppStyles.gamePlayScreenHeaderTextStyle1
              : AppStyles.gamePlayScreenHeaderTextStyle2,
        ),
      );
}
