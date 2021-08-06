import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/widgets/cards/multiple_stack_card_views.dart';

class HandStageHeader extends StatelessWidget {
  final String stageName;
  final List<int> stageCards;
  final HandLogModelNew handLogModel;
  final GameActions actions;

  HandStageHeader({
    this.stageName,
    this.handLogModel,
    this.stageCards,
    this.actions,
  });

  List<Widget> pots(List<SeatPot> seatPots) {
    List<Widget> children = [];
    for (int i = 0; i < seatPots.length; i++) {
      String potName = '';
      if (i == 0) {
        potName = 'Main';
      } else {
        potName = 'Side Pot ($i)';
      }
      List<String> playersInPots = [];
      for (final seat in seatPots[i].seats) {
        final player = handLogModel.getPlayerBySeatNo(seat);
        playersInPots.add(player.name);
      }
      String players = playersInPots.join(',');

      final potValue = DataFormatter.chipsFormat(seatPots[i].pot);
      final widget = Container(
        margin: EdgeInsets.all(8),
        child: Text(
          "$potName: $potValue",
          style: AppStylesNew.potSizeTextStyle,
        ),
      );
      final playerNames = Flexible(
        child: Text(
          "[$players]",
          style: AppStylesNew.potSizeTextStyle,
          maxLines: 3,
          softWrap: true,
          overflow: TextOverflow.fade,
        ),
      );
      final potWidget = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [widget, playerNames],
      );

      children.add(potWidget);
      children.add(SizedBox(
        height: 5.pw,
      ));
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    log('${handLogModel.hand.handLog.potWinners}');
    final stageRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, top: 5, right: 10),
          alignment: Alignment.centerLeft,
          child: Text(
            stageName,
            style: AppStylesNew.stageNameTextStyle,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10, top: 8, bottom: 10, right: 10),
          alignment: Alignment.centerLeft,
          child: StackCardView00(
            cards: stageCards,
            show: true,
            needToShowEmptyCards: true,
          ),
        ),
      ],
    );
    List<Widget> children = [];
    children.add(stageRow);
    List<SeatPot> seatPots = [];
    Color stageColor = AppColorsNew.handlogPreflopColor;

    if (stageName == 'Flop') {
      stageColor = AppColorsNew.handlogFlopColor;
    } else if (stageName == 'Turn') {
      stageColor = AppColorsNew.handlogTurnColor;
    } else if (stageName == 'River') {
      stageColor = AppColorsNew.handlogRiverColor;
    } else if (stageName == 'Showdown') {
      stageColor = AppColorsNew.handlogShowdownColor;
    }

    if (actions != null && actions.seatPots != null) {
      seatPots = actions.seatPots;
    } else if (stageName == 'Showdown') {
      seatPots = handLogModel.hand.handLog.seatPotsInShowdown;
    }
    if (seatPots.length <= 1) {
      final Widget pot = actions != null
          ? Container(
              margin: EdgeInsets.all(8),
              child: Text(
                "Pot: ${actions.potStart ?? 0}",
                style: AppStylesNew.potSizeTextStyle,
              ),
            )
          : stageName == "Showdown"
              ? Container(
                  child: _getPotAmountWidget(),
                  margin: EdgeInsets.all(8),
                )
              : Container();
      children.add(pot);
    } else {
      final potWidgets = pots(seatPots);
      children.addAll(potWidgets);
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: stageColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children),
    );
  }

  _getPotAmountWidget() {
    int length = handLogModel.hand.handLog.potWinners.length;
    if (length == 1) {
      return Container(
        child: Text(
          "Pot: ${handLogModel.hand.handLog.potWinners['0'].amount}",
          style: AppStylesNew.playerNameTextStyle,
        ),
      );
    }
    if (length > 1) {
      String sidePots = "(";
      handLogModel.hand.handLog.potWinners.forEach((key, value) {
        if (key != "0") {
          sidePots += value.amount.toString();
          if (int.parse(key) < length) {
            sidePots += ",";
          }
        }
      });
      sidePots += ")";
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
              child: Text(
            "Pot: ${handLogModel.hand.handLog.potWinners['0'].amount}",
            style: AppStylesNew.playerNameTextStyle,
          )),
          Container(
            child: Text(
              "$sidePots",
              style: AppStylesNew.playerNameTextStyle,
            ),
          ),
        ],
      );
    }
  }
}
