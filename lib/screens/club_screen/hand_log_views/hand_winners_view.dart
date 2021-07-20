import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_stages.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/widgets/cards/multiple_stack_card_views.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class HandWinnersView extends StatelessWidget {
  final HandLogModelNew handLogModel;
  final List<PotWinner> potWinnersList = [];
  final List<String> potNumbers = [];
  final bool chatWidget;

  HandWinnersView({this.handLogModel, this.chatWidget});

  Widget _buildWinnerItem({
    @required final int index,
    @required final int winnerIndex,
    @required final int subCards,
  }) {
    return Container(
      padding: EdgeInsets.only(left: 8.pw, right: 8.pw),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // player name
          Padding(
            padding: EdgeInsets.only(bottom: 5.ph),
            child: Text(
              getPlayerNameBySeatNo(
                handLogModel: handLogModel,
                seatNo: potWinnersList[index].hiWinners[winnerIndex].seatNo,
              ),
              style: AppStylesNew.playerNameTextStyle,
              textAlign: TextAlign.left,
            ),
          ),

          chatWidget ?? false
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // player cards
                    Transform.scale(
                      scale: 0.90.pw,
                      alignment: Alignment.centerLeft,
                      child: StackCardView01(
                        totalCards: handLogModel
                            .getPlayerBySeatNo(
                              potWinnersList[index]
                                  .hiWinners[winnerIndex]
                                  .seatNo,
                            )
                            .cards,
                        cardsToHighlight: potWinnersList[index]
                            .hiWinners[winnerIndex]
                            .playerCards,
                        show: handLogModel.hand.handLog.wonAt ==
                            GameStages.SHOWDOWN,
                      ),
                    ),

                    // community cards title and cards
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // community cards heading
                        Container(
                          margin: EdgeInsets.only(bottom: 4, top: 8),
                          child: Text(
                            'Community Cards',
                            style:
                                TextStyle(color: Colors.white, fontSize: 8.dp),
                          ),
                        ),

                        // cards
                        Transform.scale(
                          scale: 0.90.pw,
                          alignment: Alignment.centerRight,
                          child: StackCardView01(
                            totalCards: subCards >= 5
                                ? handLogModel.hand.boardCards
                                : handLogModel.hand.boardCards
                                    .sublist(0, subCards),
                            needToShowEmptyCards: true,
                            cardsToHighlight: subCards == 6
                                ? potWinnersList[index]
                                    .hiWinners[winnerIndex]
                                    .winningCards
                                : handLogModel.hand.boardCards,
                            show: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // player cards
                    Transform.scale(
                      scale: 0.90.pw,
                      alignment: Alignment.centerLeft,
                      child: StackCardView01(
                        totalCards: handLogModel
                            .getPlayerBySeatNo(
                              potWinnersList[index]
                                  .hiWinners[winnerIndex]
                                  .seatNo,
                            )
                            .cards,
                        cardsToHighlight: potWinnersList[index]
                            .hiWinners[winnerIndex]
                            .playerCards,
                        show: handLogModel.hand.handLog.wonAt ==
                            GameStages.SHOWDOWN,
                      ),
                    ),

                    // community cards
                    Transform.scale(
                      scale: 0.90.pw,
                      alignment: Alignment.centerRight,
                      child: StackCardView01(
                        totalCards: subCards >= 5
                            ? handLogModel.hand.boardCards
                            : handLogModel.hand.boardCards.sublist(0, subCards),
                        needToShowEmptyCards: true,
                        cardsToHighlight: subCards == 6
                            ? potWinnersList[index]
                                .hiWinners[winnerIndex]
                                .winningCards
                            : handLogModel.hand.boardCards,
                        show: true,
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildWinners(int index, int subCards, List<WinnerPlayer> winner) {
    return Container(
      margin: EdgeInsets.only(left: 8.pw, bottom: 16.ph),
      alignment: Alignment.centerLeft,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: winner.length,
        shrinkWrap: true,
        itemBuilder: (context, winnerIndex) {
          return _buildWinnerItem(
            index: index,
            winnerIndex: winnerIndex,
            subCards: subCards,
          );
        },
      ),
    );
  }

  Widget _buildSeperator() => // seperator - divider
      Divider(
        color: AppColors.veryLightGrayColor,
        endIndent: 180.pw,
        indent: 8.pw,
      );

  Widget _buildTitleText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: AppColorsNew.newTextGreenColor,
        fontSize: 9.5.dp,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _populatePotWinners(handLogModel);

    if (potWinnersList == null || potWinnersList.length == 0) {
      return Center(
        child: Text(
          'No winner details found',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.0.dp,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    } else {
      String winnersTitle = 'Winners';
      for (final potWinner in potWinnersList) {
        if (potWinner.lowWinners.length > 0) {
          winnersTitle = 'Hi-Winners';
          break;
        }
      }

      int subCards = 0;
      GameStages stageAtWon = handLogModel.hand.handLog.wonAt;

      if (stageAtWon == GameStages.PREFLOP) {
        subCards = 0;
      } else if (stageAtWon == GameStages.FLOP) {
        subCards = 3;
      } else if (stageAtWon == GameStages.TURN) {
        subCards = 4;
      } else if (stageAtWon == GameStages.RIVER) {
        subCards = 5;
      } else if (stageAtWon == GameStages.SHOWDOWN) {
        subCards = 6;
      }

      return Container(
        margin: EdgeInsets.only(bottom: 4.ph, left: 8.pw, right: 8.pw),
        child: Container(
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) => SizedBox(
              height: 8.ph,
            ),
            itemCount: potWinnersList.length,
            itemBuilder: (context, index) {
              String potStr = "Pot:";
              if (index == 0 && potWinnersList.length > 1) {
                potStr = "Main Pot:";
              }
              return Container(
                decoration: AppStylesNew.gradientBoxDecoration,
                padding: EdgeInsets.only(bottom: 16.ph, top: 8.ph),
                child: Column(
                  children: [
                    // show pot
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.pw),
                      alignment: Alignment.centerRight,
                      child: Text(
                        '$potStr ${potWinnersList[index].amount.toString()}',
                        style: AppStylesNew.stageNameTextStyle,
                      ),
                    ),

                    // show the title string
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.pw),
                      alignment: Alignment.centerLeft,
                      child: _buildTitleText(winnersTitle),
                    ),

                    // seperator - divider
                    _buildSeperator(),

                    // main winners list
                    _buildWinners(
                      index,
                      subCards,
                      potWinnersList[index].hiWinners,
                    ),

                    Visibility(
                      visible: potWinnersList[index].lowWinners.length > 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // low winner title text
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 8.pw),
                            alignment: Alignment.centerLeft,
                            child: _buildTitleText('Lo-Winners'),
                          ),

                          // divider
                          _buildSeperator(),

                          // main winners list
                          _buildWinners(
                            index,
                            subCards,
                            potWinnersList[index].lowWinners,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    }
  }

  void _populatePotWinners(HandLogModelNew handLogModel) {
    final List<String> numbers =
        handLogModel?.hand?.handLog?.potWinners?.keys?.toList();
    numbers?.forEach((element) {
      potWinnersList.add(handLogModel.hand.handLog.potWinners[element]);
      potNumbers.add(element.toString());
    });
  }
}
