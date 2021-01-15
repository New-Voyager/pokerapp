import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/hand_history_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/screens/game_screens/game_history_details_view/stack_chart_view.dart';
import 'package:pokerapp/screens/game_screens/hand_history/hand_history.dart';
import 'package:pokerapp/screens/game_screens/highhand_log/highhand_log.dart';
import 'package:pokerapp/screens/game_screens/table_result/table_result.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:provider/provider.dart';

import 'hands_chart_view.dart';
import 'highhand_winners_view.dart';

class GameHistoryDetailView extends StatefulWidget {
  final GameHistoryDetailModel data;
  GameHistoryDetailView(this.data);

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
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.screenBackgroundColor,
        title: Text("Game History"),
        elevation: 0.0,
      ),
      body: !loadingDone
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
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
                          flex: 10,
                          child: highHandTile(),
                        ),
                      ],
                    ),
                  ),
                  getLowerCard()
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
                  style: TextStyle(color: Color(0xff848484)),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  _gameDetail.handsPlayedStr ?? '',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            Expanded(
              child: Visibility(
                child: HandsPieChart(this._gameDetail.handsData),
                visible: loadingDone,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget stackTile() {
    if (loadingDone) {
      // loading done
      print(_gameDetail.stack);
    }
    return Container(
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
                  style: TextStyle(color: Colors.white, fontSize: 14.0),
                ),
              ),
            ],
          ),
          Visibility(
            child: Expanded(flex: 1, child: StackChartView(_gameDetail.stack)),
            visible: loadingDone,
          ),
        ],
      ),
    );
  }

  Widget balanceTile() {
    return Container(
      height: 120.0,
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
                  "Balance",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(_gameDetail.profitText ?? _gameDetail.profitText,
                    style: _gameDetail.profit != null || _gameDetail.profit == 0
                        ? _gameDetail.profit < 0
                            ? TextStyle(color: Colors.red, fontSize: 20.0)
                            : TextStyle(
                                color: Colors.lightGreenAccent, fontSize: 20.0)
                        : TextStyle(color: Colors.white, fontSize: 20.0)),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Buy-in",
                  style: TextStyle(color: Colors.blueGrey),
                ),
                seprator,
                Text(
                  _gameDetail.buyInText ?? _gameDetail.buyInText,
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
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
      height: 120.0,
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
                            style:
                                TextStyle(color: Colors.white, fontSize: 24.0),
                          )),
                      seprator,
                      Visibility(
                          visible:
                              loadingDone && _gameDetail.gameHandsText != null,
                          child: Text(
                            _gameDetail.gameHandsText ?? '',
                            style: TextStyle(
                              color: Color(0xff848484),
                            ),
                          )),
                      seprator,
                      Visibility(
                          visible: loadingDone &&
                              _gameDetail.playerHandsText != null,
                          child: Text(
                            _gameDetail.playerHandsText ?? '',
                            style: TextStyle(color: Color(0xff848484)),
                          )),
                      seprator
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Visibility(
                      visible: loadingDone && _gameDetail.endedAt != null,
                      child: Text(
                        _gameDetail.endedAtStr != null
                            ? 'Ended at ${_gameDetail.endedAtStr}'
                            : '',
                        style:
                            TextStyle(color: Color(0xff848484), fontSize: 12),
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
      child: Expanded(
        child: Visibility(
          visible: this._gameDetail != null &&
              this._gameDetail.hhWinners.length > 0 &&
              this._gameDetail.hhTracked == true,
          child: HighhandWinnersView(this._gameDetail),
        ),
      ),
    );
  }

  void onHandHistoryPressed(BuildContext context) {
    final model =
        HandHistoryListModel(_gameDetail.gameCode, _gameDetail.isOwner);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider<HandHistoryListModel>(
              create: (_) => model,
              builder: (BuildContext context, _) =>
                  Consumer<HandHistoryListModel>(
                      builder: (_, HandHistoryListModel data, __) =>
                          HandHistoryListView(data))),
        ));
  }

  void onHighHandLogPressed(BuildContext context) {
    final model =
    HandHistoryListModel(_gameDetail.gameCode, _gameDetail.isOwner);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                HighHandLogView(_gameDetail.gameCode)));
  }

  void onHigh(BuildContext context) {
    final model =
    HandHistoryListModel(_gameDetail.gameCode, _gameDetail.isOwner);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider<HandHistoryListModel>(
              create: (_) => model,
              builder: (BuildContext context, _) =>
                  Consumer<HandHistoryListModel>(
                      builder: (_, HandHistoryListModel data, __) =>
                          HandHistoryListView(data))),
        ));
  }

  Widget getLowerCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff313235),
          borderRadius: BorderRadius.all(
            Radius.circular(AppDimensions.cardRadius),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 70.0),
              child: Divider(
                color: Color(0xff707070),
              ),
            ),
            ListTile(
              onTap: () => this.onHandHistoryPressed(context),
              leading: CircleAvatar(
                child: SvgPicture.asset('assets/images/casino.svg',
                    color: Colors.white),
                backgroundColor: Color(0xff319ffe),
              ),
              title: Text(
                "Hand History",
                style: TextStyle(color: Colors.white),
              ),
              trailing: IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
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
                  child: SvgPicture.asset('assets/images/casino.svg',
                      color: Colors.white),
                  backgroundColor: Color(0xffef9712),
                ),
                title: Text(
                  "Table Record",
                  style: TextStyle(color: Colors.white),
                ),
                trailing: IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                    onPressed: () {}),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              TableResultScreen(_gameDetail.gameCode)));
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
                child: SvgPicture.asset('assets/images/casino.svg',
                    color: Colors.white),
                backgroundColor: Color(0xff0fc915),
              ),
              title: Text(
                "High Hand Log",
                style: TextStyle(color: Colors.white),
              ),
              trailing: IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
