import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';

import 'package:pokerapp/utils/adaptive_sizer.dart';

class CustomAppBar extends AppBar {
  final titleText;
  final subTitleText;
  final context;
  final actionsList;
  CustomAppBar(
      {Key key,
      this.titleText,
      this.subTitleText,
      this.context,
      this.actionsList})
      : super(
          key: key,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leadingWidth: 100.pw,
          leading: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 16.pw),
            child: InkWell(
              child: SvgPicture.asset(
                'assets/images/backarrow.svg',
                color: AppColorsNew.newGreenButtonColor,
                width: 24.pw,
                height: 24.pw,
                fit: BoxFit.contain,
              ),
              borderRadius: BorderRadius.circular(24.pw),
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          title: Column(
            children: [
              Text(
                titleText ?? "",
                style: AppStylesNew.AppBarTitleTextStyle,
                textAlign: TextAlign.center,
              ),
              Visibility(
                visible: subTitleText != null,
                child: Text(
                  subTitleText ?? "",
                  style: AppStyles.titleBarTextStyle.copyWith(
                    fontSize: 10.dp,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          centerTitle: true,
          actions: actionsList ?? [],
        );
}
