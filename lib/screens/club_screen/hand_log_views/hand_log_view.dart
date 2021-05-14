import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_stages.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/hand_log_header_view.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/hand_stage_view.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/hand_winners_view.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/handlog_action.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/handlog_showdown.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/handlog_summary.dart';
import 'package:pokerapp/services/app/hand_service.dart';
import 'package:pokerapp/services/test/test_service.dart';

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

  @override
  void initState() {
    super.initState();

    if (TestService.isTesting) {
      loadJsonData();
    } else {
      _fetchData();
    }
  }

  void _fetchData() async {
    _handLogModel =
        await HandService.getHandLog(widget.gameCode, widget.handNum);
    _isLoading = false;
    setState(() {
      // update ui
    });
  }

  loadJsonData() async {
    String data = await DefaultAssetBundle.of(context).loadString(
        "assets/sample-data/handlog/plo-hilo/two-hi-two-lo-winners.json");

    final jsonResult = json.decode(data);
    _handLogModel = HandLogModelNew.fromJson(jsonResult);

    setState(() {
      _isLoading = false;
    });
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widget.clubCode != null
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // todo : just change to shareHand and pass club code as well
                                      HandService.bookMarkHand(
                                        _handLogModel.hand.gameId,
                                        _handLogModel.hand.handNum,
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
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
                                ],
                              )
                            : Container(),
                        GestureDetector(
                          onTap: () {
                            HandService.bookMarkHand(
                              _handLogModel.hand.gameId,
                              _handLogModel.hand.handNum,
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                            ),
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.bookmark,
                              size: 20,
                              color: AppColors.appAccentColor,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  HandLogHeaderView(_handLogModel),
                  Container(
                    margin:
                        EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
                    alignment: Alignment.centerLeft,
                    // child: Text(
                    //   "Winners",
                    //   style: AppStyles.boldTitleTextStyle,
                    // ),
                  ),
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
