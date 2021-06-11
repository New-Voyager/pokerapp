import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_weekly_activity_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/utils/club_weekly_activity_bar_chart.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class ClubGraphicsViewNew extends StatelessWidget {
  final double _unsettledBalance;
  final ClubWeeklyActivityModel _weeklyActivity;

  ClubGraphicsViewNew(this._unsettledBalance, this._weeklyActivity);

  Color getBalanceColor(double number) {
    if (number == null) {
      return AppColorsNew.newTextColor;
    }

    return number == 0
        ? AppColorsNew.newTextColor
        : number > 0
            ? AppColors.positiveColor
            : AppColors.negativeColor;
  }

  loadWeeklyActivityData() {}

  @override
  Widget build(BuildContext context) {
    loadWeeklyActivityData();
    return Container(
      height: 130.ph,
      margin: EdgeInsets.all(8.0.pw),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.pw),
                color: AppColorsNew.newBackgroundBlackColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(5.pw),
                    padding: EdgeInsets.all(8.pw),
                    child: Text(
                      "Unsettled",
                      style: AppStylesNew.gameActionTextStyle,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5.pw),
                    padding: EdgeInsets.all(8.pw),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _unsettledBalance.toString(),
                      style: TextStyle(
                        color: getBalanceColor(_unsettledBalance),
                        fontSize: 25.0.dp,
                        fontFamily: AppAssetsNew.fontFamilyPoppins,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppDimensionsNew.getHorizontalSpace(8.pw),
          Expanded(
            flex: 7,
            child: Container(
              padding: EdgeInsets.all(8.pw),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.pw),
                color: AppColorsNew.newBackgroundBlackColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(5.pw),
                    child: Column(
                      children: [
                        Text(
                          "Weekly Activity",
                          style: AppStylesNew.gameActionTextStyle,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ClubWeeklyActivityBarChart(_weeklyActivity),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
