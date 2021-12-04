import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

int minExtendTime = 10;

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
    // availableTime = 200;
    if (TestService.isTesting) {
      availableTime = 200;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // log('timebank: rebuild timebank widget');
    final theme = AppTheme.getTheme(context);
    final gameState = GameState.getState(context);
    final gameContextObj = context.read<GameContextObject>();
    List<Widget> children = [];

    // if no time left in the bank return empty container
    if (availableTime <= 0) {
      return Container();
    }

    children.add(
      CircleImageButton(
        icon: Icons.access_alarms,
        theme: theme,
        onTap: () async {
          // log('timebank: on timebank clicked');
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
              // log('TimeBank: extend time $extendTime');
              gameContextObj.handActionProtoService.extendTime(
                  mySeat.player.playerId,
                  mySeat.player.seatNo,
                  gameState.handInfo.handNum,
                  extendTime);
            }
          }

          // log('Remaining timebank: ${widget.gameState.gameHiveStore.getTimeBankTime()}');
          setState(() {});
          animate = true;
          setState(() {});
        },
      ),
    );
    if (animate) {
      // log('timebank: animation is added');
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
                    '+' + time.toString(),
                    style: TextStyle(
                      fontSize: 12.dp,
                      color: theme.accentColor,
                      fontWeight: FontWeight.bold,
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
