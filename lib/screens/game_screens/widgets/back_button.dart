import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';

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
          leadingWidth: 100,
          leading: Padding(
            padding: EdgeInsets.only(left: 16),
            child: InkWell(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    color: AppColorsNew.newGreenButtonColor,
                    size: 13,
                  ),
                  Text(
                    AppStringsNew.BackText,
                    style: AppStylesNew.BackButtonTextStyle,
                  ),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          title: Column(
            children: [
              Text(
                titleText ?? "",
                style: AppStyles.titleBarTextStyle
                    .copyWith(fontSize: 18, color: AppColorsNew.newTextColor),
                textAlign: TextAlign.center,
              ),
              Visibility(
                visible: subTitleText != null,
                child: Text(
                  subTitleText ?? "",
                  style: AppStyles.titleBarTextStyle
                      .copyWith(fontSize: 10, color: Colors.grey),
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
