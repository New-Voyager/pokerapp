import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/hand_history_model.dart';
import 'package:pokerapp/models/hand_log_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/hand_log_view.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/widgets/card_view.dart';

final _separator = SizedBox(
  height: 10.0,
);

class PlayedHandsScreen extends StatelessWidget {
  final List<HandHistoryItem> history;
  final String gameCode;
  var _tapPosition;

  PlayedHandsScreen(this.gameCode, this.history);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.screenBackgroundColor,
        body: Column(
          children: [
            getHeader(),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return getListItem(context, index);
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
        top: 5.0,
        bottom: 5.0,
      ),
      child: Container(
        height: 50.0,
        // decoration: BoxDecoration(
        //   color: Color(0xff313235),
        //   borderRadius: BorderRadius.all(
        //     Radius.circular(AppDimensions.cardRadius),
        //   ),
        // ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: [
              Text(
                "Hand",
                style: const TextStyle(
                  fontFamily: AppAssets.fontFamilyLato,
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
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
                      child: Text(
                        "Community",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
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

  void onHistoryItemTapped(context, int index) {
    HandLogModel model =
        new HandLogModel(this.gameCode, history[index].handNum);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HandLogView(model),
      ),
    );
  }

  _storeTapPosition(TapDownDetails tapDownDetails) {
    _tapPosition = tapDownDetails.globalPosition;
  }

  showCustomMenu(context) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    showMenu(
      context: context,
      position: RelativeRect.fromRect(
          _tapPosition & const Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
      items: <PopupMenuEntry>[
        PopupMenuItem(
          value: 0,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Star",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                  Icon(
                    Icons.star_border_outlined,
                    color: Colors.white,
                  ),
                ],
              ),
              Divider(
                color: AppColors.listViewDividerColor,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Share",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                  Icon(
                    Icons.ios_share,
                    color: Colors.white,
                  ),
                ],
              ),
              Divider(
                color: AppColors.listViewDividerColor,
              ),
            ],
          ),
        ),
      ],
    ).then<void>((delta) {
      // delta would be null if user taps on outside the popup menu
      // (causing it to close without making selection)
      if (delta == null) {
        return;
      } else {
        switch (delta) {
          case 0:
            break;
          case 1:
            break;
        }
      }
    });
  }

  getListItem(BuildContext context, int index) {
    WinnerWidget widget = new WinnerWidget(history[index]);
    return Theme(
      data: Theme.of(context).copyWith(
        cardColor: AppColors.popUpMenuColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white),
      ),
      child: Builder(
        builder: (context) {
          return GestureDetector(
            onTapDown: _storeTapPosition,
            onLongPress: () => {showCustomMenu(context)},
            onTap: () => onHistoryItemTapped(context, index),
            child: Padding(
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
            ),
          );
        },
      ),
    );
  }

  Widget handNumWidget(int handNum) {
    return Padding(
        padding: const EdgeInsets.only(left: 4.0, top: 10.0, right: 6.0),
        child: Container(
          width: 30,
          child: Text(
            handNum.toString(),
            style: const TextStyle(
              fontFamily: AppAssets.fontFamilyLato,
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ));
  }
}

class WinnerWidget extends StatelessWidget {
  HandHistoryItem item;

  WinnerWidget(HandHistoryItem item) {
    this.item = item;
  }

  List<Widget> getCommunityCards() {
    List<Widget> communityCards = [
      CommunityCardWidget(item.community, true),
      SizedBox(
        height: 5,
      ),
    ];
    if (item.community1 != null && item.community1.length > 0) {
      communityCards.add(CommunityCardWidget(item.community, true));
    }
    return communityCards;
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
                  flex: 4,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          children: getCommunityCards(),
                        ),
                        Container(
                          child: Text(
                            this.item.handTime,
                            style: const TextStyle(
                              fontFamily: AppAssets.fontFamilyLato,
                              color: AppColors.lightGrayTextColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: AppColors.appAccentColor,
            size: 10,
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
        final winner = this.item.winners[index];
        return getWinnerWidget(
            name: winner.name,
            cards: winner.cards,
            pot: winner.amount,
            showCards: winner.showCards);
      },
      itemCount: this.item.winners.length,
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
                style: const TextStyle(
                  fontFamily: AppAssets.fontFamilyLato,
                  color: Colors.orangeAccent,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              _separator,
              CardsView(cards, showCards),
              _separator,
              Row(children: [
                Text(
                  'Received: ',
                  style: const TextStyle(
                    fontFamily: AppAssets.fontFamilyLato,
                    color: AppColors.lightGrayTextColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                _separator,
                Text(
                  DataFormatter.chipsFormat(pot),
                  style: const TextStyle(
                    fontFamily: AppAssets.fontFamilyLato,
                    color: Colors.lightGreenAccent,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
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
