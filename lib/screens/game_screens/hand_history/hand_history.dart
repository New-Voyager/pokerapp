import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/main_helper.dart';
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
  final bool liveGame;

  HandHistoryListView(this.data, this.clubCode,
      {this.isInBottomSheet = false,
      this.isLeadingBackIconShow = true,
      this.liveGame = false});

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
  List<HandHistoryItem> filteredHands = [];
  bool showFilter = true;
  bool showFilterView = false;
  String filterSelection;
  int filterValue;
  AuthModel currentPlayer;
  AppTextScreen _appScreenText;
  TabController _tabController;

  @override
  void initState() {
    _appScreenText = getAppTextScreen("handHistoryListView");

    _tabController = new TabController(length: 2, vsync: this);
    _data = widget.data;
    if (widget.liveGame) {
      showFilter = false;
    }
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchData();
    });
  }

  _fetchData() async {
    log("DATA LOG IN HANDHISTORY: $_data");
    currentPlayer = await AuthService.get();

    if (widget.liveGame) {
      await HandService.getAllHands(_data);
    } else {
      try {
        _data = await GameHistoryService.getHandHistory(
            _data.gameCode, currentPlayer.playerId);
      } catch (err) {
        await HandService.getAllHands(_data);
      }
    }

    // sort all hands
    _data.sort();
    loadingDone = true;
    setState(() {
      // update ui
    });
  }

  _fetchFilteredData() async {
    loadingDone = false;
    // await Future.delayed(Duration(seconds: 3));
    filteredHands = [];
    if (filterSelection == 'pot-greater') {
      for (final hand in _data.allHands) {
        if (hand.totalPot != null && hand.totalPot >= filterValue) {
          filteredHands.add(hand);
        }
      }
    } else if (filterSelection == 'winner') {
      for (final hand in _data.allHands) {
        bool winner = false;
        for (final w in hand.winners) {
          if (w.id == filterValue) {
            winner = true;
          }
        }
        if (hand.lowWinners != null) {
          for (final w in hand.lowWinners) {
            if (w.id == filterValue) {
              winner = true;
            }
          }
        }
        if (winner) {
          filteredHands.add(hand);
        }
      }
    } else if (filterSelection == 'headsup') {
      for (final hand in _data.allHands) {
        if (hand.headsupPlayers != null) {
          for (int playerId in hand.headsupPlayers) {
            if (playerId == currentPlayer.playerId) {
              filteredHands.add(hand);
              break;
            }
          }
        }
      }
    } else if (filterSelection == 'lost') {
      for (final hand in _data.allHands) {
        if (hand.playersReceived != null) {
          for (int playerId in hand.playersReceived.keys) {
            if (playerId == currentPlayer.playerId) {
              if (hand.playersReceived[playerId] < 0) {
                final val = -hand.playersReceived[playerId];
                if (val > filterValue) {
                  filteredHands.add(hand);
                  break;
                }
              }
            }
          }
        }
      }
    }

    // get data
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
              subTitleText:
                  showFilterView ? _appScreenText['filteredSubTitle'] : null,
              context: context,
              titleText: _appScreenText['handHistory'],
              actionsList: showFilter
                  ? [
                      IconButton(
                        onPressed: () async {
                          if (showFilterView) {
                            showFilterView = false;
                          } else {
                            dynamic ret = await Alerts.showDailog(
                              context: context,
                              child: HandHistoryFilterWidget(
                                winners: _getListOfWinners(),
                              ),
                            );
                            if (ret == null) {
                              return;
                            }

                            if (ret is bool && !ret) {
                              showFilterView = false;
                            } else {
                              Map<String, dynamic> retState =
                                  ret as Map<String, dynamic>;
                              bool status = retState['status'];
                              if (status ?? false) {
                                // show filtered view if not shown already
                                showFilterView = true;

                                filterSelection = retState['selection'];
                                filterValue = retState['value'];
                                loadingDone = false;
                                _fetchFilteredData();
                              }
                            }
                          }
                          setState(() {});
                        },
                        icon: Icon(
                          showFilterView ? Icons.clear : Icons.filter_alt,
                          color: theme.accentColor,
                        ),
                      )
                    ]
                  : null,
            ),
            body: !loadingDone
                ? Center(child: CircularProgressWidget())
                : showFilterView
                    ? getFilteredView(theme)
                    : getMainView(theme)),
      ),
    );
  }

  Widget getFilteredView(AppTheme theme) {
    return PlayedHandsScreen(
      _data.gameCode,
      filteredHands,
      widget.clubCode,
      currentPlayer,
      isInBottomSheet: widget.isInBottomSheet,
    );
  }

  Widget getMainView(AppTheme theme) {
    return Container(
      child: Column(
        children: [
          TabBar(
            physics: const BouncingScrollPhysics(),
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
          Expanded(
            child: TabBarView(
              physics: const BouncingScrollPhysics(),
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
