import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_weekly_activity_model.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class ClubWeeklyActivityBarChart extends StatelessWidget {
  final List<ClubWeeklyActivityModel> _weeklyActivityData;

  ClubWeeklyActivityBarChart(this._weeklyActivityData);

  Widget _buildBuyInGraph(series) {
    return _weeklyActivityData != null
        ? ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => Divider(
              color: Colors.white,
              height: 5,
            ),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _weeklyActivityData.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: MediaQuery.of(context).size.height / 2.3,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_weeklyActivityData[index].dayOfWeek,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Expanded(child: charts.BarChart(series, animate: true)),
                  ],
                ),
              );
            },
          )
        : SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<ClubWeeklyActivityModel, String>> series = [
      charts.Series(
          id: "Financial",
          data: _weeklyActivityData,
          domainFn: (ClubWeeklyActivityModel series, _) => series.dayOfWeek,
          measureFn: (ClubWeeklyActivityModel series, _) => series.buyIn,
          colorFn: (ClubWeeklyActivityModel series, _) => series.color),
    ];

    return _buildBuyInGraph(series);
  }
}
