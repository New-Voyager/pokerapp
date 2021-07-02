import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/hand_history_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/game_screens/game_history_details_view/stack_chart_view.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/formatter.dart';

import '../../../main.dart';
import 'hands_chart_view.dart';
import 'highhand_winners_view.dart';

class GameHistoryDetailView extends StatefulWidget {
  final GameHistoryDetailModel data;
  final String clubCode;

  GameHistoryDetailView(this.data, this.clubCode);

  @override
  _GameHistoryDetailView createState() => _GameHistoryDetailView();
}

class _GameHistoryDetailView extends State<GameHistoryDetailView>
    with RouteAwareAnalytics {
  @override
  String get routeName => Routes.game_history_detail_view;
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

  @override
  void initState() {
    _gameDetail = widget.data;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppStylesNew.BgGreenRadialGradient,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          context: context,
          titleText: AppStringsNew.GameDetailsTitle,
          subTitleText: "Game code: ${_gameDetail.gameCode}",
        ),
        body: !loadingDone
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // Container(
                    //   margin: EdgeInsets.only(
                    //     left: 16,
                    //     top: 5,
                    //     bottom: 5,
                    //     right: 10,
                    //   ),
                    //   alignment: Alignment.centerLeft,
                    //   child: Text(
                    //     "Club code: ${widget.clubCode}",
                    //   ),
                    // ),
                    // Container(
                    //   margin: EdgeInsets.only(left: 10, bottom: 5, right: 10),
                    //   alignment: Alignment.centerLeft,
                    //   child: Text(
                    //     "Game Code: " + widget.data.gameCode.toString(),
                    //     style: const TextStyle(
                    //       fontFamily: AppAssets.fontFamilyLato,
                    //       color: AppColors.lightGrayTextColor,
                    //       fontSize: 12.0,
                    //       fontWeight: FontWeight.w400,
                    //     ),
                    //   ),
                    // ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 7,
                            child: gameTypeTile(),
                          ),
                          AppDimensionsNew.getHorizontalSpace(8),
                          Flexible(
                            flex: 3,
                            child: balanceTile(),
                          ),
                        ],
                      ),
                    ),
                    seprator,
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: EdgeInsets.symmetric(horizontal: 8),
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
                          AppDimensionsNew.getHorizontalSpace(8),
                          Flexible(
                            flex: 3,
                            child: actionTile(),
                          ),
                        ],
                      ),
                    ),
                    seprator,
                    Container(
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
    return InkWell(
      onTap: () {
        if (_gameDetail.playedGame) {
          openHandStatistics();
        }
      },
      child: Container(
        height: 150.ph,
        decoration: AppStylesNew.greenContainerDecoration,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Hands",
                  ),
                  AppDimensionsNew.getHorizontalSpace(16),
                  Text(
                    _gameDetail.playedGame
                        ? _gameDetail.handsPlayedStr ?? ''
                        : '0',
                  ),
                ],
              ),
              AppDimensionsNew.getVerticalSizedBox(8),
              Expanded(
                child: Visibility(
                  child: !_gameDetail.playedGame
                      ? Center(
                          child: Text(
                            "No Data",
                            style: AppStylesNew.labelTextStyle,
                          ),
                        )
                      : AbsorbPointer(
                          child: HandsPieChart(this._gameDetail.handsData)),
                  visible: loadingDone,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  openStackDetails() {
    log('Opening points chart');
    Navigator.pushNamed(context, Routes.pointsLineChart,
        arguments: _gameDetail);
  }

  openHandStatistics() {
    Navigator.pushNamed(context, Routes.hand_statistics,
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
        height: 150.ph,
        decoration: AppStylesNew.greenContainerDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Stack",
                textAlign: TextAlign.left,
              ),
            ),
            Visibility(
              child: Expanded(
                  flex: 1,
                  child: !_gameDetail.playedGame
                      ? Text(
                          "No Data",
                          style: AppStylesNew.labelTextStyle,
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
      height: 150.ph,
      width: double.maxFinite,
      decoration: AppStylesNew.greenContainerDecoration,
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            profit < 0 ? "Loss" : "Profit",
            style: AppStylesNew.labelTextStyle,
          ),
          _gameDetail.playedGame
              ? FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    "${DataFormatter.chipsFormat(profit)}",
                    style: profit != 0
                        ? profit < 0
                            ? TextStyle(
                                color: AppColorsNew.newRedButtonColor,
                                fontSize: 20.dp,
                                fontWeight: FontWeight.w400,
                              )
                            : TextStyle(
                                color: AppColorsNew.newGreenButtonColor,
                                fontSize: 20.dp,
                                fontWeight: FontWeight.w400,
                              )
                        : TextStyle(
                            color: AppColorsNew.newTextColor,
                            fontSize: 20.dp,
                            fontWeight: FontWeight.w400,
                          ),
                  ),
                )
              : Text(
                  'No data',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 10.dp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
          Visibility(
            visible: _gameDetail.playedGame,
            child: Text(
              "Buy-in",
              style: AppStylesNew.labelTextStyle,
            ),
          ),
          seprator,
          Text(
            _gameDetail.buyInText ?? _gameDetail.buyInText,
          ),
        ],
      ),
    );
  }

  Widget gameTypeTile() {
    return Container(
      height: 150.ph,
      decoration: AppStylesNew.greenContainerDecoration,
      child: Row(
        children: [
          // Container(
          //   width: 20.0,
          //   // color: Color(0xffef9712),
          //   decoration: BoxDecoration(
          //     color: Color(0xffef9712),
          //     borderRadius: const BorderRadius.horizontal(
          //       left: Radius.circular(AppDimensions.cardRadius),
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   width: 5.0,
          // ),
          Container(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                        visible: loadingDone && _gameDetail.gameTypeStr != null,
                        child: Text(
                          _gameDetail.gameTypeStr ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.dp,
                          ),
                        )),
                    seprator,
                    Visibility(
                        visible:
                            loadingDone && _gameDetail.gameHandsText != null,
                        child: Text(
                          _gameDetail.gameHandsText ?? '',
                          style: AppStylesNew.labelTextStyle,
                        )),
                    seprator,
                    Visibility(
                        visible:
                            loadingDone && _gameDetail.playerHandsText != null,
                        child: Text(
                          _gameDetail.playerHandsText ?? '',
                          style: AppStylesNew.labelTextStyle,
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
                      style:
                          AppStylesNew.labelTextStyle.copyWith(fontSize: 6.dp),
                    ),
                  )
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget highHandTile() {
    return Container(
      decoration: AppStylesNew.greenContainerDecoration,
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(left: 70.0),
          //   child: Divider(
          //     color: Color(0xff707070),
          //   ),
          // ),
          ListTile(
            tileColor: AppColorsNew.actionRowBgColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            onTap: () {
              if (_gameDetail.playedGame) {
                this.onHandHistoryPressed(context);
              }
            },
            leading: Container(
              width: 36.ph,
              height: 36.ph,
              padding: EdgeInsets.all(8),
              decoration:
                  BoxDecoration(color: Colors.green, shape: BoxShape.circle),
              child: SvgPicture.asset(
                'assets/images/handhistory.svg',
                color: AppColorsNew.newTextColor,
                width: 24.ph,
                height: 24.ph,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              "Hand History",
            ),
            trailing: !_gameDetail.playedGame
                ? Text(
                    "Not Available",
                  )
                : Icon(
                    Icons.arrow_forward_ios,
                    color: AppColorsNew.newGreenButtonColor,
                    size: 12.dp,
                  ),
          ),
          AppDimensionsNew.getVerticalSizedBox(16),
          ListTile(
            tileColor: AppColorsNew.actionRowBgColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            leading: Container(
              width: 36.ph,
              height: 36.ph,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: AppColorsNew.newBlueShadeColor,
                  shape: BoxShape.circle),
              child: SvgPicture.asset(
                'assets/images/casino.svg',
                color: AppColorsNew.newTextColor,
                width: 24.ph,
                height: 24.ph,
                fit: BoxFit.contain,
              ),
            ),
            title: Text(
              "Table Record",
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.table_result,
                arguments: {
                  "gameCode": _gameDetail.gameCode,
                  "clubCode": widget.clubCode
                },
              );
            },
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: AppColorsNew.newGreenButtonColor,
              size: 12.dp,
            ),
          ),
          AppDimensionsNew.getVerticalSizedBox(16),
          ListTile(
            tileColor: AppColorsNew.actionRowBgColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            onTap: () => this.onHighHandLogPressed(context),
            leading: Container(
              width: 36.ph,
              height: 36.ph,
              padding: EdgeInsets.all(8),
              decoration:
                  BoxDecoration(color: Colors.yellow, shape: BoxShape.circle),
              child: SvgPicture.asset(
                'assets/images/highhand.svg',
                color: AppColorsNew.darkGreenShadeColor,
                width: 24.ph,
                height: 24.ph,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              "High Hand Log",
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: AppColorsNew.newGreenButtonColor,
              size: 12.dp,
            ),
          ),
        ],
      ),
    );
  }
}
