import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/hand_history_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/game_screens/game_history_details_view/stack_chart_view.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/game_service.dart';

import 'hands_chart_view.dart';
import 'highhand_winners_view.dart';

class GameHistoryDetailView extends StatefulWidget {
  final GameHistoryDetailModel data;
  final String clubCode;

  GameHistoryDetailView(this.data, this.clubCode);

  @override
  _GameHistoryDetailView createState() => _GameHistoryDetailView(data);
}

class _GameHistoryDetailView extends State<GameHistoryDetailView> {
  final seprator = SizedBox(
    height: 1.0,
  );

  bool loadingDone = false;
  GameHistoryDetailModel _gameDetail;

  _fetchData() async {
    await GameService.getGameHistoryDetail(_gameDetail);
    loadingDone = true;
    setState(() {
      // update ui
    });
  }

  _GameHistoryDetailView(this._gameDetail);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: CustomAppBar(
        context: context,
        titleText: AppStringsNew.GameDetailsTitle,
      ),
      body: !loadingDone
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      left: 10,
                      top: 5,
                      bottom: 5,
                      right: 10,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Game Details",
                      style: const TextStyle(
                        fontFamily: AppAssets.fontFamilyLato,
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, bottom: 5, right: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Game Code: " + widget.data.gameCode.toString(),
                      style: const TextStyle(
                        fontFamily: AppAssets.fontFamilyLato,
                        color: AppColors.lightGrayTextColor,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 7,
                          child: Visibility(
                              visible: loadingDone, child: gameTypeTile()),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Flexible(
                          flex: 3,
                          child: Visibility(
                              visible: loadingDone, child: balanceTile()),
                        ),
                      ],
                    ),
                  ),
                  seprator,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 3,
                          child: stackTile(),
                        ),
                        // Flexible(
                        //   flex: 3,
                        //   child: resultTile(),
                        // ),
                        SizedBox(width: 5),
                        Flexible(
                          flex: 3,
                          child: actionTile(),
                        ),
                      ],
                    ),
                  ),
                  seprator,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Flexible(
                          child: highHandTile(),
                        ),
                      ],
                    ),
                  ),
                  getLowerCard(),
                ],
              ),
            ),
    );
  }

  Widget listTile() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff313235),
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimensions.cardRadius),
        ),
      ),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal,
            ),
            title: Text(
              "Hand History",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Divider(
            color: Colors.white,
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal,
            ),
            title: Text(
              "Table Result",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Divider(
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget highHandView() {
    return Container(
      height: 60.0,
      decoration: BoxDecoration(
        color: Color(0xff313235),
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimensions.cardRadius),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(
              "High Hand is not tracked",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget resultTile() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 135.0,
        decoration: BoxDecoration(
          color: Color(0xff313235),
          borderRadius: BorderRadius.all(
            Radius.circular(AppDimensions.cardRadius),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Big Win",
                    style: TextStyle(color: Colors.white),
                  ),
                  seprator,
                  Row(
                    children: [
                      Text(
                        "120",
                        style: TextStyle(color: Colors.amber, fontSize: 18.0),
                      ),
                      Text(
                        "hand#2",
                        style:
                            TextStyle(color: Color(0xff848484), fontSize: 13.0),
                      ),
                    ],
                  ),
                  seprator,
                  Text(
                    "Big Loss",
                    style: TextStyle(color: Colors.white),
                  ),
                  seprator,
                  Row(
                    children: [
                      Text(
                        "85",
                        style:
                            TextStyle(color: Colors.redAccent, fontSize: 20.0),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        "hand#3",
                        style: TextStyle(color: Color(0xff848484)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget actionTile() {
    return Container(
      height: 150.0,
      decoration: BoxDecoration(
        color: Color(0xff313235),
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimensions.cardRadius),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Hands",
                  style: TextStyle(
                    fontFamily: AppAssets.fontFamilyLato,
                    color: AppColors.lightGrayTextColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  _gameDetail.playedGame
                      ? _gameDetail.handsPlayedStr ?? ''
                      : '0',
                  style: TextStyle(
                    fontFamily: AppAssets.fontFamilyLato,
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Visibility(
                child: !_gameDetail.playedGame
                    ? Text(
                        "No Data",
                        style: TextStyle(
                          fontFamily: AppAssets.fontFamilyLato,
                          color: Colors.white38,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    : HandsPieChart(this._gameDetail.handsData),
                visible: loadingDone,
              ),
            )
          ],
        ),
      ),
    );
  }

  openStackDetails() {
    log('Opening points chart');
    Navigator.pushNamed(context, Routes.pointsLineChart,
        arguments: _gameDetail);
  }

  Widget stackTile() {
    if (loadingDone) {
      // loading done
      print(_gameDetail.stack);
    }
    return GestureDetector(
      onTap: () {
        openStackDetails();
      },
      child: Container(
        height: 150.0,
        decoration: BoxDecoration(
          color: Color(0xff313235),
          borderRadius: BorderRadius.all(
            Radius.circular(AppDimensions.cardRadius),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Stack",
                    style: TextStyle(
                      fontFamily: AppAssets.fontFamilyLato,
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              child: Expanded(
                  flex: 1,
                  child: !_gameDetail.playedGame
                      ? Text(
                          "No Data",
                          style: TextStyle(
                            fontFamily: AppAssets.fontFamilyLato,
                            color: Colors.white38,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      : StackChartView(_gameDetail.stack, openStackDetails)),
              // PointsLineChart()),
              visible: loadingDone,
            ),
          ],
        ),
      ),
    );
  }

  Widget balanceTile() {
    double profit = _gameDetail.profit == null ? 0 : _gameDetail.profit;

    return Container(
      height: 140.0,
      decoration: BoxDecoration(
        color: Color(0xff313235),
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimensions.cardRadius),
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profit < 0 ? "Loss" : "Profit",
                  style: const TextStyle(
                    fontFamily: AppAssets.fontFamilyLato,
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                _gameDetail.playedGame
                    ? Text(
                        _gameDetail.profitText ?? _gameDetail.profitText,
                        style: _gameDetail.profit != null ||
                                _gameDetail.profit == 0
                            ? _gameDetail.profit < 0
                                ? TextStyle(
                                    fontFamily: AppAssets.fontFamilyLato,
                                    color: Colors.red,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w400,
                                  )
                                : TextStyle(
                                    fontFamily: AppAssets.fontFamilyLato,
                                    color: Colors.lightGreenAccent,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w400,
                                  )
                            : TextStyle(
                                fontFamily: AppAssets.fontFamilyLato,
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w400,
                              ),
                      )
                    : Text(
                        'No data',
                        style: TextStyle(
                          fontFamily: AppAssets.fontFamilyLato,
                          color: Colors.white38,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: _gameDetail.playedGame,
                  child: Text(
                    "Buy-in",
                    style: TextStyle(
                      fontFamily: AppAssets.fontFamilyLato,
                      color: Colors.blueGrey,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                seprator,
                Text(
                  _gameDetail.buyInText ?? _gameDetail.buyInText,
                  style: TextStyle(
                    fontFamily: AppAssets.fontFamilyLato,
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget gameTypeTile() {
    return Container(
      height: 140.0,
      decoration: BoxDecoration(
        color: Color(0xff313235),
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimensions.cardRadius),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 20.0,
            // color: Color(0xffef9712),
            decoration: BoxDecoration(
              color: Color(0xffef9712),
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(AppDimensions.cardRadius),
              ),
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                          visible:
                              loadingDone && _gameDetail.gameTypeStr != null,
                          child: Text(
                            _gameDetail.gameTypeStr ?? '',
                            style: const TextStyle(
                              fontFamily: AppAssets.fontFamilyLato,
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w800,
                            ),
                          )),
                      seprator,
                      Visibility(
                          visible:
                              loadingDone && _gameDetail.gameHandsText != null,
                          child: Text(
                            _gameDetail.gameHandsText ?? '',
                            style: const TextStyle(
                              fontFamily: AppAssets.fontFamilyLato,
                              color: AppColors.lightGrayTextColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w800,
                            ),
                          )),
                      seprator,
                      Visibility(
                          visible: loadingDone &&
                              _gameDetail.playerHandsText != null,
                          child: Text(
                            _gameDetail.playerHandsText ?? '',
                            style: const TextStyle(
                              fontFamily: AppAssets.fontFamilyLato,
                              color: AppColors.lightGrayTextColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w800,
                            ),
                          )),
                      seprator
                    ],
                  ),
                  /*  SizedBox(
                    height: 15,
                  ), */
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Visibility(
                      visible: loadingDone && _gameDetail.endedAt != null,
                      child: Text(
                        _gameDetail.endedAtStr != null
                            ? 'Ended at ${_gameDetail.endedAtStr}'
                            : '',
                        style: const TextStyle(
                          fontFamily: AppAssets.fontFamilyLato,
                          color: AppColors.lightGrayTextColor,
                          fontSize: 10.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    )
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget highHandTile() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff313235),
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimensions.cardRadius),
        ),
      ),
      child: Visibility(
        visible: this._gameDetail != null &&
            this._gameDetail.hhWinners.length > 0 &&
            this._gameDetail.hhTracked == true,
        child: HighhandWinnersView(this._gameDetail),
      ),
    );
  }

  void onHandHistoryPressed(BuildContext context) {
    final model =
        HandHistoryListModel(_gameDetail.gameCode, _gameDetail.isOwner);
    Navigator.pushNamed(
      context,
      Routes.hand_history_list,
      arguments: {
        'model': model,
        'clubCode': widget.clubCode,
      },
    );
  }

  void onHighHandLogPressed(BuildContext context) {
    final model =
        HandHistoryListModel(_gameDetail.gameCode, _gameDetail.isOwner);
    Navigator.pushNamed(
      context,
      Routes.high_hand_log,
      arguments: _gameDetail.gameCode,
    );
  }

  void onHigh(BuildContext context) {
    final model =
        HandHistoryListModel(_gameDetail.gameCode, _gameDetail.isOwner);
    Navigator.pushNamed(
      context,
      Routes.hand_history_list,
      arguments: {
        'model': model,
        'clubCode': widget.clubCode,
      },
    );
  }

  Widget getLowerCard() {
    log('hands Played: ${_gameDetail.handsPlayed}');
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff313235),
          // borderRadius: BorderRadius.all(
          //   Radius.circular(AppDimensions.cardRadius),
          // ),
        ),
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(left: 70.0),
            //   child: Divider(
            //     color: Color(0xff707070),
            //   ),
            // ),
            ListTile(
              onTap: () {
                if (_gameDetail.playedGame) {
                  this.onHandHistoryPressed(context);
                }
              },
              leading: CircleAvatar(
                radius: 18,
                child: SvgPicture.asset('assets/images/casino.svg',
                    color: Colors.white),
                backgroundColor: Color(0xff319ffe),
              ),
              title: Text(
                "Hand History",
                style: const TextStyle(
                  fontFamily: AppAssets.fontFamilyLato,
                  color: Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              trailing: !_gameDetail.playedGame
                  ? Text(
                      "Not Available",
                      style: const TextStyle(
                        fontFamily: AppAssets.fontFamilyLato,
                        color: Colors.white54,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  : IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.appAccentColor,
                        size: 12,
                      ),
                      onPressed: () {},
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 70.0),
              child: Divider(
                color: Color(0xff707070),
              ),
            ),
            ListTile(
                leading: CircleAvatar(
                  radius: 18,
                  child: SvgPicture.asset('assets/images/casino.svg',
                      color: Colors.white),
                  backgroundColor: Color(0xffef9712),
                ),
                title: Text(
                  "Table Record",
                  style: const TextStyle(
                    fontFamily: AppAssets.fontFamilyLato,
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.appAccentColor,
                      size: 12,
                    ),
                    onPressed: () {}),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.table_result,
                    arguments: {
                      "gameCode": _gameDetail.gameCode,
                      "clubCode": widget.clubCode
                    },
                  );
                }),
            Padding(
              padding: const EdgeInsets.only(left: 70.0),
              child: Divider(
                color: Color(0xff707070),
              ),
            ),
            ListTile(
              onTap: () => this.onHighHandLogPressed(context),
              leading: CircleAvatar(
                radius: 18,
                child: SvgPicture.asset('assets/images/casino.svg',
                    color: Colors.white),
                backgroundColor: Color(0xff0fc915),
              ),
              title: Text(
                "High Hand Log",
                style: const TextStyle(
                  fontFamily: AppAssets.fontFamilyLato,
                  color: Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.appAccentColor,
                  size: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
