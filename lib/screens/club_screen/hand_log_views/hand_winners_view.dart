import 'package:flutter/material.dart';
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
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient:
                LinearGradient(colors: [Colors.grey[850], Colors.grey[700]])),
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Container(
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: potWinnersList.length,
            itemBuilder: (context, index) {
              return Container(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Pot: " + potWinnersList[index].amount.toString(),
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
                                      _handLogModel.hand.players[
                                              potWinnersList[index]
                                                  .hiWinners[winnerIndex]
                                                  .seatNo] ??
                                          "Unknown",
                                      style: AppStyles.playerNameTextStyle,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CardsView(
                                        cards: _handLogModel.hand.boardCards,
                                        show: true,
                                      ),
                                      CardsView(
                                        cards: potWinnersList[index]
                                            .hiWinners[winnerIndex]
                                            .winningCards
                                            .cast<int>()
                                            .toList(),
                                        show: _handLogModel
                                                .hand.handLog.showDown ??
                                            false,
                                      ),
                                      /*  Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            "Received: " +
                                                potWinnersList[index]
                                                    .hiWinners[winnerIndex]
                                                    .amount
                                                    .toString(),
                                            style: const TextStyle(
                                              fontFamily:
                                                  AppAssets.fontFamilyLato,
                                              color: Colors.white,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ), */
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
                                "Low Winners",
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
                                              potWinnersList[index]
                                                  .lowWinners[winnerIndex]
                                                  .name,
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
                                              CommunityCardWidget(
                                                potWinnersList[index]
                                                    .lowWinners[winnerIndex]
                                                    .winningCards
                                                    .cast<int>()
                                                    .toList(),
                                                true,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Text(
                                                  "Received: " +
                                                      potWinnersList[index]
                                                          .lowWinners[
                                                              winnerIndex]
                                                          .amount
                                                          .toString(),
                                                  style: const TextStyle(
                                                    fontFamily: AppAssets
                                                        .fontFamilyLato,
                                                    color: Colors.white,
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
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
