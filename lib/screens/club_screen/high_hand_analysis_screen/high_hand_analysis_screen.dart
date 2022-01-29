import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/handlog_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/club_screen/high_hand_analysis_screen/dialogs/rank_card_selection_dialog.dart';
import 'package:pokerapp/screens/game_screens/highhand_log/grouped_list_view.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/hand_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/widgets/button_widget.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/child_widgets.dart';
import 'package:pokerapp/widgets/radio_list_widget.dart';
import 'package:jiffy/jiffy.dart';
import 'package:jiffy/src/enums/units.dart';
import 'package:pokerapp/widgets/texts.dart';
import 'package:provider/provider.dart';

class HighHandAnalysisScreen extends StatefulWidget {
  final String clubCode;
  HighHandAnalysisScreen(this.clubCode);

  @override
  State<HighHandAnalysisScreen> createState() => _HighHandAnalysisScreenState();
}

class _HighHandAnalysisScreenState extends State<HighHandAnalysisScreen>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<List<int>> _selectedCards = ValueNotifier<List<int>>([]);
  bool searching = false;
  List<HighHandWinner> result = [];
  bool filterSet = false;
  bool closed = false;
  List<GameType> selectedGames = [];

  HHGroupType groupType = HHGroupType.HOURLY;
  DateTime startDate;
  DateTime endDate;
  int minRank = 322;
  List<GameType> gameTypes;
  GameTypeSelection gameTypesWidget;
  DateTime _fromDate = DateTime.now().subtract(
    Duration(days: 7),
  );
  DateTime _toDate = DateTime.now();
  DateTimeRange _dateTimeRange;
  AnimationController filterExpandController;
  Animation<double> filterExpandAnimation;
  bool isFilterExpanded = true;

  @override
  void dispose() {
    closed = true;
    super.dispose();
  }

  void _selectRankCards(BuildContext context) async {
    final rankCards = await RankCardSelectionDialog.show(
      context: context,
    );

    // if we don't have any cards, return
    if (rankCards == null || rankCards.isEmpty) return;

    // fill the selected cards in the value notifier
    _selectedCards.value = rankCards;
  }

  @override
  void initState() {
    _dateTimeRange = DateTimeRange(
      start: _fromDate,
      end: _toDate,
    );

    super.initState();
    groupType = HHGroupType.HOURLY;
    final now = DateTime.now();
    startDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
    endDate = startDate.add(Duration(days: 1));
    minRank = 322;
    gameTypes = [];
    gameTypes.addAll([
      GameType.HOLDEM,
      GameType.PLO,
      GameType.PLO_HILO,
      GameType.FIVE_CARD_PLO,
      GameType.FIVE_CARD_PLO_HILO,
    ]);
    selectedGames.addAll(gameTypes);
    // loading = true;
    // fetchData();

    initAnimations();
  }

  void initAnimations() {
    filterExpandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    filterExpandAnimation = CurvedAnimation(
      parent: filterExpandController,
      curve: Curves.fastOutSlowIn,
    );
    filterExpandController.forward();
  }

  void fetchData() async {
    ConnectionDialog.show(context: context, loadingText: 'Searching ...');
    try {
      searching = true;
      setState(() {});
      // await Future.delayed(Duration(seconds: 1));
      // dynamic searchResult = jsonDecode(getSearchHands());
      // dynamic hands = searchResult['data']['searchHands'];
      // List<SearchHighHandResult> searchResults = [];
      // for (final data in hands) {
      //   searchResults.add(SearchHighHandResult.fromJson(data));
      // }
      final selectedGameTypes = selectedGames;
      String startDateStr = startDate.toIso8601String();
      String endDateStr = endDate.toIso8601String();

      log('${selectedGameTypes.toString()} Start: $startDateStr End: $endDateStr');
      final searchResults = await HandService.searchHands(widget.clubCode,
          startDate.toUtc(), endDate.toUtc(), selectedGameTypes, minRank);
      GroupHighHandResult group = GroupHighHandResult(
        clubCode: 'sss',
        start: startDate, // DateTime.parse('2021-11-18T00:00:00Z'),
        end: endDate, //DateTime.parse('2021-11-20T23:59:59Z'),
        groupType: groupType, // HHGroupType.HOURLY,
        winners: searchResults,
      );
      final highHands = group.list();
      List<HighHandWinner> highHandWinners = [];
      List<HandResultData> highHandData = [];
      for (final hh in highHands) {
        final log = await HandService.getHandLog(hh.gameCode, hh.handNum);
        if (log != null) {
          highHandData.add(log);
          final playerInfo = log.result.playerInfo;
          for (final board in log.result.boards) {
            for (final playerRank in board.playerBoardRank.values) {
              if (playerRank.hiRank == hh.rank) {
                // this is a high hand
                HighHandWinner hhWinner = HighHandWinner();
                hhWinner.gameCode = hh.gameCode;
                hhWinner.rank = hh.rank;
                hhWinner.hhCards = playerRank.hiCards;
                hhWinner.boardCards = board.cards;
                hhWinner.handTime = hh.handTime;
                hhWinner.handNum = hh.handNum;
                hhWinner.winner = true;
                hhWinner.player = playerInfo[playerRank.seatNo].name;
                hhWinner.playerCards = playerInfo[playerRank.seatNo].cards;
                highHandWinners.add(hhWinner);
              }
            }
          }
        }
      }

      // dynamic json = jsonDecode(getHHLog());
      // List hhWinnersData = json['hhWinners'];
      // result = hhWinnersData.map((e) {
      //   HighHandWinner winner = new HighHandWinner.fromJson(e);
      //   //winner.gameCode = gameCode;
      //   return winner;
      // }).toList();

      // result = highHandWinners.map((e) {
      //   HighHandWinner winner = new HighHandWinner.fromJson(e);
      //   //winner.gameCode = gameCode;
      //   return winner;
      // }).toList();

      result = highHandWinners;
      isFilterExpanded = false;
      filterExpandController.reverse();
    } catch (err) {
      log('error: ${err.toString()}, ${err.stackTrace}');
    }
    ConnectionDialog.dismiss(context: context);
    searching = false;
    if (!closed) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.getTheme(context);

    return getHighHand(context);
  }

  Widget test(AppTheme theme, BuildContext context) {
    return Container(
      decoration: AppDecorators.bgRadialGradient(theme),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: IntrinsicHeight(
            child: ButtonWidget(
              text: 'Select',
              onTap: () {
                _selectRankCards(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget getHighHand(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    // Widget gameTypeSelection = ListenableProvider(create: selectedGames,
    //     builder: (_, games, __), {
    //         return GameTypeSelection();
    //       });

    // gameTypesWidget.selectedGames = gameTypes;
    // if (searching) {
    //   return Container(
    //     decoration: AppDecorators.bgRadialGradient(theme),
    //     child: Scaffold(
    //       backgroundColor: Colors.transparent,
    //       body: Center(
    //         child: CircularProgressWidget(),
    //       ),
    //     ),
    //   );
    // }
    return Container(
      decoration: AppDecorators.bgRadialGradient(theme),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          theme: theme,
          context: context,
          titleText: 'High Hand Analysis',
        ),
        body: SafeArea(
          child: ListView(
            //     // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 8),
              SizeTransition(
                axisAlignment: 1.0,
                sizeFactor: filterExpandAnimation,
                child: filterWidget(theme),
              ),
              SizedBox(height: 8),
              Stack(
                children: [
                  Center(child: searchButton(theme)),
                  (!isFilterExpanded)
                      ? Positioned(
                          right: 8,
                          top: 4,
                          child: IconButton(
                            constraints: BoxConstraints(),
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              setState(() {
                                isFilterExpanded = true;
                              });
                              filterExpandController.forward();
                            },
                            icon: Icon(
                              Icons.filter_alt_outlined,
                              color: theme.accentColor,
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
              SizedBox(height: 20),
              Divider(height: 3, thickness: 3, color: theme.accentColor),
              SizedBox(height: 10),
              ...getResult(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget filterWidget(theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(children: [
        ...rankSelectionWidget(theme),
        SizedBox(
          height: 16.pw,
        ),
        ...dateSelectionFilter(theme),
        SizedBox(
          height: 16.pw,
        ),
        ...groupFilter(theme),
        ...gameTypesSelectionWidget(theme),
      ]),
    );
  }

  List<Widget> rankSelectionWidget(AppTheme theme) {
    return [
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
            flex: 3, child: LabelText(label: 'Minimum Rank', theme: theme)),
        SizedBox(
          width: 8.pw,
        ),
        Expanded(
          flex: 7,
          child: RadioToggleButtonsWidget<String>(
            defaultValue: 0,
            values: ['Full House', 'Four Of Kind', 'Straight Flush'],
            onSelect: (int value) {
              if (value == 0) {
                minRank = 322;
              } else if (value == 1) {
                minRank = 166;
              } else if (value == 2) {
                minRank = 10;
              }
              log('value: ${value}');
            },
          ),
        ),
      ]),
    ];
  }

  List<Widget> dateSelectionFilter(AppTheme theme) {
    DateTime date = endDate.subtract(Duration(days: 1));
    String startDateStr = DateFormat('dd MMM').format(startDate);
    String endDateStr = DateFormat('dd MMM').format(date);

    return [
      Column(
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
                flex: 3, child: LabelText(label: 'Date Range', theme: theme)),
            SizedBox(
              width: 8.pw,
            ),
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RadioToggleButtonsWidget<String>(
                    defaultValue: 0,
                    values: [
                      'Today',
                      'Yesterday',
                      'This Week',
                      'Custom',
                      // 'Last Week',
                      // 'Last Month'
                    ],
                    onSelect: (int value) async {
                      final now = DateTime.now();
                      if (value == 0) {
                        startDate =
                            DateTime(now.year, now.month, now.day, 0, 0, 0);
                        endDate = startDate.add(Duration(days: 1));
                        setState(() {});
                      } else if (value == 1) {
                        startDate = now.subtract(Duration(days: 1));
                        startDate = DateTime(startDate.year, startDate.month,
                            startDate.day, 0, 0, 0);
                        endDate = startDate.add(Duration(days: 1));
                        setState(() {});
                      } else if (value == 2) {
                        startDate = now.subtract(Duration(days: now.weekday));
                        startDate = DateTime(startDate.year, startDate.month,
                            startDate.day, 0, 0, 0);
                        endDate = startDate.add(Duration(days: 7));
                        setState(() {});
                      } else if (value == 'Last Week') {
                        endDate =
                            DateTime(now.year, now.month, now.day, 0, 0, 0);
                        endDate =
                            endDate.subtract(Duration(days: endDate.weekday));
                        startDate = DateTime.parse(
                            Jiffy(endDate.toIso8601String())
                                .subtract(weeks: 1)
                                .format('yyyy-MM-dd'));
                        setState(() {});
                      } else if (value == 'This Month') {
                        startDate = DateTime(now.year, now.month, 1, 0, 0, 0);
                        endDate = DateTime.parse(Jiffy()
                            .startOf(Units.MONTH)
                            .add(months: 1)
                            .format('yyyy-MM-dd'));
                        setState(() {});
                      } else if (value == 'Last Month') {
                        endDate = DateTime(now.year, now.month, 1, 0, 0, 0);
                        startDate = DateTime.parse(
                            Jiffy(startDate.toIso8601String())
                                .subtract(months: 1)
                                .format('yyyy-MM-dd'));
                        setState(() {});
                      } else if (value == 3) {
                        await _handleDateRangePicker(context, theme);
                        startDate = _dateTimeRange.start;
                        endDate = _dateTimeRange.end.add(Duration(days: 1));
                        setState(() {});
                      }

                      log('Start Date: ${startDate.toIso8601String()}  End Date: ${endDate.toIso8601String()}');
                    },
                  ),
                  SizedBox(
                    height: 8.ph,
                  ),
                ],
              ),
            ),
          ]),
          Row(crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(child: Text('Selected Dates')),
                SizedBox(
                  width: 8.pw,
                ),
                Expanded(
                  child: Text((startDateStr != endDateStr)
                      ? '${startDateStr} - ${endDateStr}'
                      : '$startDateStr'),
                ),
              ]),
        ],
      ),
    ];
  }

  _handleDateRangePicker(BuildContext context, AppTheme theme) async {
    final dateRange = await showDateRangePicker(
      initialDateRange: _dateTimeRange,
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 3650)),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: theme.primaryColor,
            accentColor: theme.accentColor,
            colorScheme: ColorScheme.light(primary: theme.primaryColor),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );

    if (dateRange != null) {
      _dateTimeRange = dateRange;
    }
  }

  List<Widget> groupFilter(AppTheme theme) {
    return [
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(flex: 3, child: LabelText(label: 'Group', theme: theme)),
        SizedBox(
          width: 8.pw,
        ),
        Expanded(
          flex: 7,
          child: RadioToggleButtonsWidget<String>(
            defaultValue: 0,
            values: [
              // '30 mins',
              'Hourly',
              'Daily',
            ],
            onSelect: (int value) {
              log('value: ${value}');
              if (value == 0) {
                groupType = HHGroupType.HOURLY;
              } else if (value == 1) {
                groupType = HHGroupType.DAILY;
              }
            },
          ),
        ),
      ]),
    ];
  }

  List<Widget> gameTypesSelectionWidget(theme) {
    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: LabelText(label: 'Game Types', theme: theme),
              )),
          Expanded(flex: 7, child: GameTypeSelection(this.selectedGames)),
        ],
      ),
    ];
  }

  Widget searchButton(AppTheme theme) {
    return RoundRectButton(
      onTap: () {
        fetchData();
      },
      icon: Icon(
        Icons.search,
        color: theme.roundButtonTextColor,
      ),
      text: "Search",
      theme: theme,
      fontSize: 16,
    );
  }

  List<Widget> getResult(AppTheme theme) {
    if ((result?.length ?? 0) == 0) {
      return [
        Center(
          child: Column(
              children: [SizedBox(height: 70), Text("No Data available")]),
        )
      ];
    } else {
      // DateTime start = DateTime(2021, 11, 17);
      // DateTime end = DateTime(2021, 11, 19, 23, 59, 59);
      GroupHighHands winners = GroupHighHands(
          theme: theme,
          start: startDate,
          end: endDate,
          winners: this.result,
          clubCode: widget.clubCode,
          groupType: HHGroupType.HOURLY);
      return winners.list();
    }
  }
}

