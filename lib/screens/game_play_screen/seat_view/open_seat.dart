import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_styles.dart';

class OpenSeat extends StatelessWidget {
  final int seatPos;
  final Function(int) onUserTap;
  final bool seatChangeInProgress;
  final bool seatChangeSeat;
  const OpenSeat({
    this.seatPos,
    this.onUserTap,
    this.seatChangeInProgress,
    this.seatChangeSeat,
    Key key,
  }) : super(key: key);

  Widget _openSeat() {
    log('open seat $seatChangeInProgress');
    if (seatChangeInProgress && seatChangeSeat) {
      return Padding(
        padding: const EdgeInsets.all(5),
        child: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 10,
              color: Colors.yellowAccent,
              shadows: [
                Shadow(
                  blurRadius: 7.0,
                  color: Colors.white,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: AnimatedTextKit(repeatForever: true, animatedTexts: [
              FlickerAnimatedText('Open', speed: Duration(milliseconds: 500))
            ])),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(5),

      child: FittedBox(
        child: Text(
          'Open $seatPos',
          style: AppStyles.openSeatTextStyle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        splashColor: Colors.blue,
        onTap: () {
          log('Pressed $seatPos');
          this.onUserTap(seatPos);
        },
        child: Container(
          width: 45.0,
          height: 45.0,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _openSeat(),
              // CircularProgressIndicator(
              //   strokeWidth: 2.0,
              //   valueColor : AlwaysStoppedAnimation(Colors.white),
              // ),
            ],
          ),
          // child: Center(
          //   child: _openSeat(),
          // ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0XFF494444),
            //color: Colors.blue[900],
          ),
        ));
  }
}
