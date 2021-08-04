import 'package:flutter/material.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:timer_count_down/timer_count_down.dart';

const kTimerEnoughTimeLeftColor = const Color(0xff14e81b);
const kTimerRunningLateColor = Colors.yellow;
const kTimerAlmostFinishColor = Colors.red;

class CountDownTimer extends StatelessWidget {
  final int remainingTime;

  CountDownTimer({
    @required this.remainingTime,
  });

  @override
  Widget build(BuildContext context) {
    return Countdown(
      seconds: remainingTime,
      build: (_, time) {
        double percentageLeft = time / remainingTime;
        String text = time.toStringAsFixed(0);
        return Stack(
          alignment: Alignment.center,
          children: [
            Theme(
              data: ThemeData(
                accentColor: percentageLeft < 0.30
                    ? kTimerAlmostFinishColor
                    : percentageLeft < 0.60
                        ? kTimerRunningLateColor
                        : kTimerEnoughTimeLeftColor,
              ),
              child: CircularProgressIndicator(
                backgroundColor: const Color(0xff474747),
                strokeWidth: 2.0,
                value: percentageLeft,
              ),
            ),
            Container(
              height: 35.0,
              width: 35.0,
              padding: EdgeInsets.all(text.length >= 3 ? 5.0 : 10.0),
              decoration: BoxDecoration(
                color: const Color(0xff474747),
                shape: BoxShape.circle,
              ),
              child: FittedBox(
                child: Text(
                  text,
                  style: AppStylesNew.itemInfoTextStyle.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
