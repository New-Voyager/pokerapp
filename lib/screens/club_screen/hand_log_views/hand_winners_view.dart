import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_stages.dart';
import 'package:pokerapp/models/hand_log_model.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/widgets/card_view.dart';

class HandWinnersView extends StatelessWidget {
  final HandLogModelNew _handLogModel;
  final List<PotWinner> potWinnersList = [];
  final List<String> potNumbers = [];

  HandWinnersView(this._handLogModel);

  @override
  Widget build(BuildContext context) {
    _getPotWinnersList(_handLogModel);
    if (potWinnersList == null || potWinnersList.length == 0) {
      return Center(
        child: Text(
          "No winner details found",
          style: const TextStyle(
            fontFamily: AppAssets.fontFamilyLato,
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

      return Container(
        margin: EdgeInsets.only(bottom: 16, left: 8, right: 8),
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
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                        colors: [Colors.grey[850], Colors.grey[700]])),
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.centerRight,
                      child: Text(
                        "$potStr " + potWinnersList[index].amount.toString(),
                        style: AppStyles.playerNameTextStyle,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        winnersTitle,
                        style: const TextStyle(
                          fontFamily: AppAssets.fontFamilyLato,
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      alignment: Alignment.centerRight,
                      child: Container(
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: potWinnersList[index].hiWinners.length,
                          shrinkWrap: true,
                          itemBuilder: (context, winnerIndex) {
                            return Container(
                              padding: EdgeInsets.only(bottom: 8, left: 8),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 5, top: 5),
                                    child: Text(
                                      _handLogModel.getPlayerNameBySeatNo(
                                          potWinnersList[index]
                                              .hiWinners[winnerIndex]
                                              .seatNo),
                                      style: AppStyles.playerNameTextStyle,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      HighlightedCardsView(
                                        totalCards: _handLogModel
                                            .getPlayerBySeatNo(
                                                potWinnersList[index]
                                                    .hiWinners[winnerIndex]
                                                    .seatNo)
                                            .cards,
                                        cardsToHighlight: potWinnersList[index]
                                            .hiWinners[winnerIndex]
                                            .playerCards,
                                        show:
                                            _handLogModel.hand.handLog.wonAt ==
                                                GameStages.SHOWDOWN,
                                      ),
                                      HighlightedCardsView(
                                        totalCards: potWinnersList[index]
                                            .hiWinners[winnerIndex]
                                            .winningCards,
                                        cardsToHighlight: potWinnersList[index]
                                            .hiWinners[winnerIndex]
                                            .winningCards,
                                        show:
                                            _handLogModel.hand.handLog.wonAt ==
                                                GameStages.SHOWDOWN,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(
                              color: AppColors.listViewDividerColor,
                              indent: 5,
                              endIndent: 5,
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "Lo-Winners",
                                style: const TextStyle(
                                  fontFamily: AppAssets.fontFamilyLato,
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(5),
                              alignment: Alignment.centerRight,
                              child: Container(
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount:
                                      potWinnersList[index].lowWinners.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, winnerIndex) {
                                    return Container(
                                      margin: EdgeInsets.only(left: 20),
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            child: Text(
                                              _handLogModel
                                                  .getPlayerNameBySeatNo(
                                                      potWinnersList[index]
                                                          .lowWinners[
                                                              winnerIndex]
                                                          .seatNo),
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
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                                              HighlightedCardsView(
                                                totalCards: _handLogModel
                                                    .getPlayerBySeatNo(
                                                        potWinnersList[index]
                                                            .lowWinners[
                                                                winnerIndex]
                                                            .seatNo)
                                                    .cards,
                                                cardsToHighlight:
                                                    potWinnersList[index]
                                                        .lowWinners[winnerIndex]
                                                        .playerCards,
                                                show: _handLogModel
                                                        .hand.handLog.wonAt ==
                                                    GameStages.SHOWDOWN,
                                              ),
                                              HighlightedCardsView(
                                                totalCards:
                                                    potWinnersList[index]
                                                        .lowWinners[winnerIndex]
                                                        .winningCards,
                                                cardsToHighlight:
                                                    potWinnersList[index]
                                                        .lowWinners[winnerIndex]
                                                        .winningCards,
                                                show: _handLogModel
                                                        .hand.handLog.wonAt ==
                                                    GameStages.SHOWDOWN,
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
