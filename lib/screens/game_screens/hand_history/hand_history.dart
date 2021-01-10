import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/hand_history_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/screens/game_screens/hand_history/played_hands.dart';
import 'package:pokerapp/services/app/hand_service.dart';

class HandHistoryListView extends StatefulWidget {
  final HandHistoryListModel data;
  HandHistoryListView(this.data);

  @override
  _HandHistoryState createState() => _HandHistoryState(this.data);
}

class _HandHistoryState extends State<HandHistoryListView>
    with SingleTickerProviderStateMixin {
  bool loadingDone = false;
  final HandHistoryListModel _data;

  TabController _tabController;
  _HandHistoryState(this._data);

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
    _fetchData();
  }

  _fetchData() async {
    await HandService.getAllHands(_data);
    loadingDone = true;
    setState(() {
      // update ui
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: AppBar(
        title: Text("Hand History"),
        bottom: PreferredSize(
          child: Column(
            children: [
              Text(
                "Game Code:" + this._data.gameCode,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 10.0,
              ),
              TabBar(
                unselectedLabelColor: Color(0xff319ffe),
                labelColor: Colors.white,
                tabs: [
                  new Tab(
                    icon: SvgPicture.asset(
                      'assets/images/casino.svg',
                      color: Colors.white,
                    ),
                    text: "All Hands",
                  ),
                  new Tab(
                    icon: SvgPicture.asset(
                      'assets/images/casino.svg',
                      color: Colors.white,
                    ),
                    text: "Winning Hands",
                  ),
                  // new Tab(
                  //   icon: SvgPicture.asset(
                  //     'assets/images/casino.svg',
                  //     color: Colors.white,
                  //   ),
                  //   text: "Hands",
                  // ),
                ],
                controller: _tabController,
              ),
            ],
          ),
          preferredSize: Size(100.0, 80.0),
        ),
        backgroundColor: AppColors.screenBackgroundColor,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: !loadingDone
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
              children: [
                new PlayedHandsScreen(_data.history),
                new PlayedHandsScreen(_data.history),
              ],
              controller: _tabController,
            ),
    );
  }
}
