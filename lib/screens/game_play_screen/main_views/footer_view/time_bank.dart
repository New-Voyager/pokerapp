import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/game_circle_button.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

int minExtendTime = 5;

class TimeBankWidget extends StatefulWidget {
  final GameState gameState;
  TimeBankWidget(this.gameState);

  @override
  _TimeBankWidgetState createState() => _TimeBankWidgetState();
}

class _TimeBankWidgetState extends State<TimeBankWidget> {
  bool animate = false;
  int time = 0;
  int availableTime;
  _TimeBankWidgetState();
  @override
  void initState() {
    availableTime = widget.gameState.gameHiveStore.getTimeBankTime();
    if (TestService.isTesting) {
      availableTime = 20;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('timebank: rebuild timebank widget');
    final theme = AppTheme.getTheme(context);
    final gameState = GameState.getState(context);
    final gameContextObj = context.read<GameContextObject>();
    List<Widget> children = [];

    // if no time left in the bank return empty container
    if (availableTime <= 0) {
      return Container();
    }

    children.add(
      GameCircleButton(
        iconData: Icons.access_alarms,
        onClickHandler: () async {
          log('timebank: on timebank clicked');
          animate = false;
          int extendTime = minExtendTime;
          if (availableTime < extendTime) {
            extendTime =
                availableTime; //widget.gameState.gameHiveStore.getTimeBankTime();
          }
          time += extendTime;
          await widget.gameState.gameHiveStore
              .deductTimebank(num: minExtendTime);
          availableTime -= extendTime;

          // my seat
          final mySeat = gameState.mySeat;
          if (mySeat != null) {
            if (!TestService.isTesting) {
              log('TimeBank: extend time $extendTime');
              gameContextObj.handActionProtoService.extendTime(
                  mySeat.player.playerId,
                  mySeat.serverSeatPos,
                  gameState.handInfo.handNum,
                  extendTime);
            }
            int total = mySeat.actionTimer.getTotalTime() + extendTime;
            int remainingTime =
                mySeat.actionTimer.getProgressTime() + extendTime;
            mySeat.actionTimer.setTime(total, remainingTime);
            mySeat.notify();
          }

          log('Remaining timebank: ${widget.gameState.gameHiveStore.getTimeBankTime()}');
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
        duration: const Duration(milliseconds: 2000),
        builder: (BuildContext context, double v, Widget child) {
          // log('timebank: animating time: value: $v');
          return Opacity(
              opacity: 1 - v,
              child: Transform.translate(
                  offset: Offset(-50.pw, -v * 60.ph),
                  child: Text(
                    '+' + time.toString(),
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