String getHHLog() {
  return '''
{
	"__typename": "Query",
	"hhWinners": [{
		"__typename": "HighHand",
		"playerUuid": "5cd96779-c6b2-4dba-a814-f365b6b48aeb",
		"playerName": "rob",
		"playerCards": "[145,178,177,65]",
		"boardCards": "[200,81,130,180,184]",
		"highHand": "[178,177,200,180,184]",
		"handTime": "2021-11-18T22:46:54.000Z",
		"handNum": 47,
    "gameCode": "cgbhstmg",
		"winner": true
	}, {
		"__typename": "HighHand",
		"playerUuid": "8a159f59-bd78-4bce-a39b-fc32d63200ec",
		"playerName": "bill",
		"playerCards": "[113,184,180,17]",
		"boardCards": "[114,178,34,82,177]",
		"highHand": "[184,180,114,178,177]",
		"handTime": "2021-11-18T22:44:19.000Z",
		"handNum": 43,
    "gameCode": "cgbhstmg",
		"winner": false
	}, {
		"__typename": "HighHand",
		"playerUuid": "d04d24d1-be90-4c02-b8fb-c2499d9b76ed",
		"playerName": "john",
		"playerCards": "[104,196,82,113]",
		"boardCards": "[200,193,116,81,8]",
		"highHand": "[196,113,200,193,116]",
		"handTime": "2021-11-18T22:15:11.000Z",
		"handNum": 6,
    "gameCode": "cgbhstmg",
		"winner": false
	}, {
		"__typename": "HighHand",
		"playerUuid": "e9e2ee8b-2e2d-4659-a61d-4439fc274e1b",
		"playerName": "michael",
		"playerCards": "[177,184,152,4]",
		"boardCards": "[56,20,180,113,17]",
		"highHand": "[177,184,20,180,17]",
		"handTime": "2021-11-18T22:13:56.000Z",
		"handNum": 5,
    "gameCode": "cgbhstmg",
		"winner": false
	}, {
		"__typename": "HighHand",
		"playerUuid": "5cd96779-c6b2-4dba-a814-f365b6b48aeb",
		"playerName": "rob",
		"playerCards": "[132,148,129,82]",
		"boardCards": "[98,72,20,130,68]",
		"highHand": "[132,129,72,130,68]",
		"handTime": "2021-11-18T22:11:04.000Z",
		"handNum": 2,
    "gameCode": "cgbhstmg",
		"winner": false
	}, {
		"__typename": "HighHand",
		"playerUuid": "5cd96779-c6b2-4dba-a814-f365b6b48aeb",
		"playerName": "rob",
		"playerCards": "[132,148,129,82]",
		"boardCards": "[98,72,20,130,68]",
		"highHand": "[132,129,72,130,68]",
		"handTime": "2021-11-18T21:11:04.000Z",
		"handNum": 2,
    "gameCode": "cgbhstmg",
		"winner": false
	}, {
		"__typename": "HighHand",
		"playerUuid": "5cd96779-c6b2-4dba-a814-f365b6b48aeb",
		"playerName": "rob",
		"playerCards": "[132,148,129,82]",
		"boardCards": "[98,72,20,130,68]",
		"highHand": "[132,129,72,130,68]",
		"handTime": "2021-11-18T21:10:04.000Z",
		"handNum": 2,
    "gameCode": "cgbhstmg",
		"winner": false
	},
 {
		"__typename": "HighHand",
		"playerUuid": "5cd96779-c6b2-4dba-a814-f365b6b48aeb",
		"playerName": "rob",
		"playerCards": "[132,148,129,82]",
		"boardCards": "[98,72,20,130,68]",
		"highHand": "[132,129,72,130,68]",
		"handTime": "2021-11-17T21:11:04.000Z",
		"handNum": 2,
    "gameCode": "cgbhstmg",
		"winner": false
	}, {
		"__typename": "HighHand",
		"playerUuid": "5cd96779-c6b2-4dba-a814-f365b6b48aeb",
		"playerName": "rob",
		"playerCards": "[132,148,129,82]",
		"boardCards": "[98,72,20,130,68]",
		"highHand": "[132,129,72,130,68]",
		"handTime": "2021-11-17T21:10:04.000Z",
		"handNum": 2,
    "gameCode": "cgbhstmg",
		"winner": false
	}
  ]
}

  ''';
}

