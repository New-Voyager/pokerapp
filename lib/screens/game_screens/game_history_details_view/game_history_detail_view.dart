import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/hand_history_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_screens/game_history_details_view/stack_chart_view.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/screens/game_screens/widgets/highhand_widget.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/widgets/round_color_button.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import 'hands_chart_view.dart';

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
  AppTextScreen _appScreenText;

  _fetchData() async {
    await GameService.getGameHistoryDetail(_gameDetail);
    loadingDone = true;
    setState(() {
      // update ui
    });
  }

  @override
  void initState() {
    _appScreenText = getAppTextScreen("gameHistoryDetailView");

    _gameDetail = widget.data;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (_, theme, __) => Container(
        decoration: AppDecorators.bgRadialGradient(theme),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            theme: theme,
            context: context,
            titleText: _appScreenText['gameDetails'],
            subTitleText:
                "${_appScreenText['gameCode']}: ${_gameDetail.gameCode}",
          ),
          body: !loadingDone
              ? Center(child: CircularProgressWidget())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            Flexible(
                              flex: 7,
                              child: gameTypeTile(theme),
                            ),
                            AppDimensionsNew.getHorizontalSpace(8),
                            Flexible(
                              flex: 3,
                              child: balanceTile(theme),
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
                            Expanded(
                              flex: 3,
                              child: stackTile(theme),
                            ),
                            AppDimensionsNew.getHorizontalSpace(8),
                            Expanded(
                              flex: 3,
                              child: actionTile(theme),
                            ),
                          ],
                        ),
                      ),
                      seprator,
                      Container(
                        margin: const EdgeInsets.all(8.0),
                        child: highHandTile(theme),
                      ),
                      getLowerCard(theme),
                    ],
                  ),
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
              _appScreenText['handHistory'],
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
              _appScreenText['tableResult'],
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
              _appScreenText['highHandisNotTracked'],
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
                    _appScreenText['bigWin'],
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
                        "${_appScreenText['hand']}#2",
                        style:
                            TextStyle(color: Color(0xff848484), fontSize: 13.0),
                      ),
                    ],
                  ),
                  seprator,
                  Text(
                    "${_appScreenText['bigLoss']}",
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
                        "${_appScreenText['hand']}#3",
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

  Widget actionTile(AppTheme theme) {
    if (!_gameDetail.dataAggregated || !_gameDetail.playedGame) {
      return Container(
          height: 150.ph,
          decoration: AppDecorators.tileDecoration(theme),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text('Not Available',
                      style: AppDecorators.getSubtitle3Style(theme: theme)))));
    }

    return InkWell(
      onTap: () {
        if (_gameDetail.playedGame) {
          openHandStatistics();
        }
      },
      child: Container(
        height: 150.ph,
        decoration: AppDecorators.tileDecoration(theme),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${_appScreenText['hands']}",
                  ),
                  AppDimensionsNew.getHorizontalSpace(16),
                  Text(
                    _gameDetail.playedGame
                        ? _gameDetail.handsPlayedStr ?? ''
                        : '0',
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RoundIconButton(
                      icon: Icons.query_stats_sharp,
                      bgColor: Colors.black,
                      size: 24.pw,
                      iconColor: theme.secondaryColor,
                      borderColor: theme.secondaryColor,
                      onTap: () {
                        openHandStatistics();
                      },
                    ),
                  ),
                ],
              ),
              AppDimensionsNew.getVerticalSizedBox(8),
              Expanded(
                child: Visibility(
                  child: !_gameDetail.playedGame
                      ? Center(
                          child: Text(_appScreenText['noData'],
                              style: AppDecorators.getSubtitle3Style(
                                  theme: theme)),
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

  Widget stackTile(AppTheme theme) {
    if (loadingDone) {
      // loading done
      print(_gameDetail.stack);
    }
    if (!_gameDetail.dataAggregated || !_gameDetail.playedGame) {
      return Container(
          height: 150.ph,
          decoration: AppDecorators.tileDecoration(theme),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text('Not Available',
                      style: AppDecorators.getSubtitle3Style(theme: theme)))));
    }

    return GestureDetector(
      onTap: () {
        openStackDetails();
      },
      child: Container(
        height: 150.ph,
        decoration: AppDecorators.tileDecoration(theme),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _appScreenText['stack'],
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RoundIconButton(
                  icon: Icons.query_stats_sharp,
                  bgColor: Colors.black,
                  size: 24.pw,
                  iconColor: theme.secondaryColor,
                  borderColor: theme.secondaryColor,

                  onTap: () {
                    openStackDetails();
                  },
                  //icon: Icons.query_stats_sharp,
                ),
              )
            ]),
            Visibility(
              child: Expanded(
                  flex: 1,
                  child: !_gameDetail.playedGame
                      ? Center(
                          child: Text(
                            _appScreenText['noData'],
                            style:
                                AppDecorators.getSubtitle3Style(theme: theme),
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

  Widget balanceTile(AppTheme theme) {
    double profit = _gameDetail.profit == null ? 0 : _gameDetail.profit;

    return Container(
      height: 150.ph,
      width: double.maxFinite,
      decoration: AppDecorators.tileDecoration(theme),
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            profit < 0 ? _appScreenText['loss'] : _appScreenText['profit'],
            style: AppDecorators.getSubtitle3Style(theme: theme),
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
                  _appScreenText['noData'],
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 10.dp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
          Visibility(
            visible: _gameDetail.playedGame,
            child: Text(
              _appScreenText['buyIn'],
              style: AppDecorators.getSubtitle3Style(theme: theme),
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

  Widget gameTypeTile(AppTheme theme) {
    String title = '';
    String blind = '';

    if (loadingDone) {
      title = '${_gameDetail.gameTypeStr ?? ""}';
      blind =
          '${DataFormatter.chipsFormat(_gameDetail.smallBlind)} / ${DataFormatter.chipsFormat(_gameDetail.bigBlind)}';
    }
    return Container(
      height: 150.ph,
      decoration: AppDecorators.tileDecoration(theme),
      child: Row(
        children: [
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
                        child: Row(children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.dp,
                            ),
                          ),
                          SizedBox(width: 10.pw),
                          Text(
                            blind,
                            style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 10.dp,
                            ),
                          ),
                        ])),
                    seprator,
                    Visibility(
                        visible:
                            loadingDone && _gameDetail.gameHandsText != null,
                        child: Text(
                          _gameDetail.gameHandsText ?? '',
                          style: AppDecorators.getSubtitle3Style(theme: theme),
                        )),
                    seprator,
                    Visibility(
                        visible:
                            loadingDone && _gameDetail.playerHandsText != null,
                        child: Text(
                          _gameDetail.playerHandsText ?? '',
                          style: AppDecorators.getSubtitle3Style(theme: theme),
                        )),
                    seprator
                  ],
                ),
                /*  SizedBox(
                  height: 15,
                ), */
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: loadingDone && _gameDetail.endedAt != null,
                        child: Text(
                          _gameDetail.endedAtStr != null
                              ? '${_appScreenText['startedBy']} ${_gameDetail.startedBy}'
                              : '',
                          style: AppDecorators.getSubtitle3Style(theme: theme)
                              .copyWith(fontSize: 6.dp),
                        ),
                      ),
                      Visibility(
                        visible: loadingDone && _gameDetail.endedAt != null,
                        child: Text(
                          _gameDetail.endedAtStr != null
                              ? '${_appScreenText['endedBy']} ${_gameDetail.endedBy}'
                              : '',
                          style: AppDecorators.getSubtitle3Style(theme: theme)
                              .copyWith(fontSize: 6.dp),
                        ),
                      ),
                      Visibility(
                        visible: loadingDone && _gameDetail.endedAt != null,
                        child: Text(
                          _gameDetail.endedAtStr != null
                              ? '${_appScreenText['endedAt']} ${_gameDetail.endedAtStr}'
                              : '',
                          style: AppDecorators.getSubtitle3Style(theme: theme)
                              .copyWith(fontSize: 6.dp),
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

  Widget highHandTile(AppTheme theme) {
    if (this._gameDetail == null ||
        this._gameDetail.hhTracked == false ||
        this._gameDetail.hhWinners == null ||
        this._gameDetail.hhWinners.length == 0) {
      return Container();
    }
    return Visibility(
      visible: this._gameDetail != null &&
          this._gameDetail.hhWinners != null &&
          this._gameDetail.hhWinners.length > 0 &&
          this._gameDetail.hhTracked == true,
      child: Container(
        decoration: AppDecorators.tileDecoration(theme),
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.only(top: 16, left: 16),
                child: Text(_appScreenText['highHandWinners'])),
            HighhandWidget(
              this._gameDetail.hhWinners[0],
              clubCode: widget.clubCode,
            ),
          ],
        ),
      ), //HighhandWinnersView(this._gameDetail),
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
    Navigator.pushNamed(
      context,
      Routes.high_hand_log,
      arguments: {
        "gameCode": _gameDetail.gameCode,
        "clubCode": widget.clubCode
      },
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

  Widget getLowerCard(AppTheme theme) {
    bool hhTracked = false;
    if (loadingDone) {
      hhTracked = _gameDetail.hhTracked;
    }
    Widget hhTile;
    if (!hhTracked) {
      hhTile = ListTile(
        tileColor: theme.fillInColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        leading: Container(
          width: 36.ph,
          height: 36.ph,
          padding: EdgeInsets.all(8),
          decoration:
              BoxDecoration(color: Colors.yellow, shape: BoxShape.circle),
          child: SvgPicture.asset(
            'assets/images/highhand.svg',
            color: theme.primaryColorWithDark(),
            width: 24.ph,
            height: 24.ph,
            fit: BoxFit.cover,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _appScreenText['highHandLog'],
              style: AppDecorators.getHeadLine4Style(theme: theme),
            ),
          ],
        ),
        trailing: Text(_appScreenText['notTracked']),
      );
    } else {
      hhTile = ListTile(
        tileColor: theme.fillInColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
          _appScreenText['highHandLog'],
          style: AppDecorators.getHeadLine4Style(theme: theme),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: theme.accentColor,
          size: 12.dp,
        ),
      );
    }
    bool showHandHistory = _gameDetail.playedGame;
    if ((widget.data.isHost ?? false) ||
        (widget.data.isManager ?? false) ||
        (widget.data.isOwner ?? false)) {
      showHandHistory = true;
    }
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
            tileColor: theme.fillInColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            onTap: () {
              if (showHandHistory) {
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
            title: Text(_appScreenText['handHistory'],
                style: AppDecorators.getHeadLine4Style(theme: theme)),
            trailing: !showHandHistory
                ? Text(
                    _appScreenText['notAvailable'],
                  )
                : Icon(
                    Icons.arrow_forward_ios,
                    color: theme.accentColor,
                    size: 12.dp,
                  ),
          ),
          AppDimensionsNew.getVerticalSizedBox(16),
          ListTile(
            tileColor: theme.fillInColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            leading: Container(
              width: 36.ph,
              height: 36.ph,
              padding: EdgeInsets.all(8),
              decoration:
                  BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
              child: SvgPicture.asset(
                'assets/images/casino.svg',
                color: theme.supportingColor,
                width: 24.ph,
                height: 24.ph,
                fit: BoxFit.contain,
              ),
            ),
            title: Text(
              _appScreenText['tableResult'],
              style: AppDecorators.getHeadLine4Style(theme: theme),
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
              color: theme.accentColor,
              size: 12.dp,
            ),
          ),
          AppDimensionsNew.getVerticalSizedBox(16),
          hhTile,
        ],
      ),
    );
  }
}
