import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_stages.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/hand_stage_header.dart';
import 'package:pokerapp/screens/util_screens/util.dart';

const sbTextStyle = TextStyle(
  fontFamily: AppAssets.fontFamilyLato,
  color: Colors.blueGrey,
  fontSize: 12.0,
  fontWeight: FontWeight.w500,
);

const bbTextStyle = TextStyle(
  fontFamily: AppAssets.fontFamilyLato,
  color: Colors.blue,
  fontSize: 12.0,
  fontWeight: FontWeight.w500,
);

const betTextStyle = TextStyle(
  fontFamily: AppAssets.fontFamilyLato,
  color: Colors.redAccent,
  fontSize: 12.0,
  fontWeight: FontWeight.w500,
);

const raiseTextStyle = TextStyle(
  fontFamily: AppAssets.fontFamilyLato,
  color: Colors.redAccent,
  fontSize: 12.0,
  fontWeight: FontWeight.w500,
);

const checkTextStyle = TextStyle(
  fontFamily: AppAssets.fontFamilyLato,
  color: Colors.white,
  fontSize: 12.0,
  fontWeight: FontWeight.w500,
);

const callTextStyle = TextStyle(
  color: Colors.lightGreenAccent,
  fontSize: 12.0,
  fontWeight: FontWeight.w500,
);

const foldTextStyle = TextStyle(
  color: Colors.blueGrey,
  fontSize: 12.0,
  fontWeight: FontWeight.w500,
);

const straddleTextStyle = TextStyle(
  color: Colors.cyan,
  fontSize: 12.0,
  fontWeight: FontWeight.w500,
);

const allinTextStyle = TextStyle(
  color: Colors.yellowAccent,
  fontSize: 12.0,
  fontWeight: FontWeight.w500,
);

class HandStageView extends StatelessWidget {
  final HandLogModelNew handLogModel;
  final GameStages stageEnum;
  final bool shown;
  String stageName;

  HandStageView({this.handLogModel, this.stageEnum, this.shown});

  @override
  Widget build(BuildContext context) {
    GameActions actions = _getActions(stageEnum);
    // String stageName = _getStageName(stageEnum);
    List<int> stageCards = _getStageCardsList(stageEnum);

    // This check will hide this stage.
    return (actions != null && actions.actions.length > 0)
        ? Column(
            children: [
              HandStageHeader(
                stageName: stageName,
                handLogModel: handLogModel,
                stageCards: stageCards,
                actions: actions,
              ),
              Container(
                // padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      padding: EdgeInsets.symmetric(horizontal: 8),
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
                            height: 1,
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
    var textStyle = TextStyle(
      color: Colors.white,
      fontSize: 12.0,
      fontWeight: FontWeight.w600,
    );

    String action = "";
    //log('action: ${actions.actions[index].action.toString()}');
    switch (actions.actions[index].action) {
      case HandActions.SB:
        textStyle = sbTextStyle;
        action = "SB";
        break;
      case HandActions.BB:
        textStyle = bbTextStyle;
        action = "BB";
        break;
      case HandActions.BET:
        textStyle = betTextStyle;
        action = "Bet";
        break;
      case HandActions.RAISE:
        textStyle = raiseTextStyle;
        action = "Raise";
        break;
      case HandActions.CHECK:
        textStyle = checkTextStyle;
        action = "Check";
        break;
      case HandActions.CALL:
        textStyle = callTextStyle;
        action = "Call";
        break;
      case HandActions.FOLD:
        textStyle = foldTextStyle;
        action = "Fold";
        break;
      case HandActions.STRADDLE:
        textStyle = straddleTextStyle;
        action = "Straddle";
        break;
      case HandActions.ALLIN:
        textStyle = allinTextStyle;
        action = "All-in";
        break;
      // case HandActions.UNKNOWN:
      //   // TODO: Handle this case.
      //   textStyle = sbTextStyle;
      //   break;

      default:
        textStyle = sbTextStyle;
        action = "";
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColorsNew.actionRowBgColor,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Expanded(
            flex: 2,
            child: Text(
              action,
              style: textStyle,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              actions.actions[index].action != HandActions.CHECK &&
                      actions.actions[index].action != HandActions.FOLD
                  ? actions.actions[index].amount.toString()
                  : "",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              actions.actions[index].stack.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.0,
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
        stageName = "Preflop";
        return handLogModel.hand.handLog.preflopActions;
      case GameStages.FLOP:
        stageName = "Flop";

        return handLogModel.hand.handLog.flopActions;

      case GameStages.TURN:
        stageName = "Turn";

        return handLogModel.hand.handLog.turnActions;

      case GameStages.RIVER:
        stageName = "River";

        return handLogModel.hand.handLog.riverActions;
      case GameStages.SHOWDOWN:
        stageName = "Showdown";

        return null;

      default:
        return null;
    }
  }
}
