import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/hand_history_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
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
          "Game Details",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: AppColors.appAccentColor,
            fontSize: 14.0,
            fontFamily: AppAssets.fontFamilyLato,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: !loadingDone
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: Column(
                children: [
                  Container(
                    margin:
                        EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Hand History",
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
                  Container(
                    child: TabBar(
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
                      ],
                      controller: _tabController,
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        new PlayedHandsScreen(
                            _data.gameCode, _data.getAllHands()),
                        new PlayedHandsScreen(
                            _data.gameCode, _data.getWinningHands()),
                      ],
                      controller: _tabController,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
