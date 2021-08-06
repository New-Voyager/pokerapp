import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/hand_history_model.dart';
import 'package:pokerapp/models/player_info.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_screens/hand_history/played_hands.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/hand_service.dart';
import 'package:pokerapp/services/app/player_service.dart';
import 'package:provider/provider.dart';

import '../../../routes.dart';

class HandHistoryListView extends StatefulWidget {
  final HandHistoryListModel data;
  final bool isInBottomSheet;
  final bool isLeadingBackIconShow;

  HandHistoryListView(this.data, this.clubCode,
      {this.isInBottomSheet = false, this.isLeadingBackIconShow = true});

  final String clubCode;

  @override
  _HandHistoryState createState() => _HandHistoryState();
}

class _HandHistoryState extends State<HandHistoryListView>
    with SingleTickerProviderStateMixin, RouteAwareAnalytics {
  @override
  String get routeName => Routes.hand_history_list;
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
    return Consumer<AppTheme>(builder: (_,theme,__)=>Container(
      decoration: AppStylesNew.BgGreenRadialGradient,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          theme:theme,
          showBackButton: !widget.isInBottomSheet,
          context: context,
          titleText: "Hand History",
        ),
        body: !loadingDone
            ? Center(child: CircularProgressWidget())
            : Container(
                child: Column(
                  children: [
                    Container(
                      child: TabBar(
                        unselectedLabelColor: AppColorsNew.lightGrayTextColor,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: AppColorsNew.yellowAccentColor,
                        labelColor: Colors.white,
                        labelStyle: TextStyle(),
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
                            widget.clubCode,
                            currentPlayer,
                            isInBottomSheet: widget.isInBottomSheet,
                          ),
                          PlayedHandsScreen(
                            _data.gameCode,
                            _data.getWinningHands(),
                            widget.clubCode,
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
    ),);
  }
}
