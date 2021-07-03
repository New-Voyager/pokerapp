import 'dart:convert';
import 'dart:developer';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class PlayerPerformanceList {
  List<PlayerPerformance> _performanceList = [];
  PlayerPerformance recentPerf;
  PlayerPerformanceList(List<PlayerPerformance> list) {
    _performanceList = list;
    recentPerf = _performanceList
        .reduce((curr, next) => curr.date.isAfter(next.date) ? curr : next);
    log('recentPerf: $recentPerf');
  }

  factory PlayerPerformanceList.fromJson(var jsonData) {
    List<PlayerPerformance> list = [];
    if (jsonData != null) {
      for (final perf in jsonData) {
        list.add(PlayerPerformance.fromJson(perf));
      }
    }
    return PlayerPerformanceList(list);
  }

  static Future<PlayerPerformanceList> fromSampleData() {
    return rootBundle
        .loadString('assets/sample-data/performance.json')
        .then((data) => PlayerPerformanceList.fromJson(jsonDecode(data)));
  }

  get performanceList => this._performanceList;
}

class PlayerPerformance {
  String dayStr;
  DateTime date;
  double profit;
  charts.Color color;

  PlayerPerformance.fromJson(var jsonData) {
    this.dayStr = '';
    this.date = null;
    final dateStr = jsonData["date"] ?? "";
    if (dateStr.isNotEmpty) {
      DateTime date;
      try {
        date = DateTime.parse(dateStr);
      } catch (err) {
        // split using string
        final toks = dateStr.toString().split('-');
        if (toks.length >= 3) {
          final year = int.parse(toks[0]);
          final mon = int.parse(toks[1]);
          final day = int.parse(toks[2]);
          date = DateTime(year, mon, day);
        }
      }
      if (date != null) {
        this.date = date;
        dayStr = DateFormat('dd-MMM').format(date);
      } else {
        dayStr = '00-xxx';
      }
    }
    this.profit = double.parse(jsonData["profit"].toString()) ?? 0.0;
    this.color = this.profit >= 0
        ? charts.ColorUtil.fromDartColor(Colors.green)
        : charts.ColorUtil.fromDartColor(Colors.red);
  }
}
