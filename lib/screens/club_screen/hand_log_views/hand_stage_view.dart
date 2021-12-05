import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_stages.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/handlog_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/hand_stage_header.dart';
import 'package:pokerapp/utils/formatter.dart';

class HandStageView extends StatelessWidget {
  final HandResultData handResult;
  final GameStages stageEnum;
  final bool shown;
  String stageName;
  AppTextScreen _appScreenText;

  HandStageView({this.handResult, this.stageEnum, this.shown});

  @override
  Widget build(BuildContext context) {
    _appScreenText = getAppTextScreen("handStageView");

    GameActions actions = _getActions(stageEnum);
    final theme = AppTheme.getTheme(context);
    // String stageName = _getStageName(stageEnum);
    // List<int> stageCards = _getStageCardsList(stageEnum);

    // This check will hide this stage.
    return (actions != null && actions.actions.length > 0)
        ? Column(
            children: [
              HandStageHeader(
                stageName: stageName,
                handResult: handResult,
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
                          return actionRow(index, actions, theme);
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: theme.fillInColor,
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

  Container actionRow(int index, GameActions actions, AppTheme theme) {
    TextStyle textStyle = AppDecorators.getSubtitle1Style(theme: theme);
    var sbTextStyle = textStyle.copyWith(
      color: Colors.blueGrey,
    );
    var bbTextStyle = textStyle.copyWith(
      color: Colors.blue,
    );
    var betTextStyle = textStyle.copyWith(
      color: Colors.redAccent,
    );

    var raiseTextStyle = textStyle.copyWith(
      color: Colors.redAccent,
    );

    var checkTextStyle = textStyle.copyWith(
      color: Colors.white,
    );
    var callTextStyle = textStyle.copyWith(
      color: Colors.lightGreenAccent,
    );

    var foldTextStyle = textStyle.copyWith(
      color: Colors.blueGrey,
    );

    var straddleTextStyle = textStyle.copyWith(
      color: Colors.cyan,
    );
    var allinTextStyle = textStyle.copyWith(
      color: Colors.yellowAccent,
    );

    String action = "";
    //log('action: ${actions.actions[index].action.toString()}');
    switch (actions.actions[index].action) {
      case HandActions.SB:
        textStyle = sbTextStyle;
        action = _appScreenText["SB"];
        break;
      case HandActions.BB:
        textStyle = bbTextStyle;
        action = _appScreenText["BB"];
        break;
      case HandActions.BET:
        textStyle = betTextStyle;
        action = _appScreenText["BET"];
        break;
      case HandActions.RAISE:
        textStyle = raiseTextStyle;
        action = _appScreenText["RAISE"];
        break;
      case HandActions.CHECK:
        textStyle = checkTextStyle;
        action = _appScreenText["CHECK"];
        break;
      case HandActions.CALL:
        textStyle = callTextStyle;
        action = _appScreenText["CALL"];
        break;
      case HandActions.FOLD:
        textStyle = foldTextStyle;
        action = _appScreenText["FOLD"];
        break;
      case HandActions.STRADDLE:
        textStyle = straddleTextStyle;
        action = _appScreenText["STRADDLE"];
        break;
      case HandActions.ALLIN:
        textStyle = allinTextStyle;
        action = _appScreenText["ALLIN"];
        break;
      // case HandActions.UNKNOWN:
      //   // TODO: Handle this case.
      //   textStyle = sbTextStyle;
      //   break;

      default:
        textStyle = sbTextStyle;
        action = "";
    }
    final player = handResult.getPlayerBySeatNo(actions.actions[index].seatNo);
    return Container(
      decoration: AppDecorators.tileDecorationWithoutBorder(theme),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              player.name,
              style: AppDecorators.getSubtitle1Style(theme: theme),
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
                  ? DataFormatter.chipsFormat(actions.actions[index].amount)
                  : "",
              style: AppDecorators.getSubtitle1Style(theme: theme),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              DataFormatter.chipsFormat(actions.actions[index].stack),
              style: AppDecorators.getSubtitle1Style(theme: theme),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  GameActions _getActions(GameStages stage) {
    switch (stage) {
      case GameStages.PREFLOP:
        stageName = _appScreenText["PREFLOP"];
        return handResult.preflopActions;

      case GameStages.FLOP:
        stageName = _appScreenText["FLOP"];
        return handResult.flopActions;

      case GameStages.TURN:
        stageName = _appScreenText["TURN"];
        return handResult.turnActions;

      case GameStages.RIVER:
        stageName = _appScreenText["RIVER"];
        return handResult.riverActions;

      case GameStages.SHOWDOWN:
        stageName = _appScreenText["SHOWDOWN"];
        return null;

      default:
        return null;
    }
  }
}
