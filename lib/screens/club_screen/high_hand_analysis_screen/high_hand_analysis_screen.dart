import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/club_screen/high_hand_analysis_screen/dialogs/rank_card_selection_dialog.dart';
import 'package:pokerapp/screens/game_screens/highhand_log/grouped_list_view.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/widgets/button_widget.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/child_widgets.dart';
import 'package:pokerapp/widgets/radio_list_widget.dart';
import 'package:provider/provider.dart';

class HighHandAnalysisScreen extends StatefulWidget {
  final String clubCode;
  HighHandAnalysisScreen(this.clubCode);

  @override
  State<HighHandAnalysisScreen> createState() => _HighHandAnalysisScreenState();
}

class _HighHandAnalysisScreenState extends State<HighHandAnalysisScreen> {
  final ValueNotifier<List<int>> _selectedCards = ValueNotifier<List<int>>([]);
  bool loading = false;
  List<HighHandWinner> result;

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
    super.initState();
    loading = true;
    fetchData();
  }

  void fetchData() async {
    try {
      loading = true;
      dynamic json = jsonDecode(getHHLog());
      List hhWinnersData = json['hhWinners'];
      result = hhWinnersData.map((e) {
        HighHandWinner winner = new HighHandWinner.fromJson(e);
        //winner.gameCode = gameCode;
        return winner;
      }).toList();
    } catch (err) {
      log('error: ${err.toString()}');
    }
    loading = false;
    setState(() {});
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
    if (loading) {
      return Container(
        decoration: AppDecorators.bgRadialGradient(theme),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: CircularProgressWidget(),
          ),
        ),
      );
    }
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
          child:  ListView(
          //     // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ...rankSelectionWidget(theme),
                ...dateSelectionFilter(theme),
                ...groupFilter(theme),
                SizedBox(height: 20),
                Center(child: searchButton(theme)),
                ...getResult(theme),
              ],
          ),
        ),
      ),
    );
  }

  List<Widget> rankSelectionWidget(AppTheme theme) {
    return [
      Center(child: AppLabel('Minimum Rank', theme)),
      SizedBox(
        height: 8,
      ),
      Center(
          child: RadioListWidget<String>(
              defaultValue: 'Full House',
              values: ['Full House', 'Four Of Kind', 'Straight Flush'],
              onSelect: (String value) {
                log('value: ${value}');
              })),
    ];
  }

  List<Widget> dateSelectionFilter(AppTheme theme) {
    return [
      Center(child: AppLabel('Date Range', theme)),
      SizedBox(
        height: 8,
      ),
      Center(
          child: RadioListWidget<String>(
              defaultValue: 'Today',
              values: [
                'Today',
                'Yesterday',
                'This Week',
                'Last Week',
                'This Month',
                'Last Month'
              ],
              onSelect: (String value) {
                log('value: ${value}');
              })),
    ];
  }


  List<Widget> groupFilter(AppTheme theme) {
    return [
      Center(child: AppLabel('Group', theme)),
      SizedBox(
        height: 8,
      ),
      Center(
          child: RadioListWidget<String>(
              defaultValue: 'Hourly',
              values: [
                // '30 mins',
                'Hourly',
                'Daily',
              ],
              onSelect: (String value) {
                log('value: ${value}');
              })),
    ];
  }

  Widget searchButton(AppTheme theme) {
    return RoundRectButton(
      onTap: () {},
      text: "Search",
      theme: theme,
      fontSize: 16,
    );
  }

  List<Widget> getResult(AppTheme theme) {
    if ((result?.length ?? 0) == 0) {
      return [Center(
                    child: Text("No Data available"),
                  )];
    } else {
      // return GroupedHandLogListView(
      //                 winners: this.result,
      //                 clubCode: widget.clubCode,
      //                 theme: theme,
      //               );

        GroupedWinnersProcess winners = GroupedWinnersProcess(theme, this.result, widget.clubCode, HHGroupType.HOURLY);
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
	}]
}

  ''';
}
