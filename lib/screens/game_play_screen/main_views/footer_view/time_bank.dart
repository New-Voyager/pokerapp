import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/game_circle_button.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class TimeBankWidget extends StatefulWidget {
  final int time;
  TimeBankWidget(this.time);

  @override
  _TimeBankWidgetState createState() => _TimeBankWidgetState();
}

class _TimeBankWidgetState extends State<TimeBankWidget> {
  bool animate = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('timebank: rebuild timebank widget');
    final theme = AppTheme.getTheme(context);
    List<Widget> children = [];
    children.add(
      GameCircleButton(
        iconData: Icons.access_alarms,
        onClickHandler: () {
          log('timebank: on timebank clicked');
          animate = false;
          setState(() {});
          animate = true;
          setState(() {});
        },
      ),
    );
    if (animate) {
      log('timebank: animation is added');
      final animation = TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: 1),
        onEnd: () {
          animate = false;
          setState(() {});
        },
        duration: const Duration(milliseconds: 1000),
        builder: (BuildContext context, double v, Widget child) {
          // log('timebank: animating time: value: $v');
          return Opacity(
              opacity: 1 - v,
              child: Transform.translate(
                  offset: Offset(-30.pw, -v * 30.ph),
                  child: Text(
                    '+' + widget.time.toString(),
                    style: TextStyle(
                      fontSize: 16.dp,
                      color: theme.accentColor,
                      fontWeight: FontWeight.w900,
                    ),
                  )));
        },
        child: const Icon(Icons.aspect_ratio),
      );
      children.add(animation);
    }
    return Stack(alignment: Alignment.center, children: children);
  }
}
