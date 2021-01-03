import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/screens/club_screen/game_history_details_view/hands_chart_view.dart';
import 'package:pokerapp/screens/club_screen/game_history_details_view/stack_chart_view.dart';

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

  bool _showLoading = false;
  bool loadingDone = false;
  GameHistoryDetailModel _gameDetail;

  _toggleLoading() => setState(() {
        _showLoading = !_showLoading;
      });

  _fetchData() async {
    _toggleLoading();
    await _gameDetail.loadFromAsset();
    loadingDone = true;
    _toggleLoading();
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Flexible(
                    flex: 7,
                    child: gameTypeTile(),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Flexible(
                    flex: 3,
                    child: balanceTile(),
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
                  "14",
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
                  "Balance",
                  style: TextStyle(color: Colors.white),
                ),
                seprator,
                Text(
                  "28",
                  style: TextStyle(color: Colors.amber, fontSize: 20.0),
                ),
                seprator,
                Text(
                  "BuyIn",
                  style: TextStyle(color: Colors.white),
                ),
                seprator,
                Text(
                  "1300",
                  style: TextStyle(color: Colors.amber, fontSize: 20.0),
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
      height: 135.0,
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "No Limit Holdem 1/2",
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                      seprator,
                      Text(
                        "45 Hands dealt in 1 hour 33 minutes",
                        style: TextStyle(
                          color: Color(0xff848484),
                        ),
                      ),
                      seprator,
                      Text(
                        "You played 35 minutes",
                        style: TextStyle(color: Color(0xff848484)),
                      ),
                      seprator
                    ],
                  ),
                  Text(
                    "Ended At 12:00 am",
                    style: TextStyle(color: Color(0xff848484)),
                  ),
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
            //   Visibility(
            //     visible: this._gameDetail != null &&
            //              this._gameDetail.hhWinners.length > 0 &&
            //              this._gameDetail.hhTracked ==true,
            //       child: ListTile(
            //     leading: CircleAvatar(
            //       child: SvgPicture.asset('assets/images/casino.svg',
            //           color: Colors.white),
            //       backgroundColor: Color(0xfffe5b31),
            //     ),
            //     title: HighhandWinnersView(this._gameDetail),
            //       )
            //
            // ),
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
                  onPressed: () {}),
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
                  onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }
}
