import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';

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

  Widget _openSeat(AppTheme theme) {
    if (seatChangeInProgress && seatChangeSeat) {
      log('open seat $seatChangeInProgress');
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
        child: 
        // AnimatedTextKit(repeatForever: true, animatedTexts: [
        //       FlickerAnimatedText('Open', speed: Duration(milliseconds: 2000))
        //     ]),
        Text(
          'Open',
          style: AppDecorators.getSubtitle1Style(theme: theme),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    return InkWell(
        splashColor: theme.secondaryColor,
        borderRadius: BorderRadius.circular(16),
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
              _openSeat(theme),
            ],
          ),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.primaryColorWithDark(),
              boxShadow: [
                BoxShadow(
                  color: theme.accentColor,
                  blurRadius: 1,
                  spreadRadius: 1,
                  offset: Offset(1, 0),
                ),
              ]
              //color: Colors.blue[900],
              ),
        ));
  }
}
