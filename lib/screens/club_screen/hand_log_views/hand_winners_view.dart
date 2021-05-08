import 'package:flutter/material.dart';
import 'package:pokerapp/models/hand_log_model.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
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
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Container(
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: potWinnersList.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 5.5,
                color: AppColors.cardBackgroundColor,
                child: ExpansionTile(
                  title: Text(
                    potNumbers[index],
                    style: const TextStyle(
                      fontFamily: AppAssets.fontFamilyLato,
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  initiallyExpanded: (index == 0),
                  trailing: Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.appAccentColor,
                  ),
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Pot: " +
                                  potWinnersList[index].totalAmount.toString(),
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
                                itemCount:
                                    potWinnersList[index].hiWinners.length,
                                shrinkWrap: true,
                                itemBuilder: (context, winnerIndex) {
                                  return Container(
                                    margin: EdgeInsets.only(left: 16),
                                    padding: EdgeInsets.only(bottom: 8),
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 5, top: 5),
                                          child: Text(
                                            _handLogModel.hand.data.players[
                                                    potWinnersList[index]
                                                        .hiWinners[winnerIndex]
                                                        .seatNo] ??
                                                "Unknown",
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
                                                  .hiWinners[winnerIndex]
                                                  .winningCards
                                                  .cast<int>()
                                                  .toList(),
                                              false,
                                            ),
                                            Padding(
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
                            visible:
                                potWinnersList[index].lowWinners.length > 0,
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
                                        itemCount: potWinnersList[index]
                                            .lowWinners
                                            .length,
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
                                                      fontFamily: AppAssets
                                                          .fontFamilyLato,
                                                      color: Colors.white,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    CommunityCardWidget(
                                                      potWinnersList[index]
                                                          .lowWinners[
                                                              winnerIndex]
                                                          .winningCards
                                                          .cast<int>()
                                                          .toList(),
                                                      true,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      child: Text(
                                                        "Received: " +
                                                            potWinnersList[
                                                                    index]
                                                                .lowWinners[
                                                                    winnerIndex]
                                                                .amount
                                                                .toString(),
                                                        style: const TextStyle(
                                                          fontFamily: AppAssets
                                                              .fontFamilyLato,
                                                          color: Colors.white,
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
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
        handLogModel.hand.data.handLog.potWinners.keys.toList();

    numbers?.forEach((element) {
      potWinnersList.add(handLogModel.hand.data.handLog.potWinners[element]);
      potNumbers.add(element.toString());
    });
    return potWinnersList;
  }
}
