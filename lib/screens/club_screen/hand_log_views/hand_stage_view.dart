import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_stages.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/models/hand_log_model.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/widgets/card_view.dart';

const sbTextStyle = TextStyle(
  fontFamily: AppAssets.fontFamilyLato,
  color: Colors.blueGrey,
  fontSize: 12.0,
  fontWeight: FontWeight.w600,
);

const bbTextStyle = TextStyle(
  fontFamily: AppAssets.fontFamilyLato,
  color: Colors.blue,
  fontSize: 12.0,
  fontWeight: FontWeight.w600,
);

const betTextStyle = TextStyle(
  fontFamily: AppAssets.fontFamilyLato,
  color: Colors.amber,
  fontSize: 12.0,
  fontWeight: FontWeight.w600,
);

const raiseTextStyle = TextStyle(
  fontFamily: AppAssets.fontFamilyLato,
  color: Colors.redAccent,
  fontSize: 12.0,
  fontWeight: FontWeight.w600,
);

const checkTextStyle = TextStyle(
  fontFamily: AppAssets.fontFamilyLato,
  color: Colors.white,
  fontSize: 12.0,
  fontWeight: FontWeight.w600,
);

const callTextStyle = TextStyle(
  fontFamily: AppAssets.fontFamilyLato,
  color: Colors.lightGreenAccent,
  fontSize: 12.0,
  fontWeight: FontWeight.w600,
);

const foldTextStyle = TextStyle(
  fontFamily: AppAssets.fontFamilyLato,
  color: Colors.white,
  fontSize: 12.0,
  fontWeight: FontWeight.w600,
);

const straddleTextStyle = TextStyle(
  fontFamily: AppAssets.fontFamilyLato,
  color: Colors.cyan,
  fontSize: 12.0,
  fontWeight: FontWeight.w600,
);

class HandStageView extends StatelessWidget {
  final HandLogModelNew handLogModel;
  final GameStages stageEnum;

  HandStageView({this.handLogModel, this.stageEnum});

  @override
  Widget build(BuildContext context) {
    GameActions actions = _getActions(stageEnum);
    String stageName = stagesEnumValues.reverse[stageEnum];
    List<int> stageCards = _getStageCardsList(stageEnum);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
          alignment: Alignment.centerLeft,
          child: Text(
            stageName + ": " + actions.pot.toString(),
            style: const TextStyle(
              fontFamily: AppAssets.fontFamilyLato,
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Card(
          elevation: 5.5,
          color: AppColors.cardBackgroundColor,
          child: ExpansionTile(
            title: Text(
              stageName + ": " + actions.pot.toString(),
              style: const TextStyle(
                fontFamily: AppAssets.fontFamilyLato,
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            initiallyExpanded: false,
            trailing:
                // (_handStageModel.stageCards.length > 1
                //      ? CardsView(
                //    _handStageModel.stageCards,
                //    true,
                //  )
                //      : _handStageModel.stageCards.length != 0
                //      ? CardView(
                //    card: CardHelper.getCard(
                //        _handStageModel.stageCards[0]),
                //  )
                //      : Container()),

                Icon(
              Icons.arrow_drop_down,
              color: AppColors.appAccentColor,
            ),
            children: [
              Visibility(
                visible: (actions.actions != null && stageCards.length > 0),
                child: Container(
                    margin: EdgeInsets.only(
                        left: 10, top: 5, bottom: 10, right: 10),
                    alignment: Alignment.centerLeft,
                    child: stageCards.length > 1
                        ? CardsView(
                            stageCards,
                            true,
                          )
                        : stageCards.length != 0
                            ? CardView(
                                card: CardHelper.getCard(stageCards[0]),
                              )
                            : Container()),
              ),
              Card(
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                color: AppColors.cardBackgroundColor,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              "Player",
                              style: const TextStyle(
                                fontFamily: AppAssets.fontFamilyLato,
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Action",
                              style: const TextStyle(
                                fontFamily: AppAssets.fontFamilyLato,
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Amount",
                              style: const TextStyle(
                                fontFamily: AppAssets.fontFamilyLato,
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Stack",
                              style: const TextStyle(
                                fontFamily: AppAssets.fontFamilyLato,
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: AppColors.listViewDividerColor,
                      indent: 5.0,
                      endIndent: 5.0,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: actions.actions.length,
                        itemBuilder: (context, index) {
                          return actionRow(index, actions);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container actionRow(int index, GameActions actions) {
    var textStyle = TextStyle(
      fontFamily: AppAssets.fontFamilyLato,
      color: Colors.white,
      fontSize: 12.0,
      fontWeight: FontWeight.w600,
    );
    switch (actions.actions[index].action) {
      case HandActions.SB:
        textStyle = sbTextStyle;
        break;
      case HandActions.BB:
        textStyle = bbTextStyle;
        break;
      case HandActions.BET:
        textStyle = betTextStyle;
        break;
      case HandActions.RAISE:
        textStyle = raiseTextStyle;
        break;
      case HandActions.CHECK:
        textStyle = checkTextStyle;
        break;
      case HandActions.CALL:
        textStyle = callTextStyle;
        break;
      case HandActions.FOLD:
        textStyle = foldTextStyle;
        break;
      case HandActions.STRADDLE:
        textStyle = straddleTextStyle;
        break;
      case HandActions.UNKNOWN:
        // TODO: Handle this case.
        textStyle = sbTextStyle;
        break;

      default:
        textStyle = sbTextStyle;
    }

    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              _getPlayerName(actions), // FIXME : need to get player name
              style: const TextStyle(
                fontFamily: AppAssets.fontFamilyLato,
                color: Colors.white,
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              handActionsToString(actions.actions[index].action),
              style: textStyle,
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              actions.actions[index].action != HandActions.CHECK &&
                      actions.actions[index].action != HandActions.FOLD
                  ? actions.actions[index].amount.toString()
                  : "-",
              style: const TextStyle(
                fontFamily: AppAssets.fontFamilyLato,
                color: Colors.white,
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              actions.actions[index].stack.toString(),
              style: const TextStyle(
                fontFamily: AppAssets.fontFamilyLato,
                color: Colors.white,
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
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
        stageCards.addAll(handLogModel.hand.data.flop);
        break;
      case GameStages.TURN:
        stageCards.addAll(handLogModel.hand.data.flop);
        stageCards.add(handLogModel.hand.data.turn);
        break;
      case GameStages.RIVER:
        stageCards.addAll(handLogModel.hand.data.flop);
        stageCards.add(handLogModel.hand.data.turn);
        stageCards.add(handLogModel.hand.data.river);
        break;
      default:
    }
    return stageCards;
  }

  GameActions _getActions(GameStages stage) {
    switch (stage) {
      case GameStages.PREFLOP:
        return handLogModel.hand.data.handLog.preflopActions;
      case GameStages.FLOP:
        return handLogModel.hand.data.handLog.flopActions;

      case GameStages.TURN:
        return handLogModel.hand.data.handLog.turnActions;

      case GameStages.RIVER:
        return handLogModel.hand.data.handLog.riverActions;

      default:
        return null;
    }
  }

  String _getPlayerName(GameActions actions) {
    return "Player";
  }
}
