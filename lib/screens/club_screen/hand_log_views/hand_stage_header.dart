import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/handlog_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/widgets/cards/multiple_stack_card_views.dart';

class HandStageHeader extends StatelessWidget {
  final String stageName;
  final HandResultData handResult;
  final GameActions actions;

  HandStageHeader({
    this.stageName,
    this.handResult,
    this.actions,
  });

  List<Widget> pots(List<SeatPot> seatPots, AppTheme theme) {
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
        final player = handResult.getPlayerBySeatNo(seat);
        playersInPots.add(player.name);
      }
      String players = playersInPots.join(',');

      final potValue =
          DataFormatter.chipsFormat(seatPots[i].pot);
      final widget = Container(
        margin: EdgeInsets.all(8),
        child: Text(
          "$potName: $potValue",
          style: AppDecorators.getSubtitle1Style(theme: theme),
        ),
      );
      final playerNames = Flexible(
        child: Text(
          "[$players]",
          style: AppDecorators.getSubtitle1Style(theme: theme),
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

  List<int> getBoardCards(int boardNo) {
    List<int> stageCards = [];
    if (boardNo == 2 && handResult.result.boards.length >= 2) {
      stageCards = handResult.result.boards[1].cards;
    } else if (boardNo == 1) {
      stageCards = handResult.result.boards[0].cards;
    } else {
      return [];
    }
    String stageName = this.stageName.toUpperCase();
    if (stageName == 'PREFLOP') {
      stageCards = [];
    } else if (stageName == 'FLOP') {
      stageCards = stageCards.sublist(0, 3);
    } else if (stageName == 'TURN') {
      stageCards = stageCards.sublist(0, 4);
    } else if (stageName == 'RIVER') {
      stageCards = stageCards.sublist(0, 5);
    } else if (stageName == 'SHOWDOWN') {
      stageCards = stageCards.sublist(0, 5);
    } else {
      stageCards = [];
    }
    return stageCards;
  }

  @override
  Widget build(BuildContext context) {
    List<int> stageCards1 = getBoardCards(1);
    List<int> stageCards2 = getBoardCards(2);

    final theme = AppTheme.getTheme(context);
    final stageRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, top: 5, right: 10),
          alignment: Alignment.centerLeft,
          child: Text(
            stageName,
            style: AppDecorators.getHeadLine4Style(theme: theme)
                .copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10, top: 8, bottom: 10, right: 10),
          alignment: Alignment.centerLeft,
          child: Column(children: [
            StackCardView00(
              cards: stageCards1,
              show: true,
              needToShowEmptyCards: true,
            ),
            SizedBox(
              height: 5.dp,
            ),
            stageCards2.length > 0
                ? StackCardView00(
                    cards: stageCards2,
                    show: true,
                    needToShowEmptyCards: true,
                  )
                : Container(),
          ]),
        ),
      ],
    );
    List<Widget> children = [];
    children.add(stageRow);
    List<SeatPot> seatPots = [];
    Color stageColor = theme.preFlopColor;

    if (stageName == 'Flop') {
      stageColor = AppColorsNew.flopColor;
    } else if (stageName == 'Turn') {
      stageColor = AppColorsNew.turnColor;
    } else if (stageName == 'River') {
      stageColor = AppColorsNew.riverColor;
    } else if (stageName == 'Showdown') {
      stageColor = AppColorsNew.showDownColor;
    }

    if (actions != null && actions.seatPots != null) {
      seatPots = actions.seatPots;
    }
    // else if (stageName == 'Showdown') {
    //   seatPots = handLogModel.hand.handLog.seatPotsInShowdown;
    // }
    if (seatPots.length <= 1) {
      final Widget pot = actions != null
          ? Container(
              margin: EdgeInsets.all(8),
              child: Text(
                "Pot: ${DataFormatter.chipsFormat(actions.potStart ?? 0)}",
                style: AppDecorators.getSubtitle1Style(theme: theme)
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            )
          : stageName == "Showdown"
              ? Container(
                  child: _getPotAmountWidget(theme),
                  margin: EdgeInsets.all(8),
                )
              : Container();
      children.add(pot);
    } else {
      final potWidgets = pots(seatPots, theme);
      children.addAll(potWidgets);
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: AppDecorators.tileDecorationWithoutBorder(theme)
          .copyWith(color: stageColor),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children),
    );
  }

  _getPotAmountWidget(AppTheme theme) {
    int length = handResult.result.potWinners.length;
    final potAmount = handResult.result.potWinners[0].amount;
    if (length == 1) {
      return Container(
        child: Text(
          "Pot: $potAmount",
          style: AppDecorators.getSubtitle1Style(theme: theme),
        ),
      );
    }
    if (length > 1) {
      String sidePots = "(";
      for (int i = 1; i < handResult.result.potWinners.length; i++) {
        sidePots += handResult.result.potWinners[i].amount.toString();
        if (i != length - 1) {
          sidePots += ",";
        }
      }
      sidePots += ")";

      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
              child: Text(
            "Pot: $potAmount",
            style: AppDecorators.getSubtitle1Style(theme: theme),
          )),
          Container(
            child: Text(
              "$sidePots",
              style: AppDecorators.getSubtitle1Style(theme: theme),
            ),
          ),
        ],
      );
    }
  }
}
