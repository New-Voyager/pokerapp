import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_stages.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/widgets/cards/multiple_stack_card_views.dart';

class HandWinnersView extends StatelessWidget {
  final HandLogModelNew handLogModel;
  final List<PotWinner> potWinnersList = [];
  final List<String> potNumbers = [];
  final bool chatWidget;

  HandWinnersView({this.handLogModel, this.chatWidget});

  @override
  Widget build(BuildContext context) {
    _getPotWinnersList(handLogModel);

    if (potWinnersList == null || potWinnersList.length == 0) {
      return Center(
        child: Text(
          "No winner details found",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14.0,
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
        margin: EdgeInsets.only(bottom: 4, left: 8, right: 8),
        child: Container(
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) => SizedBox(
              height: 8,
            ),
            itemCount: potWinnersList.length,
            itemBuilder: (context, index) {
              String potStr = "Pot:";
              if (index == 0 && potWinnersList.length > 1) {
                potStr = "Main Pot:";
              }
              return Container(
                decoration: AppStylesNew.actionRowDecoration,
                padding: EdgeInsets.only(bottom: 16, top: 8, left: 4),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      alignment: Alignment.centerRight,
                      child: Text(
                        "$potStr " + potWinnersList[index].amount.toString(),
                        style: AppStylesNew.stageNameTextStyle,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        winnersTitle,
                        style: const TextStyle(
                          color: AppColorsNew.newTextGreenColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    Divider(
                      color: AppColorsNew.veryLightGrayColor,
                      endIndent: 200,
                      indent: 8,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 8, bottom: 16),
                      // alignment: Alignment.centerRight,
                      child: Container(
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: potWinnersList[index].hiWinners.length,
                          shrinkWrap: true,
                          itemBuilder: (context, winnerIndex) {
                            return Container(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      getPlayerNameBySeatNo(
                                          handLogModel: handLogModel,
                                          seatNo: potWinnersList[index]
                                              .hiWinners[winnerIndex]
                                              .seatNo),
                                      style: AppStylesNew.playerNameTextStyle,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  chatWidget ?? false
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            StackCardView01(
                                              totalCards: handLogModel
                                                  .getPlayerBySeatNo(
                                                      potWinnersList[index]
                                                          .hiWinners[
                                                              winnerIndex]
                                                          .seatNo)
                                                  .cards,
                                              cardsToHighlight:
                                                  potWinnersList[index]
                                                      .hiWinners[winnerIndex]
                                                      .playerCards,
                                              show: handLogModel
                                                      .hand.handLog.wonAt ==
                                                  GameStages.SHOWDOWN,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  bottom: 4, top: 8),
                                              child: Text(
                                                "Community Cards",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                            ),
                                            StackCardView01(
                                              totalCards: subCards >= 5
                                                  ? handLogModel.hand.boardCards
                                                  : handLogModel.hand.boardCards
                                                      .sublist(0, subCards),
                                              needToShowEmptyCards: true,
                                              cardsToHighlight: subCards == 6
                                                  ? potWinnersList[index]
                                                      .hiWinners[winnerIndex]
                                                      .winningCards
                                                  : handLogModel
                                                      .hand.boardCards,
                                              show: true,
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            StackCardView01(
                                              totalCards: handLogModel
                                                  .getPlayerBySeatNo(
                                                      potWinnersList[index]
                                                          .hiWinners[
                                                              winnerIndex]
                                                          .seatNo)
                                                  .cards,
                                              cardsToHighlight:
                                                  potWinnersList[index]
                                                      .hiWinners[winnerIndex]
                                                      .playerCards,
                                              show: handLogModel
                                                      .hand.handLog.wonAt ==
                                                  GameStages.SHOWDOWN,
                                            ),
                                            StackCardView01(
                                              totalCards: subCards >= 5
                                                  ? handLogModel.hand.boardCards
                                                  : handLogModel.hand.boardCards
                                                      .sublist(0, subCards),
                                              needToShowEmptyCards: true,
                                              cardsToHighlight: subCards == 6
                                                  ? potWinnersList[index]
                                                      .hiWinners[winnerIndex]
                                                      .winningCards
                                                  : handLogModel
                                                      .hand.boardCards,
                                              show: true,
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: potWinnersList[index].lowWinners.length > 0,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lo-Winners",
                              style: const TextStyle(
                                fontFamily: AppAssets.fontFamilyLato,
                                color: Colors.green,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Divider(
                              color: AppColorsNew.veryLightGrayColor,
                              endIndent: 50,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount:
                                      potWinnersList[index].lowWinners.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, winnerIndex) {
                                    return Container(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(bottom: 5),
                                            child: Text(
                                              getPlayerNameBySeatNo(
                                                handLogModel: handLogModel,
                                                seatNo: potWinnersList[index]
                                                    .lowWinners[winnerIndex]
                                                    .seatNo,
                                              ),
                                              style: const TextStyle(
                                                fontFamily:
                                                    AppAssets.fontFamilyLato,
                                                color: Colors.white,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          chatWidget ?? false
                                              ? Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // CardsView(
                                                    // cards: _handLogModel
                                                    //     .hand
                                                    //     .players[potWinnersList[
                                                    //             index]
                                                    //         .lowWinners[winnerIndex]
                                                    //         .seatNo
                                                    //         .toString()]
                                                    //     .cards,
                                                    //   show: _handLogModel
                                                    //           .hand.handLog.wonAt ==
                                                    //       GameStages.SHOWDOWN,
                                                    // ),
                                                    StackCardView01(
                                                      totalCards: handLogModel
                                                          .getPlayerBySeatNo(
                                                              potWinnersList[
                                                                      index]
                                                                  .lowWinners[
                                                                      winnerIndex]
                                                                  .seatNo)
                                                          .cards,
                                                      cardsToHighlight:
                                                          potWinnersList[index]
                                                              .lowWinners[
                                                                  winnerIndex]
                                                              .playerCards,
                                                      show: handLogModel.hand
                                                              .handLog.wonAt ==
                                                          GameStages.SHOWDOWN,
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 4, top: 8),
                                                      child: Text(
                                                        "Community Cards",
                                                        style: TextStyle(
                                                            fontFamily: AppAssets
                                                                .fontFamilyLato,
                                                            color: Colors.white,
                                                            fontSize: 12),
                                                      ),
                                                    ),

                                                    StackCardView01(
                                                      totalCards: subCards >= 5
                                                          ? handLogModel
                                                              .hand.boardCards
                                                          : handLogModel
                                                              .hand.boardCards
                                                              .sublist(
                                                                  0, subCards),
                                                      needToShowEmptyCards:
                                                          true,
                                                      cardsToHighlight:
                                                          subCards == 6
                                                              ? potWinnersList[
                                                                      index]
                                                                  .lowWinners[
                                                                      winnerIndex]
                                                                  .winningCards
                                                              : handLogModel
                                                                  .hand
                                                                  .boardCards,
                                                      show: true,
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    // CardsView(
                                                    // cards: _handLogModel
                                                    //     .hand
                                                    //     .players[potWinnersList[
                                                    //             index]
                                                    //         .lowWinners[winnerIndex]
                                                    //         .seatNo
                                                    //         .toString()]
                                                    //     .cards,
                                                    //   show: _handLogModel
                                                    //           .hand.handLog.wonAt ==
                                                    //       GameStages.SHOWDOWN,
                                                    // ),
                                                    StackCardView01(
                                                      totalCards: handLogModel
                                                          .getPlayerBySeatNo(
                                                              potWinnersList[
                                                                      index]
                                                                  .lowWinners[
                                                                      winnerIndex]
                                                                  .seatNo)
                                                          .cards,
                                                      cardsToHighlight:
                                                          potWinnersList[index]
                                                              .lowWinners[
                                                                  winnerIndex]
                                                              .playerCards,
                                                      show: handLogModel.hand
                                                              .handLog.wonAt ==
                                                          GameStages.SHOWDOWN,
                                                    ),
                                                    StackCardView01(
                                                      totalCards: subCards >= 5
                                                          ? handLogModel
                                                              .hand.boardCards
                                                          : handLogModel
                                                              .hand.boardCards
                                                              .sublist(
                                                                  0, subCards),
                                                      needToShowEmptyCards:
                                                          true,
                                                      cardsToHighlight:
                                                          subCards == 6
                                                              ? potWinnersList[
                                                                      index]
                                                                  .lowWinners[
                                                                      winnerIndex]
                                                                  .winningCards
                                                              : handLogModel
                                                                  .hand
                                                                  .boardCards,
                                                      show: true,
                                                    ),
                                                  ],
                                                ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
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

  List<PotWinner> _getPotWinnersList(HandLogModelNew handLogModel) {
    final List<String> numbers =
        handLogModel.hand.handLog.potWinners.keys.toList();

    numbers?.forEach((element) {
      potWinnersList.add(handLogModel.hand.handLog.potWinners[element]);
      potNumbers.add(element.toString());
    });
    return potWinnersList;
  }
}
