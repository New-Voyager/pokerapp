import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_stages.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/hand_stage_header.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

// different colors for different actions
const Color sbColor = Colors.blueGrey;
const Color bbColor = Colors.blue;
const Color betColor = Colors.redAccent;
const Color raiseColor = Colors.redAccent;
const Color checkColor = Colors.white;
const Color foldColor = Colors.blueGrey;
const Color callColor = Colors.lightGreenAccent;
const Color allInColor = Colors.yellowAccent;
const Color straddleColor = Colors.cyan;

class HandStageView extends StatelessWidget {
  final HandLogModelNew handLogModel;
  final GameStages stageEnum;
  final bool shown;

  final ValueNotifier<String> _vnStageName = ValueNotifier<String>(null);

  HandStageView({
    this.handLogModel,
    this.stageEnum,
    this.shown,
  });

  @override
  Widget build(BuildContext context) {
    GameActions actions = _getActions(stageEnum);
    List<int> stageCards = _getStageCardsList(stageEnum);

    // This check will hide this stage.
    return (actions != null && actions.actions.length > 0)
        ? Column(
            children: [
              // hand stage header
              HandStageHeader(
                stageName: _vnStageName.value,
                handLogModel: handLogModel,
                stageCards: stageCards,
                actions: actions,
              ),

              // main body
              Container(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 5.ph),
                      padding: EdgeInsets.symmetric(horizontal: 8.pw),
                      child: ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: actions.actions.length,
                        itemBuilder: (context, index) {
                          return actionRow(index, actions);
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: Colors.transparent,
                            height: 1.ph,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : Container();
  }

  Container actionRow(int index, GameActions actions) {
    TextStyle textStyle;

    final TextStyle baseTextStyle = TextStyle(
      fontFamily: AppAssets.fontFamilyLato,
      fontSize: 9.0.dp,
      fontWeight: FontWeight.w500,
    );

    String action = "";
    switch (actions.actions[index].action) {
      case HandActions.SB:
        textStyle = baseTextStyle.copyWith(color: sbColor);
        action = "SB";
        break;

      case HandActions.BB:
        textStyle = baseTextStyle.copyWith(color: bbColor);
        action = "BB";
        break;

      case HandActions.BET:
        textStyle = baseTextStyle.copyWith(color: betColor);
        action = "Bet";
        break;

      case HandActions.RAISE:
        textStyle = baseTextStyle.copyWith(color: raiseColor);
        action = "Raise";
        break;

      case HandActions.CHECK:
        textStyle = baseTextStyle.copyWith(color: checkColor);
        action = "Check";
        break;

      case HandActions.CALL:
        textStyle = baseTextStyle.copyWith(color: callColor);
        action = "Call";
        break;

      case HandActions.FOLD:
        textStyle = baseTextStyle.copyWith(color: foldColor);
        action = "Fold";
        break;

      case HandActions.STRADDLE:
        textStyle = baseTextStyle.copyWith(color: straddleColor);
        action = "Straddle";
        break;

      case HandActions.ALLIN:
        textStyle = baseTextStyle.copyWith(color: allInColor);
        action = "All-in";
        break;

      default:
        textStyle = textStyle = baseTextStyle;
        action = "";
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColorsNew.actionRowBgColor,
        borderRadius: BorderRadius.circular(5.pw),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 8.pw,
        vertical: 4.ph,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // player name
          Expanded(
            flex: 4,
            child: Text(
              getPlayerNameBySeatNo(
                handLogModel: handLogModel,
                seatNo: actions.actions[index].seatNo,
              ),
              style: AppStylesNew.playerNameTextStyle,
              textAlign: TextAlign.left,
            ),
          ),

          // action
          Expanded(
            flex: 2,
            child: Text(
              action,
              style: textStyle,
              textAlign: TextAlign.center,
            ),
          ),

          // amount
          Expanded(
            flex: 2,
            child: Text(
              actions.actions[index].action != HandActions.CHECK &&
                      actions.actions[index].action != HandActions.FOLD
                  ? actions.actions[index].amount.toString()
                  : "",
              style: TextStyle(
                color: Colors.white,
                fontSize: 9.0.dp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // stack after action
          Expanded(
            flex: 2,
            child: Text(
              actions.actions[index].stack.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 9.0.dp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  List<int> _getStageCardsList(GameStages stage) {
    List<int> stageCards = [];
    switch (stage) {
      case GameStages.PREFLOP:
        break;
      case GameStages.FLOP:
        stageCards.addAll(handLogModel.hand.flop);
        break;
      case GameStages.TURN:
        stageCards.addAll(handLogModel.hand.flop);
        stageCards.add(handLogModel.hand.turn);
        break;
      case GameStages.RIVER:
        stageCards.addAll(handLogModel.hand.flop);
        stageCards.add(handLogModel.hand.turn);
        stageCards.add(handLogModel.hand.river);
        break;
      default:
    }
    return stageCards;
  }

  GameActions _getActions(GameStages stage) {
    switch (stage) {
      case GameStages.PREFLOP:
        _vnStageName.value = 'Preflop';
        return handLogModel.hand.handLog.preflopActions;

      case GameStages.FLOP:
        _vnStageName.value = 'Flop';
        return handLogModel.hand.handLog.flopActions;

      case GameStages.TURN:
        _vnStageName.value = 'Turn';
        return handLogModel.hand.handLog.turnActions;

      case GameStages.RIVER:
        _vnStageName.value = 'River';
        return handLogModel.hand.handLog.riverActions;

      case GameStages.SHOWDOWN:
        _vnStageName.value = 'Showdown';
        return null;

      default:
        return null;
    }
  }
}
