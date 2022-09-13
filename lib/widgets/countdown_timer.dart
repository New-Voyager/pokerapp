import 'dart:developer';

import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:timer_count_down/timer_count_down.dart';

class CountDownTimerInSecondsWidget extends StatefulWidget {
  final int time;
  final int fontSize;
  final int blinkSecs;

  CountDownTimerInSecondsWidget(this.time,
      {this.fontSize = 14, this.blinkSecs = 5});

  @override
  State<CountDownTimerInSecondsWidget> createState() =>
      _CountDownTimerInSecondsWidgetState();
}

class _CountDownTimerInSecondsWidgetState
    extends State<CountDownTimerInSecondsWidget> {
  @override
  Widget build(BuildContext context) {
    return Countdown(
        seconds: widget.time,
        onFinished: () {},
        build: (_, time) {
          if (time <= widget.blinkSecs) {
            return BlinkText(printDuration(Duration(seconds: time.toInt())),
                style: AppStylesNew.itemInfoTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: widget.fontSize.dp,
                ),
                beginColor: Colors.white,
                endColor: Colors.orange,
                times: time.toInt(),
                duration: Duration(seconds: 1));
          } else {
            return Text(
              printDuration(Duration(seconds: time.toInt())),
              style: AppStylesNew.itemInfoTextStyle.copyWith(
                color: Colors.white,
                fontSize: widget.fontSize.dp,
              ),
            );
          }
        });
  }
}

Widget getCountdown(DateTime expiresAt,
    {Function onFinished, int fontSize = 14}) {
  var remainingDuration = expiresAt?.difference(DateTime.now());
  if (remainingDuration == null || remainingDuration.isNegative) {
    remainingDuration = Duration.zero;
  }
  return Countdown(
      seconds: remainingDuration.inSeconds,
      onFinished: () {
        if (onFinished != null) {
          onFinished();
        }
      },
      build: (_, remainingSec) {
        log('LevelTime: $remainingSec');
        if (remainingSec <= 10) {
          return BlinkText(
              printDuration(Duration(seconds: remainingSec.toInt())),
              style: AppStylesNew.itemInfoTextStyle.copyWith(
                fontSize: fontSize.dp,
                color: Colors.white,
              ),
              beginColor: Colors.white,
              endColor: Colors.orange,
              times: remainingSec.toInt(),
              duration: Duration(seconds: 1));
        } else {
          return Text(
            printDuration(Duration(seconds: remainingSec.toInt())),
            style: AppStylesNew.itemInfoTextStyle.copyWith(
              fontSize: fontSize.dp,
              color: Colors.white,
            ),
          );
        }
      });
}
