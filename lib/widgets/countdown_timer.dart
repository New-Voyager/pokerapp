import 'dart:developer';

import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

class CountDownTimerInSecondsWidget extends StatefulWidget {
  final DateTime endTime;
  final int fontSize;
  final int blinkSecs;

  CountDownTimerInSecondsWidget(this.endTime,
      {this.fontSize = 14, this.blinkSecs = 5});

  @override
  State<CountDownTimerInSecondsWidget> createState() =>
      _CountDownTimerInSecondsWidgetState();
}

class _CountDownTimerInSecondsWidgetState
    extends State<CountDownTimerInSecondsWidget> {
  @override
  Widget build(BuildContext context) {
    return CountdownTimer(
        endTime: widget.endTime.millisecondsSinceEpoch,
        widgetBuilder: (_, CurrentRemainingTime time) {
          Widget ret = Container();
          if (time != null) {
            if (time.sec <= widget.blinkSecs) {
              ret = Container(
                  key: UniqueKey(),
                  child: BlinkText(
                      printDuration(Duration(seconds: time.sec.toInt())),
                      style: AppStylesNew.itemInfoTextStyle.copyWith(
                        fontSize: widget.fontSize.dp,
                        color: Colors.white,
                      ),
                      beginColor: Colors.white,
                      endColor: Colors.orange,
                      times: time.sec.toInt(),
                      duration: Duration(seconds: 1)));
            } else {
              ret = Container(
                  key: UniqueKey(),
                  child: Text(
                    printDuration(Duration(seconds: time.sec.toInt())),
                    style: AppStylesNew.itemInfoTextStyle.copyWith(
                      fontSize: widget.fontSize.dp,
                      color: Colors.white,
                    ),
                  ));
            }
          }
          return ret;
        });
  }
}
