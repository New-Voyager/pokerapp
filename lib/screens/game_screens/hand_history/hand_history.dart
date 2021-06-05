import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/hand_history_model.dart';
import 'package:pokerapp/models/player_info.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/screens/game_screens/hand_history/played_hands.dart';
import 'package:pokerapp/services/app/hand_service.dart';
import 'package:pokerapp/services/app/player_service.dart';

class HandHistoryListView extends StatefulWidget {
  final HandHistoryListModel data;
  final bool isInBottomSheet;
  final bool isLeadingBackIconShow;
  HandHistoryListView(this.data, this._clubCode,
      {this.isInBottomSheet = false, this.isLeadingBackIconShow = true});
  final String _clubCode;

  @override
  _HandHistoryState createState() => _HandHistoryState();
}

class _HandHistoryState extends State<HandHistoryListView>
    with SingleTickerProviderStateMixin {
  bool loadingDone = false;
  HandHistoryListModel _data;
  PlayerInfo currentPlayer;

  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    _data = widget.data;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchData();
    });
  }

  _fetchData() async {
    log("DATA LOG IN HANDHISTORY: $_data");
    await HandService.getAllHands(_data);
    currentPlayer = await PlayerService.getMyInfo(null);
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
          child: widget.isLeadingBackIconShow
              ? Row(
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
                )
              : Container(),
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
              "Game code: " + widget.data.gameCode,
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
                        unselectedLabelColor: AppColors.lightGrayTextColor,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: Colors.white,
                        labelColor: Colors.white,
                        labelStyle: TextStyle(
                          fontFamily: AppAssets.fontFamilyLato,
                        ),
                        tabs: [
                          new Tab(
                            text: "All Hands",
                          ),
                          new Tab(
                            text: "Winning Hands",
                          ),
                        ],
                        controller: _tabController,
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          PlayedHandsScreen(
                            _data.gameCode,
                            _data.getMyHands(),
                            //_data.getAllHands(),
                            widget._clubCode,
                            currentPlayer,
                            isInBottomSheet: widget.isInBottomSheet,
                          ),
                          PlayedHandsScreen(
                            _data.gameCode,
                            _data.getWinningHands(),
                            widget._clubCode,
                            currentPlayer,
                            isInBottomSheet: widget.isInBottomSheet,
                          ),
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
