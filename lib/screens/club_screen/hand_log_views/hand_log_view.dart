import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/enums/game_stages.dart';
import 'package:pokerapp/models/bookmarkedHands_model.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/club_screen/bookmarked_hands.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/hand_log_header_view.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/hand_stage_view.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/hand_winners_view.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/handlog_action.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/handlog_showdown.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/handlog_summary.dart';
import 'package:pokerapp/services/app/hand_service.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/alerts.dart';

class HandLogView extends StatefulWidget {
  final String gameCode;
  bool isAppbarWithHandNumber;
  final String clubCode;
  final int handNum;
  HandLogView(this.gameCode, this.handNum,
      {this.isAppbarWithHandNumber = false, this.clubCode});

  @override
  State<StatefulWidget> createState() => _HandLogViewState();
}

class _HandLogViewState extends State<HandLogView> {
  HandLogModelNew _handLogModel;
  bool _isLoading = true;
  var handLogjson;
  List<BookmarkedHand> list = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchBookmarksForGame(widget.gameCode);
      if (TestService.isTesting) {
        loadJsonData();
      } else {
        _fetchData();
      }
    });
  }

  void _fetchData() async {
    _handLogModel =
        await HandService.getHandLog(widget.gameCode, widget.handNum);
    _isLoading = false;
    setState(() {
      // update ui
    });
  }

  _fetchBookmarksForGame(String gameCode) async {
    list.clear();
    var result = await HandService.getBookmarkedHandsForGame(widget.gameCode);
    BookmarkedHandModel model = BookmarkedHandModel.fromJson(result);

    for (var item in model.bookmarkedHands) {
      list.add(item);
    }
    setState(() {});
  }

  loadJsonData() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/sample-data/handlog/holdem/flop.json");

    final jsonResult = json.decode(data);
    _handLogModel = HandLogModelNew.fromJson(jsonResult);

    setState(() {
      _isLoading = false;
    });
  }

  _removeBookmark(int handnum) async {
    var hand =
        list.firstWhere((element) => element.handNum == handnum, orElse: null);
    if (hand != null) {
      var result = await HandService.removeBookmark(hand.id);
      Alerts.showTextNotification(
        text: result
            ? "Hand " + widget.handNum.toString() + " removed from bookmarks"
            : "Couldn't remove bookmark. Please try again later",
      );
      if (result) {
        await _fetchBookmarksForGame(widget.gameCode);
      }
    } else {
      Alerts.showTextNotification(
        text: "Couldn't remove bookmark. Please try again later",
      );
    }
  }

  bool _isTheHandBookmarked(int handNum) {
    // log("HAND UNDER TEST : $handNum");
    final index = list.indexWhere((element) => element.handNum == handNum);
    if (index < 0) return false;
    return true;
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
          widget.isAppbarWithHandNumber
              ? "Hand Log #" + widget.handNum.toString()
              : "Last Hand Log",
          style: AppStyles.titleBarTextStyle,
        ),
      ),
      body: this._isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  /*  Container(
                    margin:
                        EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
                    alignment: widget.isAppbarWithHandNumber
                        ? Alignment.topCenter
                        : Alignment.topLeft,
                    child: Text(
                      widget.isAppbarWithHandNumber
                          ? "Last Hand Log"
                          : "Hand Log",
                      style: const TextStyle(
                        fontFamily: AppAssets.fontFamilyLato,
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ), */
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            // TODO: replay integration

                            Alerts.showTextNotification(text: "Replay hand");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.cardBackgroundColor,
                            ),
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.replay,
                              size: 20,
                              color: AppColors.appAccentColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () async {
                            // todo : just change to shareHand and pass club code as well
                            var result = await HandService.shareHand(
                              _handLogModel.hand.gameCode,
                              _handLogModel.hand.handNum,
                              widget.clubCode,
                            );
                            String text = result
                                ? "Hand " +
                                    _handLogModel.hand.handNum.toString() +
                                    " has been shared with the club"
                                : "Couldn't share the hand. Please try again later";
                            Alerts.showTextNotification(text: text);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.cardBackgroundColor,
                            ),
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.share,
                              size: 20,
                              color: AppColors.appAccentColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (_isTheHandBookmarked(widget.handNum)) {
                              _removeBookmark(widget.handNum);
                            } else {
                              final results = await HandService.bookMarkHand(
                                _handLogModel.hand.gameCode,
                                _handLogModel.hand.handNum,
                              );
                              Alerts.showTextNotification(
                                text: results
                                    ? "Hand ${_handLogModel.hand.handNum} has been bookmarked."
                                    : "Couldn't bookmark this hand! Please try again.",
                              );
                              await _fetchBookmarksForGame(widget.gameCode);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.cardBackgroundColor,
                            ),
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              _isTheHandBookmarked(widget.handNum)
                                  ? Icons.star
                                  : Icons.star_outline,
                              size: 20,
                              color: AppColors.appAccentColor,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  HandLogHeaderView(_handLogModel),
                  SizedBox(
                    height: 8,
                  ),
                  /*  Container(
                    margin:
                        EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
                    alignment: Alignment.centerLeft,
                    // child: Text(
                    //   "Winners",
                    //   style: AppStyles.boldTitleTextStyle,
                    // ),
                  ), */
                  HandWinnersView(handLogModel: _handLogModel),
                  HandStageView(
                    handLogModel: _handLogModel,
                    stageEnum: GameStages.PREFLOP,
                  ),
                  HandStageView(
                    handLogModel: _handLogModel,
                    stageEnum: GameStages.FLOP,
                  ),
                  HandStageView(
                    handLogModel: _handLogModel,
                    stageEnum: GameStages.TURN,
                  ),
                  HandStageView(
                    handLogModel: _handLogModel,
                    stageEnum: GameStages.RIVER,
                  ),
                  HandlogShowDown(
                    handLogModel: _handLogModel,
                  ),
                  SizedBox(height: 8),
                  HandLogActionView(handLogModel: _handLogModel),
                  SizedBox(height: 16),
                  HandlogSummary(handlogModel: _handLogModel),
                ],
              ),
            ),
    );
  }
}
