import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_stages.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/models/hand_log_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/widgets/card_view.dart';

class HandLogView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HandLogViewState();
}

class _HandLogViewState extends State<HandLogView> {
  HandLogModel _handLogModel;
  bool _isLoading = true;
  var handLogjson;

  initState() {
    super.initState();
    loadJsonData();
  }

  loadJsonData() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/sample-data/handlog.json");
    final jsonResult = json.decode(data);
    setState(() {
      _handLogModel = HandLogModel.fromJson(jsonResult);
      _isLoading = false;
    });
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  Widget buildWinnersView() {
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
                    "Pot #" +
                        _handLogModel.potWinners[index].potNumber.toString(),
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

  Widget buildStagesView(HandStageModel _handStageModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
          alignment: Alignment.centerLeft,
          child: Text(
            _handStageModel.stageName +
                ": " +
                _handStageModel.potAmount.toString(),
            style: const TextStyle(
              fontFamily: AppAssets.fontFamilyLato,
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Visibility(
          visible: (_handStageModel.stageCards != null &&
              _handStageModel.stageCards.length > 0),
          child: Container(
            margin: EdgeInsets.only(left: 10, top: 5, bottom: 10, right: 10),
            alignment: Alignment.centerLeft,
            child: CommunityCardWidget(
              _handStageModel.stageCards,
              true,
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
          color: AppColors.cardBackgroundColor,
          child: Container(
            margin: EdgeInsets.all(10),
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _handStageModel.stageActions.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _handStageModel.stageActions[index].name ?? "Player",
                        style: const TextStyle(
                          fontFamily: AppAssets.fontFamilyLato,
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        handActionsToString(
                            _handStageModel.stageActions[index].action),
                        style: const TextStyle(
                          fontFamily: AppAssets.fontFamilyLato,
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _handStageModel.stageActions[index].amount.toString(),
                        style: const TextStyle(
                          fontFamily: AppAssets.fontFamilyLato,
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 14,
            color: AppColors.appAccentColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        elevation: 0.0,
        backgroundColor: AppColors.screenBackgroundColor,
        title: Text(
          "Club",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: AppColors.appAccentColor,
            fontSize: 14.0,
            fontFamily: AppAssets.fontFamilyLato,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: this._isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin:
                        EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Hand Log",
                      style: const TextStyle(
                        fontFamily: AppAssets.fontFamilyLato,
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Card(
                    margin:
                        EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
                    elevation: 5.5,
                    child: Container(
                      color: AppColors.cardBackgroundColor,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  left: 5, top: 5, bottom: 5, right: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Game: " + _handLogModel.gameId,
                                      style: const TextStyle(
                                        fontFamily: AppAssets.fontFamilyLato,
                                        color: Colors.white,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Hand: #" +
                                          _handLogModel.handNumber.toString(),
                                      style: const TextStyle(
                                        fontFamily: AppAssets.fontFamilyLato,
                                        color: Colors.white,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5, bottom: 5),
                                    child: Text(
                                      "Duration: " +
                                          _printDuration(
                                              _handLogModel.handDuration),
                                      style: const TextStyle(
                                        fontFamily: AppAssets.fontFamilyLato,
                                        color: Colors.white,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 5, right: 5, top: 10, bottom: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 5, bottom: 5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(bottom: 5),
                                          child: Text(
                                            "Community Cards",
                                            style: const TextStyle(
                                              fontFamily:
                                                  AppAssets.fontFamilyLato,
                                              color: Colors.white,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        CommunityCardWidget(
                                            _handLogModel.communityCards
                                                .cast<int>()
                                                .toList(),
                                            _handLogModel.gameWonAt ==
                                                GameStages.SHOWDOWN),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5, bottom: 5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(bottom: 5),
                                          child: Text(
                                            "Your Cards",
                                            style: const TextStyle(
                                              fontFamily:
                                                  AppAssets.fontFamilyLato,
                                              color: Colors.white,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        CommunityCardWidget(
                                            _handLogModel.yourcards
                                                .cast<int>()
                                                .toList(),
                                            _handLogModel.gameWonAt ==
                                                GameStages.SHOWDOWN),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Winners",
                      style: const TextStyle(
                        fontFamily: AppAssets.fontFamilyLato,
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Container(
                    child: buildWinnersView(),
                  ),
                  Container(
                    child: buildStagesView(_handLogModel.preFlopActions),
                  ),
                  Container(
                    child: buildStagesView(_handLogModel.flopActions),
                  ),
                  Container(
                    child: buildStagesView(_handLogModel.turnActions),
                  ),
                  Container(
                    child: buildStagesView(_handLogModel.riverActions),
                  ),
                ],
              ),
            ),
    );
  }
}
