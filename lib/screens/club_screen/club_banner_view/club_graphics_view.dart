import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_weekly_activity_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/utils/club_weekly_activity_bar_chart.dart';

class ClubGraphicsView extends StatelessWidget {
  final double _unsettledBalance;
  final ClubWeeklyActivityModel _weeklyActivity;

  ClubGraphicsView(this._unsettledBalance, this._weeklyActivity);

  Color getBalanceColor(double number) {
    if (number == null) {
      return Colors.white;
    }

    return number == 0
        ? Colors.white
        : number > 0
            ? AppColors.positiveColor
            : AppColors.negativeColor;
  }

  loadWeeklyActivityData() {}

  @override
  Widget build(BuildContext context) {
    loadWeeklyActivityData();
    return Container(
      margin: EdgeInsets.all(8.0),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Card(
                color: AppColors.cardBackgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Text(
                        "Unsettled",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontFamily: AppAssets.fontFamilyLato,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Text(
                        _unsettledBalance.toString(),
                        style: TextStyle(
                          color: getBalanceColor(_unsettledBalance),
                          fontSize: 14.0,
                          fontFamily: AppAssets.fontFamilyLato,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Card(
                color: AppColors.cardBackgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            Text(
                              "Weekly Activity",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontFamily: AppAssets.fontFamilyLato,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: ClubWeeklyActivityBarChart(_weeklyActivity),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
