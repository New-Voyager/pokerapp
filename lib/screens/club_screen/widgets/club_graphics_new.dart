import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_weekly_activity_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
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
      height: MediaQuery.of(context).size.height / 5,
      margin: EdgeInsets.all(8.0.pw),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              decoration: AppStylesNew.actionRowDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(5.pw),
                    padding: EdgeInsets.all(8.pw),
                    child: Text(
                      AppStringsNew.unsettledText,
                      style: AppStylesNew.labelTextStyle,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5.pw),
                    padding: EdgeInsets.all(8.pw),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      getBalanceFormatted(_unsettledBalance),
                      style: TextStyle(
                        color: getBalanceColor(_unsettledBalance),
                        fontSize: 24.0.pw,
                        fontFamily: AppAssetsNew.fontFamilyPoppins,
                        fontWeight: FontWeight.w500,
                      ),
                      //maxLines: 1,
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
                           decoration: AppStylesNew.actionRowDecoration,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(5.pw),
                    child: Column(
                      children: [
                        Text(
                          AppStringsNew.weeklyActivity,
                          style: AppStylesNew.labelTextStyle,
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

  String getBalanceFormatted(double bal) {
    if (bal.abs() > 999999999) {
      double val = bal / 1000000000;
      return "${val.toStringAsFixed(1)}B";
    }
    if (bal.abs() > 999999) {
      double val = bal / 1000000;
      return "${val.toStringAsFixed(1)}M";
    }
    if (bal.abs() > 999) {
      double val = bal / 1000;
      return "${val.toStringAsFixed(1)}K";
    }
    return "${bal.toStringAsFixed(1)}";
  }
}
