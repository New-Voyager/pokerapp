import 'package:flutter/material.dart';
import 'package:pokerapp/models/hand_history_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/widgets/card_view.dart';

final _separator = SizedBox(
  height: 10.0,
);

class PlayedHandsScreen extends StatelessWidget {
  List<HandHistoryItem> history;

  PlayedHandsScreen(List<HandHistoryItem> history) {
    this.history = history;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.screenBackgroundColor,
        body: Column(
          children: [
            getHeader(),
            SizedBox(
              height: 5.0,
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return getListItem(index);
                },
                itemCount: history.length,
                separatorBuilder: (context, index) {
                  return Divider();
                },
              ),
            ),
          ],
        ));
  }

  getHeader() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 2.0,
        right: 2.0,
      ),
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          color: Color(0xff313235),
          borderRadius: BorderRadius.all(
            Radius.circular(AppDimensions.cardRadius),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: [
              Text("Hand",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  )),
              SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      flex: 5,
                      fit: FlexFit.tight,
                      child: Text("Winner",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          )),
                    ),
                    Flexible(
                      flex: 6,
                      fit: FlexFit.tight,
                      child: Text("Community",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getListItem(int index) {
    List<Winner> winners = history[index].winners;
    WinnerWidget widget = new WinnerWidget(winners, history[index].community);
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff313235),
          borderRadius: BorderRadius.all(
            Radius.circular(AppDimensions.cardRadius),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              handNumWidget(history[index].handNum),
              widget,
            ],
          ),
        ),
      ),
    );
  }

  Widget handNumWidget(int handNum) {
    return Padding(
        padding: const EdgeInsets.only(left: 4.0, top: 10.0, right: 6.0),
        child: Container(
          width: 30,
          child:
              Text(handNum.toString(), style: TextStyle(color: Colors.white)),
        ));
  }
}

class WinnerWidget extends StatelessWidget {
  List<Winner> winners;
  List<int> community;

  WinnerWidget(List<Winner> winners, List<int> community) {
    this.winners = winners;
    this.community = community;
  }

  List<CommunityCardWidget> getCommunityCards() {
    return [CommunityCardWidget(community, true)];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _separator,
                      Container(child: getWinnersView()),
                    ],
                  ),
                ),
                Flexible(
                  flex: 6,
                  child: Container(
                      margin: EdgeInsets.only(left: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: getCommunityCards(),
                      )),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget getWinnersView() {
    return ListView.separated(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        final winner = this.winners[index];
        return getWinnerWidget(
            name: winner.name,
            cards: winner.cards,
            pot: winner.amount,
            showCards: winner.showCards);
      },
      itemCount: winners.length,
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 20.0,
        );
      },
    );
  }

  Widget getWinnerWidget(
      {String name, List<int> cards, double pot, bool showCards}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: TextStyle(color: Colors.orangeAccent),
              ),
              _separator,
              CardsView(cards, showCards),
              _separator,
              Row(children: [
                Text(
                  'Received: ',
                  style: TextStyle(
                      color: Color(0xff848484), fontWeight: FontWeight.w600),
                ),
                _separator,
                Text(
                  DataFormatter.chipsFormat(pot),
                  style: TextStyle(
                      color: Colors.lightGreenAccent,
                      fontWeight: FontWeight.w600),
                ),
              ]),
              _separator,
            ],
          ),
        ),
      ],
    );
  }
}
