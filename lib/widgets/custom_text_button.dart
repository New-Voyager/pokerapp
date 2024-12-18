import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:timer_count_down/timer_count_down.dart';

class CustomTextButton extends StatelessWidget {
  CustomTextButton({
    @required this.text,
    @required this.onTap,
    this.split = false,
    this.adaptive = true,
  });

  final bool adaptive;
  final String text;
  final Function onTap;
  final bool split;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap == null ? 0.50 : 1.0,
      child: InkWell(
        onTap: onTap,
        child: Text(
          split ? text?.replaceFirst(" ", "\n") ?? 'Text' : text ?? 'Text',
          textAlign: TextAlign.center,
          style: AppStylesNew.textButtonStyle,
        ),
      ),
    );
  }
}

class RoundRectButton extends StatelessWidget {
  RoundRectButton({
    @required this.text,
    @required this.onTap,
    this.split = false,
    this.adaptive = true,
  });

  final bool adaptive;
  final String text;
  final Function onTap;
  final bool split;

  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.black.withOpacity(0.50),
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              split ? text?.replaceFirst(" ", "\n") ?? 'Text' : text ?? 'Text',
              textAlign: TextAlign.center,
              style: AppStylesNew.textButtonStyle,
            )
          ],
        ),
      ),
    );
  }
}

class CountDownTextButton extends StatelessWidget {
  final int time;
  final String text;
  final Function onTap;
  final Function onTimerExpired;
  final bool split;

  CountDownTextButton({
    @required this.text,
    @required this.onTap,
    @required this.time,
    @required this.onTimerExpired,
    this.split = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonText = CustomTextButton(text: text, onTap: onTap, split: split);
    final countDownText = Countdown(
        seconds: time,
        onFinished: () {
          this.onTimerExpired();
        },
        build: (_, time) {
          if (time <= 10) {
            return BlinkText(printDuration(Duration(seconds: time.toInt())),
                style: AppStylesNew.itemInfoTextStyle.copyWith(
                  color: Colors.white,
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
              ),
            );
          }
        });

    return InkWell(
        onTap: onTap,
        child: Column(
            children: [buttonText, SizedBox(height: 10), countDownText]));
  }
}
