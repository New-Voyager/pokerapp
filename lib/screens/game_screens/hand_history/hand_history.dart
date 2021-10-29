import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/models/hand_history_model.dart';
import 'package:pokerapp/models/player_info.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_screens/hand_history/played_hands.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/screens/game_screens/widgets/hand_history_filter_widget.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/services/app/hand_service.dart';
import 'package:pokerapp/services/app/player_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/services/game_history/game_history_service.dart';
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
  AuthModel currentPlayer;
  AppTextScreen _appScreenText;

  TabController _tabController;

  @override
  void initState() {
    _appScreenText = getAppTextScreen("handHistoryListView");

    _tabController = new TabController(length: 2, vsync: this);
    _data = widget.data;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchData();
    });
  }

  _fetchData() async {
    log("DATA LOG IN HANDHISTORY: $_data");
    currentPlayer = await AuthService.get();
    try {
      _data = await GameHistoryService.getHandHistory(
          _data.gameCode, currentPlayer.playerId);
    } catch (err) {
      await HandService.getAllHands(_data);
    }
    loadingDone = true;
    setState(() {
      // update ui
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
            showBackButton: !widget.isInBottomSheet,
            context: context,
            titleText: _appScreenText['handHistory'],
            actionsList: [
              IconButton(
                onPressed: () {
                  Alerts.showDailog(
                    context: context,
                    child:
                        HandHistoryFilterWidget(winners: _getListOfWinners()),
                  );
                },
                icon: Icon(
                  Icons.filter_alt,
                  color: theme.accentColor,
                ),
              )
            ],
          ),
          body: !loadingDone
              ? Center(child: CircularProgressWidget())
              : Container(
                  child: Column(
                    children: [
                      Container(
                        child: TabBar(
                          unselectedLabelColor: theme.secondaryColorWithDark(),
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: theme.accentColor,
                          labelColor: theme.secondaryColorWithLight(),
                          tabs: [
                            new Tab(
                              text: _appScreenText['allHands'],
                            ),
                            new Tab(
                              text: _appScreenText['winningHands'],
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
      ),
    );
  }

  List<Winner> _getListOfWinners() {
    final List<Winner> winners = [];
    if (_data != null) {
      for (HandHistoryItem item in _data.allHands) {
        for (Winner winner in item?.winners ?? []) {
          final res = winners.indexWhere(
            (element) {
              return element.id == winner.id;
            },
          );
          if (res == -1) {
            winners.add(winner);
          }
        }

        for (Winner winner in item?.lowWinners ?? []) {
          final res = winners.indexWhere(
            (element) {
              return element.id == winner.id;
            },
          );
          if (res == -1) {
            winners.add(winner);
          }
        }
      }
    }
    return winners;
  }
}