String getSearchHands() {
  return '''
{
  "data": {
    "searchHands": [
      {
        "rank": 270,
        "handNum": 1,
        "handTime": "2021-11-19T20:16:54.000Z",
        "gameCode": "cgocatdh"
      },
      {
        "rank": 109,
        "handNum": 2,
        "handTime": "2021-11-19T20:17:49.000Z",
        "gameCode": "cgthcwmi"
      },
      {
        "rank": 287,
        "handNum": 2,
        "handTime": "2021-11-19T20:18:02.000Z",
        "gameCode": "cgoblksn"
      },
      {
        "rank": 191,
        "handNum": 2,
        "handTime": "2021-11-19T20:18:24.000Z",
        "gameCode": "cgocatdh"
      },
      {
        "rank": 194,
        "handNum": 3,
        "handTime": "2021-11-19T20:19:38.000Z",
        "gameCode": "cgkhimxp"
      },
      {
        "rank": 185,
        "handNum": 4,
        "handTime": "2021-11-19T20:19:41.000Z",
        "gameCode": "cgthcwmi"
      },
      {
        "rank": 247,
        "handNum": 4,
        "handTime": "2021-11-19T20:20:45.000Z",
        "gameCode": "cgoblksn"
      },
      {
        "rank": 203,
        "handNum": 6,
        "handTime": "2021-11-19T20:21:25.000Z",
        "gameCode": "cgthcwmi"
      },
      {
        "rank": 239,
        "handNum": 6,
        "handTime": "2021-11-19T20:21:25.000Z",
        "gameCode": "cgpndjwb"
      },
      {
        "rank": 221,
        "handNum": 4,
        "handTime": "2021-11-19T20:21:36.000Z",
        "gameCode": "cgocatdh"
      },
      {
        "rank": 273,
        "handNum": 7,
        "handTime": "2021-11-19T20:22:37.000Z",
        "gameCode": "cgpndjwb"
      },
      {
        "rank": 308,
        "handNum": 5,
        "handTime": "2021-11-19T20:22:47.000Z",
        "gameCode": "cgocatdh"
      },
      {
        "rank": 240,
        "handNum": 6,
        "handTime": "2021-11-19T20:22:48.000Z",
        "gameCode": "cgoblksn"
      },
      {
        "rank": 286,
        "handNum": 8,
        "handTime": "2021-11-19T20:23:10.000Z",
        "gameCode": "cgthcwmi"
      },
      {
        "rank": 211,
        "handNum": 7,
        "handTime": "2021-11-19T20:23:34.000Z",
        "gameCode": "cgoblksn"
      },
      {
        "rank": 248,
        "handNum": 9,
        "handTime": "2021-11-19T20:25:40.000Z",
        "gameCode": "cgoblksn"
      },
      {
        "rank": 227,
        "handNum": 11,
        "handTime": "2021-11-19T20:25:43.000Z",
        "gameCode": "cgthcwmi"
      },
      {
        "rank": 170,
        "handNum": 12,
        "handTime": "2021-11-19T20:26:30.000Z",
        "gameCode": "cgthcwmi"
      },
      {
        "rank": 302,
        "handNum": 10,
        "handTime": "2021-11-19T20:26:54.000Z",
        "gameCode": "cgoblksn"
      },
      {
        "rank": 206,
        "handNum": 9,
        "handTime": "2021-11-19T20:27:22.000Z",
        "gameCode": "cgocatdh"
      },
      {
        "rank": 221,
        "handNum": 14,
        "handTime": "2021-11-19T20:28:04.000Z",
        "gameCode": "cgthcwmi"
      },
      {
        "rank": 311,
        "handNum": 10,
        "handTime": "2021-11-19T20:28:22.000Z",
        "gameCode": "cgocatdh"
      },
      {
        "rank": 181,
        "handNum": 11,
        "handTime": "2021-11-19T20:29:25.000Z",
        "gameCode": "cgocatdh"
      },
      {
        "rank": 320,
        "handNum": 14,
        "handTime": "2021-11-19T20:30:26.000Z",
        "gameCode": "cgpndjwb"
      },
      {
        "rank": 238,
        "handNum": 14,
        "handTime": "2021-11-19T20:31:02.000Z",
        "gameCode": "cgoblksn"
      },
      {
        "rank": 319,
        "handNum": 16,
        "handTime": "2021-11-19T20:32:19.000Z",
        "gameCode": "cgpndjwb"
      },
      {
        "rank": 304,
        "handNum": 20,
        "handTime": "2021-11-19T20:32:23.000Z",
        "gameCode": "cgthcwmi"
      },
      {
        "rank": 320,
        "handNum": 16,
        "handTime": "2021-11-19T20:32:34.000Z",
        "gameCode": "cgoblksn"
      },
      {
        "rank": 314,
        "handNum": 14,
        "handTime": "2021-11-19T20:32:51.000Z",
        "gameCode": "cgocatdh"
      },
      {
        "rank": 63,
        "handNum": 17,
        "handTime": "2021-11-19T20:33:18.000Z",
        "gameCode": "cgoblksn"
      },
      {
        "rank": 41,
        "handNum": 17,
        "handTime": "2021-11-19T20:33:24.000Z",
        "gameCode": "cgpndjwb"
      },
      {
        "rank": 222,
        "handNum": 19,
        "handTime": "2021-11-19T20:35:02.000Z",
        "gameCode": "cgoblksn"
      },
      {
        "rank": 215,
        "handNum": 24,
        "handTime": "2021-11-19T18:45:04.000Z",
        "gameCode": "cgthcwmi"
      },
      {
        "rank": 239,
        "handNum": 19,
        "handTime": "2021-11-19T18:36:20.000Z",
        "gameCode": "cgpndjwb"
      },
      {
        "rank": 198,
        "handNum": 25,
        "handTime": "2021-11-19T18:35:46.000Z",
        "gameCode": "cgthcwmi"
      }
    ]
  }
}

  ''';
}
