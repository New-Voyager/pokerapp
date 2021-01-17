import 'package:flutter/material.dart';
import 'package:pokerapp/models/hand_log_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/widgets/card_view.dart';

class HandWinnersView extends StatelessWidget {
  final HandLogModel _handLogModel;

  HandWinnersView(this._handLogModel);

  @override
  Widget build(BuildContext context) {
    if (_handLogModel.potWinners == null) {
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
        margin: EdgeInsets.all(5),
        child: Container(
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _handLogModel.potWinners.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 5.5,
                color: AppColors.cardBackgroundColor,
                child: ExpansionTile(
                  title: Text(
                    _handLogModel.potWinners[index].potNumberStr,
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
                            margin: EdgeInsets.all(5),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Pot: " +
                                  _handLogModel.potWinners[index].totalPotAmount
                                      .toString(),
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
                                itemCount: _handLogModel
                                    .potWinners[index].hiWinners.length,
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
                                              bottom: 5, top: 5),
                                          child: Text(
                                            _handLogModel.potWinners[index]
                                                .hiWinners[winnerIndex].name,
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
                                              _handLogModel
                                                  .potWinners[index]
                                                  .hiWinners[winnerIndex]
                                                  .winningCards
                                                  .cast<int>()
                                                  .toList(),
                                              true,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Text(
                                                "Received: " +
                                                    _handLogModel
                                                        .potWinners[index]
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
                            visible: _handLogModel
                                    .potWinners[index].loWinners.length >
                                0,
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
                                        itemCount: _handLogModel
                                            .potWinners[index].loWinners.length,
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
                                                        .potWinners[index]
                                                        .loWinners[winnerIndex]
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
                                                      _handLogModel
                                                          .potWinners[index]
                                                          .loWinners[
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
                                                            _handLogModel
                                                                .potWinners[
                                                                    index]
                                                                .loWinners[
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
}
