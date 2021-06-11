import 'package:flutter/material.dart';
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
          leadingWidth: 100.pt,
          leading: Padding(
            padding: EdgeInsets.only(left: 16.pt),
            child: InkWell(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    color: AppColorsNew.newGreenButtonColor,
                    size: 14.pt,
                  ),
                  SizedBox(width: 1.5.pt),
                  Text(
                    AppStringsNew.BackText,
                    style: AppStylesNew.backButtonTextStyle,
                  ),
                ],
              ),
              borderRadius: BorderRadius.circular(8.pt),
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

  // @override
  // Widget build(BuildContext context) {
  //   return AppBar(
  //     centerTitle: true,
  //     backgroundColor: Colors.transparent,
  //     leading:
  //   );
  // }
}
