import 'package:flutter/cupertino.dart';
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
    return CupertinoPageScaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      resizeToAvoidBottomInset: true,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.screenBackgroundColor,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_ios,
                size: 16,
                color: AppColors.appAccentColor,
              ),
              Text(
                "Game",
                style: const TextStyle(
                  fontFamily: AppAssets.fontFamilyLato,
                  color: AppColors.appAccentColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        middle: Column(
          children: [
            Text(
              "Hand History",
              style: const TextStyle(
                fontFamily: AppAssets.fontFamilyLato,
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              "Gane code: " + widget.data.gameCode,
              style: const TextStyle(
                fontFamily: AppAssets.fontFamilyLato,
                color: AppColors.lightGrayTextColor,
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: !loadingDone
            ? Center(child: CircularProgressIndicator())
            : Container(
                child: Column(
                  children: [
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
      ),
    );
  }
}
